import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cosmetics_avon/features/profile/data/models/user_profile_model.dart';
import 'package:cosmetics_avon/gen/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repo/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;
  UserProfileModel? currentUser;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final user = await _repo.getProfile(token);
      currentUser = user;
      emit(ProfileSuccess(user));
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(Object e) {
    debugPrint("❌ PROFILE ERROR DETAIL => $e");
    String errorMessage = LocaleKeys.smth_went_wrong.tr();

    if (e is DioException) {
      debugPrint("📡 Status Code: ${e.response?.statusCode}");
      debugPrint("📦 Response Data: ${e.response?.data}");

      final responseData = e.response?.data;
      String? serverMessage;
      if (responseData is Map) {
        serverMessage = responseData['message'] ?? responseData['error'];
      }

      if (serverMessage != null && serverMessage is String) {
        errorMessage = serverMessage;
      } else {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMessage = LocaleKeys.connection_timeout.tr();
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = LocaleKeys.no_internet.tr();
        } else {
          final statusCode = e.response?.statusCode;
          switch (statusCode) {
            case 400:
              errorMessage = LocaleKeys.case_400.tr();
              break;
            case 401:
              errorMessage = LocaleKeys.case_401.tr();
              break;
            case 404:
              errorMessage = LocaleKeys.case_404.tr();
              break;
            case 415:
              errorMessage = LocaleKeys.invalid_image_format.tr();
              break;
            case 500:
              errorMessage = LocaleKeys.case_500.tr();
              break;
          }
        }
      }
    } else {
      errorMessage = LocaleKeys.unexp_error.tr();
    }
    emit(ProfileError(errorMessage));
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      await _repo.logout(token);

      // Clear token and other local data
      await prefs.remove('token');
      // Keep is_first_time so they don't see onboarding again

      emit(LogoutSuccess());
    } catch (e) {
      debugPrint("LOGOUT ERROR: $e");
      // Even if API fails, we often want to force logout locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(LogoutSuccess());
    }
  }

  Future<void> updateProfile({
    required String username,
    required String email,
  }) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final updatedUser = await _repo.updateProfile(
        token: token,
        username: username,
        email: email,
        profilePhotoUrl: currentUser?.profilePhotoUrl,
      );

      // Safety check: Only update if the response is valid and not empty
      if (updatedUser.username.isNotEmpty) {
        // Preserve photoUrl if the update response doesn't include it
        if (updatedUser.profilePhotoUrl.isEmpty && currentUser != null) {
          currentUser = updatedUser.copyWith(
            profilePhotoUrl: currentUser!.profilePhotoUrl,
          );
        } else {
          currentUser = updatedUser;
        }
        emit(ProfileUpdateSuccess(currentUser!));
      } else {
        emit(ProfileError(LocaleKeys.smth_went_wrong.tr()));
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> updatePhoto(String photoPath) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      await _repo.updatePhoto(token: token, photoPath: photoPath);

      // Force a full refresh to get the new URL reliably
      final prefs2 = await SharedPreferences.getInstance();
      final token2 = prefs2.getString('token') ?? '';
      final user = await _repo.getProfile(token2);

      currentUser = user;
      emit(ProfileUpdateSuccess(user));
    } catch (e) {
      _handleError(e);
    }
  }
}
