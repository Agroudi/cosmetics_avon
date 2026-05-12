import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/services/dio_helper.dart';

class ProfileApiService {
  Future<Response> getProfile(String token) async {
    return await DioHelper.get(
      endPoint: 'Auth/profile',
      token: token,
    );
  }

  Future<Response> logout(String token) async {
    return await DioHelper.post(
      endPoint: 'Auth/logout',
      token: token,
    );
  }

  Future<Response> updateProfile({
    required String token,
    required String username,
    required String email,
    String? profilePhotoUrl,
  }) async {
    return await DioHelper.patch(
      endPoint: 'Auth/profile',
      token: token,
      data: {
        "username": username,
        "email": email,
        "profilePhotoUrl": profilePhotoUrl ?? "",
      },
      options: Options(
        contentType: 'application/json',
      ),
    );
  }

  Future<Response> updatePhoto({
    required String token,
    required String photoPath,
  }) async {
    final fileName = photoPath.split('/').last;

    FormData formData = FormData.fromMap({
      "profilePhotoUrl": await MultipartFile.fromFile(
        photoPath, 
        filename: fileName, 
        contentType: MediaType.parse("image/jpeg"),
      ),
    });

    return await DioHelper.put(
      endPoint: 'Auth/profile',
      token: token,
      data: formData,
    );
  }
}
