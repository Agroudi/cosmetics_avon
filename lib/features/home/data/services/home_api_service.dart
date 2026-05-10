import '../../../../core/services/dio_helper.dart';

class HomeApiService {

  Future getSliders() async {
    return await DioHelper.get(
      endPoint: 'Sliders',
    );
  }

  Future getCategories() async {
    return await DioHelper.get(
      endPoint: 'Categories',
    );
  }

  Future getProducts() async {
    return await DioHelper.get(
      endPoint: 'Products',
    );
  }
}