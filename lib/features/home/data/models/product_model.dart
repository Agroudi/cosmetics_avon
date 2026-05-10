class ProductModel {

  final int id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final int stock;
  final String imageUrl;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
    );
  }
}