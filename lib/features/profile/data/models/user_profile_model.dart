class UserProfileModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final String phoneNumber;
  final String countryCode;
  final String profilePhotoUrl;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.countryCode,
    required this.profilePhotoUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
    );
  }

  UserProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    String? phoneNumber,
    String? countryCode,
    String? profilePhotoUrl,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }
}
