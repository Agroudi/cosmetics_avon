import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init()
  {
    dio = Dio(
        BaseOptions(
            baseUrl: 'https://cosmatics.growfet.com/api/',
            receiveDataWhenStatusError: true,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            sendTimeout: const Duration(seconds: 60)
        )
    );
  }

  static Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? data
  }) async {
    return await dio.post(
      endPoint,
      data: data
    );
  }
}