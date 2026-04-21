import 'package:cosmetics_avon/core/services/dio_helper.dart';

class AuthApiService {
  Future login({
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    return await DioHelper.post(
      endPoint: 'Auth/login',
      data: {
        "countryCode": countryCode,
        "phoneNumber": phone,
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
}