import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://cosmatics.growfet.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? data,
  }) async {
    return await dio.post(
      endPoint,
      data: data,
    );
  }
}