import 'dart:convert';
import 'dart:io';
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
    return await DioHelper.put(
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
    // Read file and convert to Base64
    final bytes = await File(photoPath).readAsBytes();
    final base64Image = base64Encode(bytes);

    // Send as JSON string via PUT
    return await DioHelper.put(
      endPoint: 'Auth/profile',
      token: token,
      data: {
        "profilePhotoUrl": base64Image,
      },
      options: Options(
        contentType: 'application/json',
      ),
    );
  }
}
