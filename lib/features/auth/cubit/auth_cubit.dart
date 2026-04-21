import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../data/repo/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;

  AuthCubit(this.repo) : super(AuthInitial());

  Future login({
    required String phone,
    required String password,
    required String countryCode,
  }) async {
    emit(AuthLoading());

    try {
      final data = await repo.login(
        phone: phone,
        password: password,
        countryCode: countryCode,
      );

      if (data != null && data['status'] == true) {
        emit(AuthSuccess());
      } else {
        emit(AuthError(data['message'] ?? "Login failed"));
      }

    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 400:
          emit(AuthError("Invalid data"));
          break;
        case 401:
          emit(AuthError("Wrong phone or password"));
          break;
        case 404:
          emit(AuthError("User not found"));
          break;
        case 500:
          emit(AuthError("Server error, try again"));
          break;
        case 302:
          emit(AuthError("Server redirection error"));
          break;
        default:
          if (e.response == null) {
            emit(AuthError("No internet connection"));
          } else {
            emit(AuthError("Something went wrong"));
          }
      }

    } catch (e) {
      emit(AuthError("Unexpected error occurred"));
    }
  }

  Future register({
    required String userName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      final data = await repo.register(
          userName: userName,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password
      );

      if (data['status'] == true) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterError(data['message'] ?? "Register failed"));
      }

    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 400:
          emit(RegisterError("Invalid data"));
          break;
        case 401:
          emit(RegisterError("Unauthorized"));
          break;
        case 500:
          emit(RegisterError("Server error"));
          break;
        default:
          if (e.response == null) {
            emit(RegisterError("No internet connection"));
          } else {
            emit(RegisterError("Something went wrong"));
          }
      }

    } catch (e) {
      emit(RegisterError("Unexpected error"));
    }
  }
}