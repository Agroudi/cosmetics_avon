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
    log("❌ PROFILE ERROR DETAIL", error: e);
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
            case 400: errorMessage = LocaleKeys.case_400.tr(); break;
            case 401: errorMessage = LocaleKeys.case_401.tr(); break;
            case 404: errorMessage = LocaleKeys.case_404.tr(); break;
            case 415: errorMessage = LocaleKeys.invalid_image_format.tr(); break;
            case 500: errorMessage = LocaleKeys.case_500.tr(); break;
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
      await prefs.remove('token');
      emit(LogoutSuccess());
    } catch (e) {
      _handleError(e);
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

      // Perform PUT update
      await _repo.updateProfile(
        token: token,
        username: username,
        email: email,
        profilePhotoUrl: currentUser?.profilePhotoUrl,
      );

      // Refresh data using GET as suggested by Postman results
      await getProfile();
      emit(ProfileUpdateSuccess(currentUser!));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> updatePhoto(String photoPath) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Perform PUT update for photo
      await _repo.updatePhoto(token: token, photoPath: photoPath);

      // Give the server a second to process the image before refreshing
      await Future.delayed(const Duration(seconds: 1));

      // Refresh data using GET
      await getProfile();
      if (currentUser != null) {
        emit(ProfileUpdateSuccess(currentUser!));
      }
    } catch (e) {
      _handleError(e);
    }
  }
}
