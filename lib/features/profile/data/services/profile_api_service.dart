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
    // Filter out dummy URLs
    final validPhotoUrl = (profilePhotoUrl != null && profilePhotoUrl.contains('example.com')) 
        ? "" 
        : profilePhotoUrl;

    return await DioHelper.put(
      endPoint: 'Auth/profile',
      token: token,
      data: {
        "username": username,
        "Username": username,
        "email": email,
        "Email": email,
        "profilePhotoUrl": validPhotoUrl ?? "",
        "ProfilePhotoUrl": validPhotoUrl ?? "",
      },
      options: Options(
        contentType: 'application/json',
      ),
    );
  }

  Future<Response> updatePhoto({
    required String token,
    required String photoPath,
    required String username,
    required String email,
  }) async {
    // Read file and convert to Base64 with prefix
    final bytes = await File(photoPath).readAsBytes();
    final base64Image = "data:image/jpeg;base64,${base64Encode(bytes)}";

    return await DioHelper.put(
      endPoint: 'Auth/profile',
      token: token,
      data: {
        "username": username,
        "Username": username,
        "email": email,
        "Email": email,
        "profilePhotoUrl": base64Image,
        "ProfilePhotoUrl": base64Image,
      },
      options: Options(
        contentType: 'application/json',
      ),
    );
  }
}
