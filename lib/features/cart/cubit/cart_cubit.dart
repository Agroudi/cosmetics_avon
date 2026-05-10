import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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

  int get productsCount =>
      cartItems.length;

  Set<int> loadingItems = {};

  Future<void> getCart({
    bool showLoading = true,
  }) async {

    if(showLoading){
      emit(CartLoading());
    }

    try {

      final response = await repo.getCart();

      cartItems = List<CartItemModel>.from(
        response.data['items'].map(
              (e) => CartItemModel.fromJson(e),
        ),
      );

      emit(CartSuccess());

    } catch (e) {

      emit(
        CartError(
          "Failed to get cart",
        ),
      );
    }
  }

  Future<void> addToCart(ProductModel product) async {

    try {

      await repo.addToCart(
        productId: product.id,
        quantity: 1,
      );

      await getCart(
        showLoading: false,
      );

      emit(CartItemAdded());

    } catch (e) {

      emit(
        CartError(
          "Failed to add item",
        ),
      );
    }
  }

  Future<void> increaseQuantity(
      CartItemModel item,
      ) async {

    if(loadingItems.contains(item.productId)) return;

    loadingItems.add(item.productId);

    emit(CartItemUpdating());

    try {

      await repo.updateCart(

        productId: item.productId,

        quantity: item.quantity + 1,
      );

      await getCart();

    } catch (e) {

      debugPrint("INCREASE ERROR => $e");

      emit(
        CartError(
          "Failed to update quantity",
        ),
      );
    }

    loadingItems.remove(item.productId);

    emit(CartLoaded());
  }

  Future<void> decreaseQuantity(
      CartItemModel item,
      ) async {

    if(loadingItems.contains(item.productId)) return;

    if(item.quantity <= 1) {

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

      debugPrint("DECREASE ERROR => $e");

      emit(
        CartError(
          "Failed to update quantity",
        ),
      );
    }

    loadingItems.remove(item.productId);

    emit(CartLoaded());
  }

  Future<void> removeItem(int productId) async {

    if(loadingItems.contains(productId)) return;

    loadingItems.add(productId);

    emit(CartItemUpdating());

    try {

      await repo.removeFromCart(productId);

      await getCart();

    } catch (e) {

      debugPrint("REMOVE ITEM ERROR => $e");

      emit(
        CartError(
          "Failed to remove item",
        ),
      );
    }

    loadingItems.remove(productId);

    emit(CartLoaded());
  }
}