abstract class CartRepo {

  Future getCart();

  Future addToCart({
    required int productId,
    required int quantity,
  });

  Future updateCart({
    required int productId,
    required int quantity,
  });

  Future removeFromCart(int productId);
}