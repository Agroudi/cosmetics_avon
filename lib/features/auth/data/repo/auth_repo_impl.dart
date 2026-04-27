import '../services/auth_api_services.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo
{
  final AuthApiService api;

  AuthRepoImpl(this.api);

  @override
  Future<Map<String, dynamic>> login({
    required String countryCode,
    required String phoneNumber,
    required String password,
  }) async {
    final response = await api.login(
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      password: password,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String userName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final response = await api.register(
        userName: userName,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        email: email,
        password: password
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({
    required String countryCode,
    required String phoneNumber
  }) async {
    final response = await api.forgotPassword(
      countryCode: countryCode,
      phoneNumber: phoneNumber
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String countryCode,
    required String phoneNumber,
    required String newPassword,
    required String confirmPassword
  }) async {
    final response = await api.resetPassword(
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      newPassword: newPassword,
      confirmPassword: confirmPassword
    );

    return response.data;
  }

  Future<Map<String, dynamic>> verifyCode({
    String? countryCode,
    String? phoneNumber,
    String? email,
    required String otpCode,
  }) async {
    final response = await api.verifyCode(
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      otpCode: otpCode,
    );

    return response.data;
  }

  @override
  Future<Map<String, dynamic>> resendOtp({
    String? countryCode,
    String? phoneNumber,
    String? email,
  }) async {
    final response = await api.resendOtp(
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
    );

    return response.data;
  }
}