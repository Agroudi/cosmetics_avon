class SliderModel {

  final int id;
  final String couponCode;
  final int discountPercent;
  final String title1En;
  final String title1Ar;
  final String title2En;
  final String title2Ar;
  final String imageUrl;

  SliderModel({
    required this.id,
    required this.couponCode,
    required this.discountPercent,
    required this.title1En,
    required this.title1Ar,
    required this.title2En,
    required this.title2Ar,
    required this.imageUrl,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      couponCode: json['coupon_code'],
      discountPercent: json['discount_percent'],
      title1En: json['description_title1_en'],
      title1Ar: json['description_title1_ar'],
      title2En: json['description_title2_en'],
      title2Ar: json['description_title2_ar'],
      imageUrl: json['image_url'],
    );
  }
}