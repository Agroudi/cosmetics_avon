import 'package:dio/dio.dart';

class DioHelper {

  static late Dio dio;

  static void init() {

    dio = Dio(

      BaseOptions(

        baseUrl: 'https://cosmatics.growfet.com/api/',

        receiveDataWhenStatusError: true,

        headers: {
          'Accept': 'application/json',
        },

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
    return await dio.get(
      endPoint,
      options: Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  static Future<Response> post({
    required String endPoint,
    dynamic data,
    String? token,
    Options? options,
  }) async {
    final mergedOptions = options ?? Options();
    mergedOptions.headers = {
      ...?mergedOptions.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    
    return await dio.post(
      endPoint,
      data: data,
      options: mergedOptions,
    );
  }

  static Future<Response> put({
    required String endPoint,
    dynamic data,
    String? token,
    Options? options,
  }) async {
    final mergedOptions = options ?? Options();
    mergedOptions.headers = {
      ...?mergedOptions.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return await dio.put(
      endPoint,
      data: data,
      options: mergedOptions,
    );
  }

  static Future<Response> patch({
    required String endPoint,
    dynamic data,
    String? token,
    Options? options,
  }) async {
    final mergedOptions = options ?? Options();
    mergedOptions.headers = {
      ...?mergedOptions.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await dio.patch(
      endPoint,
      data: data,
      options: mergedOptions,
    );
  }

  static Future<Response> delete({
    required String endPoint,
    dynamic data,
    String? token,
  }) async {
    return await dio.delete(
      endPoint,
      data: data,
      options: Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}