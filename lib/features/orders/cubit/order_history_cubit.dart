import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../checkout/data/models/order_model.dart';
import '../data/services/order_api_service.dart';
import 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderApiService apiService;

  OrderHistoryCubit(this.apiService) : super(OrderHistoryInitial());

  List<OrderModel> orders = [];

  Future<void> getOrders() async {
    emit(OrderHistoryLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load local persisted orders first
      final String? localOrdersJson = prefs.getString('local_orders');
      List<OrderModel> localOrders = [];
      if (localOrdersJson != null) {
        final List<dynamic> decoded = jsonDecode(localOrdersJson);
        localOrders = decoded.map((x) => OrderModel.fromJson(x)).toList();
      }

      // Try fetching from API
      try {
        final response = await apiService.getOrders();
        if (response.data != null && response.data is List) {
          final List<dynamic> apiList = response.data;
          final parsedApiOrders = apiList.map((x) => OrderModel.fromJson(x)).toList();
          
          // Merge lists (unique by ID)
          final Map<int, OrderModel> mergedMap = {};
          for (var o in parsedApiOrders) {
            mergedMap[o.id] = o;
          }
          for (var o in localOrders) {
            mergedMap[o.id] = o;
          }
          orders = mergedMap.values.toList();
        } else {
          orders = localOrders;
        }
      } catch (e) {
        debugPrint("API order history error, using local/fallback orders: $e");
        orders = localOrders;
      }

      // Sort by date (newest first)
      orders.sort((a, b) => b.date.compareTo(a.date));

      emit(OrderHistorySuccess(orders));
    } catch (e) {
      emit(OrderHistoryError(LocaleKeys.failed_load_orders.tr()));
    }
  }
}
