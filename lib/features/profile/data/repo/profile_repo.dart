import '../models/user_profile_model.dart';

abstract class ProfileRepo {
  Future<UserProfileModel> getProfile(String token);
  Future<void> logout(String token);
  Future<UserProfileModel> updateProfile({
    required String token,
    required String username,
    required String email,
    String? profilePhotoUrl,
  });
  Future<void> updatePhoto({
    required String token,
    required String photoPath,
  });
}
