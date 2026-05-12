part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {}

class CartSuccess extends CartState {}

class CartItemUpdating extends CartState {}

class CartItemRemoved extends CartState {}

class CartItemAdded extends CartState {}

class CartInfoState extends CartState {

  final String message;

  CartInfoState(this.message);
}

class CartError extends CartState {

  final String message;

  CartError(this.message);
}

class CartUnauthorizedError extends CartState {
  final String message;
  CartUnauthorizedError(this.message);
}