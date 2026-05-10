import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/dio_helper.dart';

class CartApiService {

  Future getCart() async {

    final prefs =
    await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    return await DioHelper.get(

      endPoint: 'Cart',

      token: token,
    );
  }

  Future addToCart({
    required int productId,
    required int quantity,
  }) async {

    final prefs =
    await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    return await DioHelper.post(

      endPoint:
      'Cart/add?productId=$productId&quantity=$quantity',

      token: token,
    );
  }

  Future updateCart({
    required int productId,
    required int quantity,
  }) async {

    final prefs =
    await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    return await DioHelper.post(

      endPoint:
      'Cart/update?productId=$productId&quantity=$quantity',

      token: token,
    );
  }

  Future removeFromCart(int productId) async {

    final prefs =
    await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    return await DioHelper.post(

      endPoint: 'Cart/remove/$productId',

      token: token,
    );
  }
}