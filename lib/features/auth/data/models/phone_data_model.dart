class PhoneData {
  String countryCode;
  String phone;

  PhoneData({
    required this.countryCode,
    required this.phone,
  });

  String get fullNumber => countryCode + phone;
}