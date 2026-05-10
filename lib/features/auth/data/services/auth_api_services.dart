import 'package:cosmetics_avon/core/services/dio_helper.dart';
import 'package:flutter/material.dart';

class AuthApiService {
  Future login({
    required String countryCode,
    required String phoneNumber,
    required String password,
  }) async {
    return await DioHelper.post(
      endPoint: 'Auth/login',
      data: {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "password": password,
      },
    );
  }

  Future register({
    required String userName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    debugPrint("REGISTER BODY: ${{
      "username": userName,
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password
    }}");
    return await DioHelper.post(
      endPoint: 'Auth/register',
      data: {
        "username": userName,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "email": email,
        "password" : password
      },
    );
  }

  Future forgotPassword({
    required String countryCode,
    required String phoneNumber,
  }) async {
    return await DioHelper.post(
      endPoint: 'Auth/forgot-password',
      data: {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
      },
    );
  }

  Future resetPassword({
    required String countryCode,
    required String phoneNumber,
    required String newPassword,
    required String confirmPassword
  }) async {
    // Sending both lowercase and PascalCase keys to ensure compatibility with backend validation
    final Map<String, dynamic> data = {
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
      "CountryCode": countryCode,
      "PhoneNumber": phoneNumber,
      "NewPassword": newPassword,
      "ConfirmPassword": confirmPassword,
    };

    debugPrint("RESET PASSWORD API SENDING: $data");

    return await DioHelper.post(
      endPoint: 'Auth/reset-password',
      data: data,
    );
  }

  Future verifyCode({
    String? countryCode,
    String? phoneNumber,
    String? email,
    required String otpCode
  }) async {
    final Map<String, dynamic> data = {"otpCode": otpCode};
    if (countryCode != null) data["countryCode"] = countryCode;
    if (phoneNumber != null) data["phoneNumber"] = phoneNumber;
    if (email != null) data["email"] = email;

    return await DioHelper.post(
      endPoint: 'Auth/verify-otp',
      data: data,
    );
  }

  Future resendOtp({
    String? countryCode,
    String? phoneNumber,
    String? email,
  }) async {
    final Map<String, dynamic> data = {};
    if (countryCode != null) data["countryCode"] = countryCode;
    if (phoneNumber != null) data["phoneNumber"] = phoneNumber;
    if (email != null) data["email"] = email;

    return await DioHelper.post(
      endPoint: 'Auth/resend-otp',
      data: data,
    );
  }
}
