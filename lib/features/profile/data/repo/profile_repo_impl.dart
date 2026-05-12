import '../models/user_profile_model.dart';
import '../services/profile_api_service.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileApiService _apiService;

  ProfileRepoImpl(this._apiService);

  @override
  Future<UserProfileModel> getProfile(String token) async {
    final response = await _apiService.getProfile(token);
    return UserProfileModel.fromJson(response.data);
  }

  @override
  Future<void> logout(String token) async {
    await _apiService.logout(token);
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String token,
    required String username,
    required String email,
    String? profilePhotoUrl,
  }) async {
    final response = await _apiService.updateProfile(
      token: token,
      username: username,
      email: email,
      profilePhotoUrl: profilePhotoUrl,
    );
    return UserProfileModel.fromJson(response.data);
  }

  @override
  Future<UserProfileModel> updatePhoto({
    required String token,
    required String photoPath,
    required String username,
    required String email,
  }) async {
    final response = await _apiService.updatePhoto(
      token: token,
      photoPath: photoPath,
      username: username,
      email: email,
    );
    return UserProfileModel.fromJson(response.data);
  }
}
