part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterError extends AuthState {
  final String message;
  RegisterError(this.message);

}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {}

class ForgotPasswordError extends AuthState {
  final String message;
  ForgotPasswordError(this.message);
}

class VerifyLoading extends AuthState{}

class VerifySuccess extends AuthState{}

class ResendOtpSuccess extends AuthState{}

class VerifyError extends AuthState{
  final String message;
  VerifyError(this.message);
}

class ResetPasswordLoading extends AuthState{}

class ResetPasswordSuccess extends AuthState{}

class ResetPasswordError extends AuthState{
  final String message;
  ResetPasswordError(this.message);
}