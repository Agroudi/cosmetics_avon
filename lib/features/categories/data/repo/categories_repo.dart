import '../models/category_model.dart';

abstract class CategoriesRepo {

  Future<List<CategoryModel>> getCategories();
}