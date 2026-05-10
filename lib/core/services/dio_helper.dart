import 'package:dio/dio.dart';

class DioHelper {

  static late Dio dio;

  static void init() {

    dio = Dio(

      BaseOptions(

        baseUrl: 'https://cosmatics.growfet.com/api/',

        receiveDataWhenStatusError: true,

        connectTimeout: const Duration(seconds: 60),

        receiveTimeout: const Duration(seconds: 60),

        sendTimeout: const Duration(seconds: 60),
      ),
    );
  }

  static Future<Response> get({
    required String endPoint,
    String? token,
  }) async {

    dio.options.headers = {

      'Authorization':
      token != null ? 'Bearer $token' : null,
    };

    return await dio.get(endPoint);
  }

  static Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? data,
    String? token,
  }) async {

    dio.options.headers = {

      'Authorization':
      token != null ? 'Bearer $token' : null,
    };

    return await dio.post(
      endPoint,
      data: data,
    );
  }
}