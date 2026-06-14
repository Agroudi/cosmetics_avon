import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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

      // Orders are shown from local storage, which holds the full order detail
      // (items, address, total, payment method) captured at checkout.
      //
      // The server's GET /Orders is intentionally NOT merged in: its order
      // objects don't map onto OrderModel — the API has no address field and
      // its item/field names differ — so each server order parsed as an empty
      // record. Because server ids differ from the locally generated ids, the
      // old merge kept both, producing a duplicate empty order beside each real
      // one. Re-enable a merge only once GET /Orders is mapped into OrderModel.
      final String? localOrdersJson = prefs.getString('local_orders');
      List<OrderModel> localOrders = [];
      if (localOrdersJson != null) {
        final List<dynamic> decoded = jsonDecode(localOrdersJson);
        localOrders = decoded.map((x) => OrderModel.fromJson(x)).toList();
      }

      // Sort by date (newest first)
      localOrders.sort((a, b) => b.date.compareTo(a.date));

      orders = localOrders;
      emit(OrderHistorySuccess(orders));
    } catch (e) {
      emit(OrderHistoryError(LocaleKeys.failed_load_orders.tr()));
    }
  }
}
