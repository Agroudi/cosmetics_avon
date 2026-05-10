import '../models/category_model.dart';
import '../services/categories_api_service.dart';
import 'categories_repo.dart';

class CategoriesRepoImpl implements CategoriesRepo {

  final CategoriesApiService apiService;

  CategoriesRepoImpl(this.apiService);

  @override
  Future<List<CategoryModel>> getCategories() async {

    final data = await apiService.getCategories();

    return List<CategoryModel>.from(
      data.map(
            (e) => CategoryModel.fromJson(e),
      ),
    );
  }
}