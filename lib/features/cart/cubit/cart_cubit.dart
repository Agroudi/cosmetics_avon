import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../gen/locale_keys.g.dart';
import '../../home/data/models/product_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/cart_model.dart';
import '../data/repo/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo repo;

  CartCubit(this.repo) : super(CartInitial());

  CartModel? cartModel;

  List<CartItemModel> cartItems = [];

  int get productsCount => cartItems.length;

  Set<int> loadingItems = {};

  Future<void> getCart({bool showLoading = true}) async {
    if (showLoading) {
      emit(CartLoading());
    }

    try {
      final response = await repo.getCart();

      cartItems = List<CartItemModel>.from(
        response.data['items'].map((e) => CartItemModel.fromJson(e)),
      );

      emit(CartSuccess());
    } catch (e) {
      _handleError(e, LocaleKeys.failed_get_cart.tr());
    }
  }

  void _handleError(Object e, String defaultMessage) {
    debugPrint("CART ERROR => $e");
    String errorMessage = defaultMessage;

    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      
      switch (statusCode) {
        case 401:
          errorMessage = LocaleKeys.case_401.tr();
          SharedPreferences.getInstance().then((prefs) {
            prefs.remove('token');
          });
          emit(CartUnauthorizedError(errorMessage));
          return;
        case 400:
          errorMessage = LocaleKeys.case_400.tr();
          break;
        case 404:
          errorMessage = LocaleKeys.case_404.tr();
          break;
        case 500:
          errorMessage = LocaleKeys.case_500.tr();
          break;
        default:
          if (e.type == DioExceptionType.connectionTimeout || 
              e.type == DioExceptionType.connectionError) {
            errorMessage = LocaleKeys.no_internet.tr();
          } else {
            errorMessage = LocaleKeys.smth_went_wrong.tr();
          }
      }
    }

    emit(CartError(errorMessage));
  }

  Future<void> addToCart(ProductModel product) async {
    if (loadingItems.contains(product.id)) return;

    loadingItems.add(product.id);
    emit(CartItemUpdating());

    try {
      await repo.addToCart(productId: product.id, quantity: 1);

      await getCart(showLoading: false);

      emit(CartItemAdded());
    } catch (e) {
      _handleError(e, LocaleKeys.failed_add_item.tr());
    }

    loadingItems.remove(product.id);
    emit(CartLoaded());
  }

  Future<void> increaseQuantity(CartItemModel item) async {
    if (loadingItems.contains(item.productId)) return;

    loadingItems.add(item.productId);

    emit(CartItemUpdating());

    try {
      await repo.updateCart(
        productId: item.productId,

        quantity: item.quantity + 1,
      );

      await getCart();
    } catch (e) {
      _handleError(e, LocaleKeys.failed_update_quantity.tr());
    }

    loadingItems.remove(item.productId);

    emit(CartLoaded());
  }

  Future<void> decreaseQuantity(CartItemModel item) async {
    if (loadingItems.contains(item.productId)) return;

    if (item.quantity <= 1) {
      await removeItem(item.productId);

      return;
    }

    loadingItems.add(item.productId);

    emit(CartItemUpdating());

    try {
      await repo.updateCart(
        productId: item.productId,

        quantity: item.quantity - 1,
      );

      await getCart();
    } catch (e) {
      _handleError(e, LocaleKeys.failed_update_quantity.tr());
    }

    loadingItems.remove(item.productId);

    emit(CartLoaded());
  }

  Future<void> removeItem(int productId) async {
    if (loadingItems.contains(productId)) return;

    loadingItems.add(productId);

    emit(CartItemUpdating());

    try {
      await repo.removeFromCart(productId);

      await getCart(showLoading: false);

      emit(CartItemRemoved());
    } catch (e) {
      _handleError(e, LocaleKeys.failed_remove_item.tr());
    }

    loadingItems.remove(productId);

    emit(CartLoaded());
  }
}
