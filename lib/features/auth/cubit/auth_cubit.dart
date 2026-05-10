import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../gen/locale_keys.g.dart';
import '../data/repo/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit(this.repo) : super(AuthInitial());

  bool _isUnverified(String message) {
    final msg = message.toLowerCase();
    return msg.contains("verify") || 
           msg.contains("verified") || 
           msg.contains("confirm") ||
           msg.contains("activation");
  }

  Future login({
    required String countryCode,
    required String phoneNumber,
    required String password
  }) async {
    emit(AuthLoading());

    try {
      final data = await repo.login(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        password: password
      );

      debugPrint("LOGIN RESPONSE: $data");

      final statusValue = data['status']?.toString().toLowerCase();
      final messageValue = (data['message'] ?? "").toString().toLowerCase();

      final isSuccess = statusValue == "true" || 
                        statusValue == "success" || 
                        statusValue == "1" ||
                        messageValue.contains("success") ||
                        messageValue.contains("welcome") ||
                        data['token'] != null;

      if (isSuccess) {
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
          'token',
          token,
        );

        emit(AuthSuccess());
      } else {
        if (_isUnverified(messageValue)) {
          emit(AuthUnverified());
        } else {
          emit(AuthError(data['message'] ?? "Login failed"));
        }
      }

    } on DioException catch (e) {
      debugPrint("LOGIN ERROR: ${e.response?.data}");
      final statusCode = e.response?.statusCode;
      final serverData = e.response?.data;
      
      String serverMessage = "";
      if (serverData is Map) {
        serverMessage = serverData['message'] ?? serverData['error'] ?? "";
      } else if (serverData is String) {
        serverMessage = serverData;
      }

      if (_isUnverified(serverMessage)) {
        emit(AuthUnverified());
        return;
      }

      switch (statusCode) {
        case 400:
          emit(AuthError(serverMessage.isEmpty ? LocaleKeys.case_400.tr() : serverMessage));
          break;
        case 401:
          emit(AuthError(serverMessage.isEmpty ? LocaleKeys.case_401.tr() : serverMessage));
          break;
        case 404:
          emit(AuthError(LocaleKeys.case_404.tr()));
          break;
        case 500:
          emit(AuthError(LocaleKeys.case_500.tr()));
          break;
        case 302:
          emit(AuthError(LocaleKeys.case_302.tr()));
          break;
        default:
          if (e.response == null) {
            emit(AuthError(LocaleKeys.no_internet.tr()));
          } else {
            emit(AuthError(serverMessage.isEmpty ? LocaleKeys.smth_went_wrong.tr() : serverMessage));
          }
      }

    } catch (e) {
      emit(AuthError(LocaleKeys.unexp_error.tr()));
    }
  }

  Future register({
    required String userName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      final data = await repo.register(
          userName: userName,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password
      );

      debugPrint("REGISTER RESPONSE DATA: $data");

      final statusValue = data['status']?.toString().toLowerCase();
      final messageValue = (data['message'] ?? "").toString().toLowerCase();

      // Flexible success check
      final isSuccess = statusValue == "true" ||
                        statusValue == "success" || 
                        statusValue == "1" ||
                        messageValue.contains("success") || 
                        messageValue.contains("created");

      if (isSuccess) {
        emit(RegisterSuccess());
      } else {
        if (messageValue.contains("email") && (messageValue.contains("already") || messageValue.contains("exist"))) {
          emit(RegisterError(LocaleKeys.case_400_email.tr()));
        } else if (messageValue.contains("username") && (messageValue.contains("already") || messageValue.contains("taken"))) {
          emit(RegisterError(LocaleKeys.case_400_userName.tr()));
        } else if (messageValue.contains("phone") && (messageValue.contains("already") || messageValue.contains("used") || messageValue.contains("exist"))) {
          emit(RegisterError(LocaleKeys.case_400_phone.tr()));
        } else if (password.length < 8) {
          emit(RegisterError(LocaleKeys.weak_pass.tr()));
        } else {
          emit(RegisterError(messageValue.isEmpty ? LocaleKeys.smth_went_wrong.tr() : (data['message'] ?? "Unknown error")));
        }
      }

    } on DioException catch (e) {
      debugPrint("STATUS CODE: ${e.response?.statusCode}");
      debugPrint("DATA: ${e.response?.data}");
      debugPrint("MESSAGE: ${e.message}");

      final statusCode = e.response?.statusCode;
      final serverData = e.response?.data;
      String serverMessage = "";
      
      if (serverData is Map) {
        serverMessage = serverData['message'] ?? serverData['error'] ?? "";
      } else if (serverData is String) {
        serverMessage = serverData;
      }

      final lowerMessage = serverMessage.toLowerCase();

      if (lowerMessage.contains("email") && (lowerMessage.contains("already") || lowerMessage.contains("exist"))) {
        emit(RegisterError(LocaleKeys.case_400_email.tr()));
      } else if (lowerMessage.contains("username") && (lowerMessage.contains("already") || lowerMessage.contains("taken"))) {
        emit(RegisterError(LocaleKeys.case_400_userName.tr()));
      } else if (lowerMessage.contains("phone") && (lowerMessage.contains("already") || lowerMessage.contains("used") || lowerMessage.contains("exist"))) {
        emit(RegisterError(LocaleKeys.case_400_phone.tr()));
      } else if (serverMessage.isNotEmpty) {
        emit(RegisterError(serverMessage));
      } else {
        switch (statusCode) {
          case 401:
            emit(RegisterError(LocaleKeys.case_401.tr()));
            break;
          case 500:
            emit(RegisterError(LocaleKeys.case_500_reg.tr()));
            break;
          default:
            if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout) {
              emit(RegisterError(LocaleKeys.connection_timeout.tr()));
            } else if (e.type == DioExceptionType.connectionError) {
              emit(RegisterError(LocaleKeys.no_internet.tr()));
            } else {
              emit(RegisterError(LocaleKeys.smth_went_wrong.tr()));
            }
        }
      }

    } catch (e) {
      emit(RegisterError(LocaleKeys.unexp_error.tr()));
    }
  }

  Future forgotPassword({
    required String countryCode,
    required String phoneNumber,
  }) async {
    emit(ForgotPasswordLoading());

    try {
      final data = await repo.forgotPassword(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      debugPrint("FORGOT PASSWORD RESPONSE: $data");

      final statusValue = data['status']?.toString().toLowerCase();
      final messageValue = (data['message'] ?? "").toString().toLowerCase();

      final isSuccess = statusValue == "true" || 
                        statusValue == "success" || 
                        statusValue == "1" ||
                        messageValue.contains("success") ||
                        messageValue.contains("sent");

      if (isSuccess) {
        emit(ForgotPasswordSuccess());
      } else {
        emit(ForgotPasswordError(data['message'] ?? "Failed to send code"));
      }
    } on DioException catch (e) {
      debugPrint("FORGOT PASSWORD ERROR: ${e.response?.data}");
      final serverData = e.response?.data;
      String serverMessage = "Failed to send code";
      if (serverData is Map) {
        serverMessage = serverData['message'] ?? serverData['error'] ?? "Failed to send code";
      } else if (serverData != null && serverData.toString().isNotEmpty) {
        serverMessage = serverData.toString();
      }
      emit(ForgotPasswordError(serverMessage));
    } catch (e) {
      emit(ForgotPasswordError("Something went wrong"));
    }
  }

  Future verifyCode({
    String? countryCode,
    String? phoneNumber,
    String? email,
    required String otpCode,
  }) async {
    emit(VerifyLoading());

    try {
      final data = await repo.verifyCode(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        email: email,
        otpCode: otpCode,
      );

      debugPrint("VERIFY OTP RESPONSE: $data");

      final statusValue = data['status']?.toString().toLowerCase();
      final messageValue = (data['message'] ?? "").toString().toLowerCase();

      final isSuccess = statusValue == "true" || 
                        statusValue == "success" || 
                        statusValue == "1" ||
                        messageValue.contains("success") ||
                        messageValue.contains("verified") ||
                        messageValue.contains("correct");

      if (isSuccess) {
        emit(VerifySuccess());
      } else {
        emit(VerifyError(data['message'] ?? "Verification failed"));
      }
    } on DioException catch (e) {
      debugPrint("VERIFY OTP ERROR: ${e.response?.data}");
      final serverData = e.response?.data;
      String serverMessage = "Verification failed";
      if (serverData is Map) {
        serverMessage = serverData['message'] ?? serverData['error'] ?? "Verification failed";
      } else if (serverData != null && serverData.toString().isNotEmpty) {
        serverMessage = serverData.toString();
      }
      emit(VerifyError(serverMessage));
    } catch (e) {
      emit(VerifyError("Something went wrong"));
    }
  }

  Future resetPassword({
    required String countryCode,
    required String phoneNumber,
    required String newPassword,
    required String confirmPassword
  }) async {
    emit(ResetPasswordLoading());

    try {
      debugPrint("RESET PASSWORD DATA SENDING:");
      debugPrint("CountryCode: $countryCode");
      debugPrint("PhoneNumber: $phoneNumber");

      final data = await repo.resetPassword(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      debugPrint("RESET PASSWORD RESPONSE: $data");

      final statusValue = data['status']?.toString().toLowerCase();
      final messageValue = (data['message'] ?? "").toString().toLowerCase();

      final isSuccess =
          statusValue == "true" ||
              statusValue == "success" ||
              statusValue == "1" ||
              messageValue.contains("success") ||
              messageValue.contains("reset") ||
              messageValue.contains("changed");

      if (isSuccess) {
        emit(ResetPasswordSuccess());
      } else {
        emit(
          ResetPasswordError(
            data['message'] ?? "Reset password failed",
            // TODO: TRANSLATE RESET PASSWORD FAILED
          ),
        );
      }

    } on DioException catch (e) {

      debugPrint("RESET PASSWORD STATUS CODE: ${e.response?.statusCode}");
      debugPrint("RESET PASSWORD ERROR DATA: ${e.response?.data}");

      final statusCode = e.response?.statusCode;
      final serverData = e.response?.data;

      String serverMessage = "";

      if (serverData is Map) {
        serverMessage =
            serverData['message'] ??
                serverData['error'] ??
                "";
      } else if (serverData is String) {
        serverMessage = serverData;
      }

      final lowerMessage = serverMessage.toLowerCase();

      // Password mismatch
      if (lowerMessage.contains("match")) {
        emit(
          ResetPasswordError(
            "Passwords do not match",
            // TODO: TRANSLATE PASSWORDS DO NOT MATCH
          ),
        );
      }

      // Weak password
      else if (
      lowerMessage.contains("weak") ||
          lowerMessage.contains("uppercase") ||
          lowerMessage.contains("special") ||
          lowerMessage.contains("number") ||
          lowerMessage.contains("8")
      ) {
        emit(
          ResetPasswordError(
            "Password is too weak",
            // TODO: TRANSLATE WEAK PASSWORD
          ),
        );
      }

      // Phone missing
      else if (lowerMessage.contains("phone")) {
        emit(
          ResetPasswordError(
            "Phone number is required",
            // TODO: TRANSLATE PHONE NUMBER REQUIRED
          ),
        );
      }

      // Country code missing
      else if (lowerMessage.contains("country")) {
        emit(
          ResetPasswordError(
            "Country code is required",
            // TODO: TRANSLATE COUNTRY CODE REQUIRED
          ),
        );
      }

      else {
        switch (statusCode) {

          case 400:
            emit(
              ResetPasswordError(
                serverMessage.isEmpty
                    ? "Invalid request"
                    : serverMessage,
                // TODO: TRANSLATE INVALID REQUEST
              ),
            );
            break;

          case 401:
            emit(
              ResetPasswordError(
                "Unauthorized request",
                // TODO: TRANSLATE UNAUTHORIZED REQUEST
              ),
            );
            break;

          case 404:
            emit(
              ResetPasswordError(
                "User not found",
                // TODO: TRANSLATE USER NOT FOUND
              ),
            );
            break;

          case 500:
            emit(
              ResetPasswordError(
                "Server error, please try again later",
                // TODO: TRANSLATE SERVER ERROR
              ),
            );
            break;

          default:

            if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout) {

              emit(
                ResetPasswordError(
                  "Connection timeout",
                  // TODO: TRANSLATE CONNECTION TIMEOUT
                ),
              );

            } else if (e.type == DioExceptionType.connectionError) {

              emit(
                ResetPasswordError(
                  "No internet connection",
                  // TODO: TRANSLATE NO INTERNET
                ),
              );

            } else {

              emit(
                ResetPasswordError(
                  serverMessage.isEmpty
                      ? "Something went wrong"
                      : serverMessage,
                  // TODO: TRANSLATE SOMETHING WENT WRONG
                ),
              );

            }
        }
      }

    } catch (e) {

      debugPrint("RESET PASSWORD UNKNOWN ERROR: $e");

      emit(
        ResetPasswordError(
          "Unexpected error occurred",
          // TODO: TRANSLATE UNEXPECTED ERROR
        ),
      );
    }
  }

  Future resendOtp({
    String? countryCode,
    String? phoneNumber,
    String? email,
  }) async {
    emit(VerifyLoading());
    try {
      final data = await repo.resendOtp(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        email: email,
      );

      debugPrint("RESEND OTP RESPONSE: $data");

      final statusValue = data['status']?.toString().toLowerCase();
      final messageValue = (data['message'] ?? "").toString().toLowerCase();

      final isSuccess = statusValue == "true" || 
                        statusValue == "success" || 
                        statusValue == "1" ||
                        messageValue.contains("success") ||
                        messageValue.contains("sent");

      if (isSuccess) {
        emit(ResendOtpSuccess());
      } else {
        emit(VerifyError(data['message'] ?? "Failed to resend"));
      }
    } on DioException catch (e) {
      debugPrint("RESEND OTP ERROR: ${e.response?.data}");
      final serverData = e.response?.data;
      String serverMessage = "Failed to resend";
      if (serverData is Map) {
        serverMessage = serverData['message'] ?? serverData['error'] ?? "Failed to resend";
      } else if (serverData != null && serverData.toString().isNotEmpty) {
        serverMessage = serverData.toString();
      }
      emit(VerifyError(serverMessage));
    } catch (e) {
      emit(VerifyError("Something went wrong"));
    }
  }
}
