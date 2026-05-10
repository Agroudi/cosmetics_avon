import '../services/home_api_service.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {

  final HomeApiService api;

  HomeRepoImpl(this.api);

  @override
  Future getSliders() async {
    return await api.getSliders();
  }

  @override
  Future getCategories() async {
    return await api.getCategories();
  }

  @override
  Future getProducts() async {
    return await api.getProducts();
  }
}