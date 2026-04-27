abstract class AuthRepo
{
  Future<Map<String, dynamic>> login({
    required String countryCode,
    required String phoneNumber,
    required String password
  });

  Future<Map<String, dynamic>> register({
    required String userName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password
  });

  Future<Map<String, dynamic>> forgotPassword({
    required String countryCode,
    required String phoneNumber
  });

  Future<Map<String, dynamic>> resetPassword({
    required String countryCode,
    required String phoneNumber,
    required String newPassword,
    required String confirmPassword
  });

  Future<Map<String, dynamic>> verifyCode({
    String? countryCode,
    String? phoneNumber,
    String? email,
    required String otpCode,
  });

  Future<Map<String, dynamic>> resendOtp({
    String? countryCode,
    String? phoneNumber,
    String? email,
  });
}