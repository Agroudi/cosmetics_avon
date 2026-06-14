import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/dio_helper.dart';

class CheckoutApiService {
  Future placeOrder({
    required String paymentMethod,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // The backend's CreateOrderDto accepts ONLY `paymentMethod` and is
    // declared with `additionalProperties: false`. Any extra fields (or
    // duplicate case variants like `PaymentMethod`) make the body fail to
    // deserialize, leaving the model null and triggering the
    // "payment method is required" validation error. Send exactly the one
    // field the contract expects. Address/coupon are tracked locally only.
    final data = <String, dynamic>{
      'paymentMethod': paymentMethod,
    };

    return await DioHelper.post(
      endPoint: 'Orders',
      token: token,
      data: data,
    );
  }
}

