import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../data/repo/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit(this.repo) : super(AuthInitial());

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
        emit(AuthSuccess());
      } else {
        emit(AuthError(data['message'] ?? "Login failed"));
      }

    } on DioException catch (e) {
      debugPrint("LOGIN ERROR: ${e.response?.data}");
      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 400:
          final serverData = e.response?.data;
          String serverMessage = "Invalid data";
          if (serverData is Map) {
            serverMessage = serverData['message'] ?? serverData['error'] ?? "Invalid data";
          } else if (serverData is String) {
            serverMessage = serverData;
          }
          emit(AuthError(serverMessage));
          break;
        case 401:
          final serverData = e.response?.data;
          String serverMessage = "Wrong phone or password";
          if (serverData is Map) {
            serverMessage = serverData['message'] ?? serverData['error'] ?? "Wrong phone or password";
          }
          emit(AuthError(serverMessage));
          break;
        case 404:
          emit(AuthError("User not found"));
          break;
        case 500:
          emit(AuthError("Server error, try again"));
          break;
        case 302:
          emit(AuthError("Server redirection error"));
          break;
        default:
          if (e.response == null) {
            emit(AuthError("No internet connection"));
          } else {
            emit(AuthError("Something went wrong"));
          }
      }

    } catch (e) {
      emit(AuthError("Unexpected error occurred"));
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
          emit(RegisterError("Email already registered"));
        } else if (messageValue.contains("username") && (messageValue.contains("already") || messageValue.contains("taken"))) {
          emit(RegisterError("Username already taken"));
        } else if (messageValue.contains("phone") && (messageValue.contains("already") || messageValue.contains("used") || messageValue.contains("exist"))) {
          emit(RegisterError("Phone already used"));
        } else if (password.length < 8) {
          emit(RegisterError("Weak password"));
        } else {
          emit(RegisterError(messageValue.isEmpty ? "Something went wrong" : (data['message'] ?? "Unknown error")));
        }
      }

    } on DioException catch (e) {
      debugPrint("STATUS CODE: ${e.response?.statusCode}");
      debugPrint("DATA: ${e.response?.data}");
      debugPrint("MESSAGE: ${e.message}");

      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 400:
          final serverData = e.response?.data;
          String serverMessage = "Invalid data";
          
          if (serverData is Map) {
            serverMessage = serverData['message'] ?? serverData['error'] ?? "Invalid data";
          } else if (serverData is String) {
            serverMessage = serverData;
          }

          final lowerMessage = serverMessage.toLowerCase();

          if (lowerMessage.contains("email") && (lowerMessage.contains("already") || lowerMessage.contains("exist"))) {
            emit(RegisterError("Email already registered"));
          } else if (lowerMessage.contains("username") && (lowerMessage.contains("already") || lowerMessage.contains("taken"))) {
            emit(RegisterError("Username already taken"));
          } else if (lowerMessage.contains("phone") && (lowerMessage.contains("already") || lowerMessage.contains("used") || lowerMessage.contains("exist"))) {
            emit(RegisterError("Phone already used"));
          } else {
            emit(RegisterError(serverMessage));
          }
          break;
        case 401:
          emit(RegisterError("Unauthorized"));
          break;
        case 500:
          emit(RegisterError("Server error"));
          break;
        default:
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            emit(RegisterError("Connection timeout, try again"));
          } else if (e.type == DioExceptionType.connectionError) {
            emit(RegisterError("No internet connection"));
          } else {
            emit(RegisterError("Something went wrong"));
          }
      }

    } catch (e) {
      emit(RegisterError("Unexpected error"));
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

      if (data['status'] == true) {
        emit(ForgotPasswordSuccess());
      } else {
        emit(ForgotPasswordError(data['message'] ?? "Failed"));
      }
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
      final data = await repo.resetPassword(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword
      );

      if (data['status'] == true) {
        emit(ResetPasswordSuccess());
      } else {
        emit(ResetPasswordError(data['message']));
      }
    } catch (e) {
      emit(ResetPasswordError("Reset failed"));
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