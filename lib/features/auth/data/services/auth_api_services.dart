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
    return await DioHelper.post(
      endPoint: 'Auth/reset-password',
      data: {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword
      },
    );
  }

  Future verifyCode({
    String? countryCode,
    String? phoneNumber,
    String? email,
    required String otpCode
  }) async {
    return await DioHelper.post(
      endPoint: 'Auth/verify-otp',
      data: {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "email": email,
        "otpCode": otpCode,
      },
    );
  }

  Future resendOtp({
    String? countryCode,
    String? phoneNumber,
    String? email,
  }) async {
    return await DioHelper.post(
      endPoint: 'Auth/resend-otp',
      data: {
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "email": email,
      },
    );
  }
}