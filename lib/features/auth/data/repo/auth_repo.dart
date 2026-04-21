abstract class AuthRepo
{
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
    required String countryCode,
  });

  Future<Map<String, dynamic>> register({
    required String userName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password,
  });
}