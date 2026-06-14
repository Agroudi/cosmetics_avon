import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/dio_helper.dart';

class OrderApiService {
  Future getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await DioHelper.get(
      endPoint: 'Orders',
      token: token,
    );
  }
}
