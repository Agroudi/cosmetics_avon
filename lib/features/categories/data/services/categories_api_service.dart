import '../../../../core/services/dio_helper.dart';

class CategoriesApiService {

  Future getCategories() async {

    return await DioHelper.get(
      endPoint: 'Categories',
    );
  }
}