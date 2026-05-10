class CartItemModel {

  final int productId;

  final String productNameEn;

  final String productNameAr;

  final String imageUrl;

  final double price;

  int quantity;

  CartItemModel({

    required this.productId,

    required this.productNameEn,

    required this.productNameAr,

    required this.imageUrl,

    required this.price,

    required this.quantity,
  });

  factory CartItemModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return CartItemModel(

      productId: json['product_id'],

      productNameEn: json['product_name_en'],

      productNameAr: json['product_name_ar'],

      imageUrl: json['image_url'],

      price: (json['price'] as num).toDouble(),

      quantity: json['quantity'],
    );
  }
}