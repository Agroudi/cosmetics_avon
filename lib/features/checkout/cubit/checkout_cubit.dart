import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../cart/data/models/cart_item_model.dart';
import '../../home/data/models/slider_model.dart';
import '../data/models/order_model.dart';
import '../data/services/checkout_api_service.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutApiService apiService;

  CheckoutCubit(this.apiService) : super(CheckoutInitial());

  String? appliedCouponCode;
  int discountPercent = 0;

  void applyVoucher(String code, List<SliderModel> sliders) {
    if (code.trim().isEmpty) {
      appliedCouponCode = null;
      discountPercent = 0;
      emit(VoucherAppliedSuccess('', 0));
      return;
    }

    final cleanedCode = code.trim().toUpperCase();
    final matchingSlider = sliders.firstWhere(
      (s) => s.couponCode.toUpperCase() == cleanedCode,
      orElse: () => SliderModel(
        id: -1,
        couponCode: '',
        discountPercent: 0,
        title1En: '',
        title1Ar: '',
        title2En: '',
        title2Ar: '',
        imageUrl: '',
      ),
    );

    if (matchingSlider.id != -1 && matchingSlider.discountPercent > 0) {
      appliedCouponCode = matchingSlider.couponCode;
      discountPercent = matchingSlider.discountPercent;
      emit(VoucherAppliedSuccess(appliedCouponCode!, discountPercent));
    } else {
      appliedCouponCode = null;
      discountPercent = 0;
      emit(VoucherAppliedError(LocaleKeys.voucher_invalid.tr()));
    }
  }

  Future<void> placeOrder({
    required String address,
    required String paymentMethod,
    required List<CartItemModel> items,
  }) async {
    emit(CheckoutLoading());

    try {
      final response = await apiService.placeOrder(
        paymentMethod: paymentMethod,
      );

      // Save order locally in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? localOrdersJson = prefs.getString('local_orders');
      List<dynamic> decoded = [];
      if (localOrdersJson != null) {
        decoded = jsonDecode(localOrdersJson);
      }

      double subtotal = 0;
      for (var item in items) {
        subtotal += item.price * item.quantity;
      }
      final double discount = subtotal * (discountPercent / 100);
      final double total = subtotal - discount + 50.0; // Flat shipping

      final newOrder = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        date: DateTime.now().toIso8601String(),
        total: total,
        status: 'pending',
        address: address,
        paymentMethod: paymentMethod,
        items: items
            .map((item) => OrderItemModel(
                  productId: item.productId,
                  productName: item.productNameEn, // Fallback en name
                  quantity: item.quantity,
                  price: item.price,
                  imageUrl: item.imageUrl,
                ))
            .toList(),
      );

      decoded.add(newOrder.toJson());
      await prefs.setString('local_orders', jsonEncode(decoded));

      emit(CheckoutSuccess(response.data ?? {}));
    } on DioException catch (e) {
      // Log the full response for debugging
      debugPrint('ORDER ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('ORDER ERROR DATA: ${e.response?.data}');

      String errorMessage = LocaleKeys.order_failed.tr();
      final responseData = e.response?.data;
      if (responseData is Map) {
        // .NET Core validation errors come in 'errors' map
        if (responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first.toString();
          } else {
            errorMessage = firstError.toString();
          }
        } else {
          errorMessage = responseData['message'] ??
              responseData['Message'] ??
              responseData['error'] ??
              responseData['Error'] ??
              responseData['title'] ??
              LocaleKeys.order_failed.tr();
        }
      } else if (responseData is String && responseData.isNotEmpty) {
        errorMessage = responseData;
      }
      emit(CheckoutError(errorMessage));
    } catch (e) {
      debugPrint('ORDER UNKNOWN ERROR: $e');
      emit(CheckoutError(LocaleKeys.smth_went_wrong.tr()));
    }
  }
}
