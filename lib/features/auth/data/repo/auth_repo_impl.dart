import '../services/auth_api_services.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo
{
  final AuthApiService api;

  AuthRepoImpl(this.api);

  @override
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    final response = await api.login(
      phone: phone,
      password: password,
      countryCode: countryCode,
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
}