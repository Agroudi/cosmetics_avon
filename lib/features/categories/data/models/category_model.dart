class CategoryModel {

  final int id;
  final String titleEn;
  final String titleAr;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {

    return CategoryModel(
      id: json['id'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      imageUrl: json['image_url'],
    );
  }
}