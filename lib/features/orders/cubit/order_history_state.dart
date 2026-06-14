import 'package:flutter/material.dart';
import '../../checkout/data/models/order_model.dart';

@immutable
sealed class OrderHistoryState {}

final class OrderHistoryInitial extends OrderHistoryState {}

final class OrderHistoryLoading extends OrderHistoryState {}

final class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderModel> orders;
  OrderHistorySuccess(this.orders);
}

final class OrderHistoryError extends OrderHistoryState {
  final String message;
  OrderHistoryError(this.message);
}
