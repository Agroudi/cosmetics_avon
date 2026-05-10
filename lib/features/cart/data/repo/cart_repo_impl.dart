import '../services/cart_api_service.dart';
import 'cart_repo.dart';

class CartRepoImpl implements CartRepo {

  final CartApiService api;

  CartRepoImpl(this.api);

  @override
  Future getCart() async {
    return await api.getCart();
  }

  @override
  Future addToCart({
    required int productId,
    required int quantity,
  }) async {

    return await api.addToCart(
      productId: productId,
      quantity: quantity,
    );
  }

  @override
  Future updateCart({
    required int productId,
    required int quantity,
  }) async {

    return await api.updateCart(
      productId: productId,
      quantity: quantity,
    );
  }

  @override
  Future removeFromCart(int productId) async {

    return await api.removeFromCart(productId);
  }
}