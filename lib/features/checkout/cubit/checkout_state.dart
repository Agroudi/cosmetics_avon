import 'package:flutter/material.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {
  final Map<String, dynamic> responseData;
  CheckoutSuccess(this.responseData);
}

final class CheckoutError extends CheckoutState {
  final String errorMessage;
  CheckoutError(this.errorMessage);
}

final class VoucherAppliedSuccess extends CheckoutState {
  final String code;
  final int discountPercent;
  VoucherAppliedSuccess(this.code, this.discountPercent);
}

final class VoucherAppliedError extends CheckoutState {
  final String message;
  VoucherAppliedError(this.message);
}
