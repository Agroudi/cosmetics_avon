import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../checkout/data/models/order_model.dart';
import '../cubit/order_history_cubit.dart';
import '../cubit/order_history_state.dart';
import '../data/services/order_api_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => OrderHistoryCubit(OrderApiService())..getOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.order_history_title.tr(),
            style: AppTextStyle.txtStyle.copyWith(
              color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
              size: 20.r,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
            builder: (context, state) {
              if (state is OrderHistoryLoading) {
                return const Center(child: LoadingWidget());
              }

              if (state is OrderHistoryError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                  ),
                );
              }

              if (state is OrderHistorySuccess) {
                final orders = state.orders;

                if (orders.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/delivery_online_shopping.json',
                            width: 200.w,
                            height: 200.h,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            LocaleKeys.no_orders.tr(),
                            style: AppTextStyle.txtStyle.copyWith(
                              color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            LocaleKeys.no_orders_desc.tr(),
                            style: AppTextStyle.txtStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order, isDark);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, bool isDark) {
    // Format date
    String formattedDate = '';
    try {
      final dateTime = DateTime.parse(order.date);
      formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      formattedDate = order.date;
    }

    Color statusColor;
    String statusText;
    switch (order.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = LocaleKeys.status_pending.tr();
        break;
      case 'processing':
        statusColor = Colors.blue;
        statusText = LocaleKeys.status_processing.tr();
        break;
      case 'completed':
        statusColor = Colors.green;
        statusText = LocaleKeys.status_completed.tr();
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = LocaleKeys.status_cancelled.tr();
        break;
      default:
        statusColor = Colors.grey;
        statusText = order.status;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 0,
      color: isDark ? DarkColors.cardBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            LocaleKeys.order_id.tr(args: [order.id.toString()]),
            style: AppTextStyle.txtStyle.copyWith(
              color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              formattedDate,
              style: AppTextStyle.txtStyle.copyWith(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              statusText,
              style: AppTextStyle.txtStyle.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.2)),
                  SizedBox(height: 8.h),
                  _buildDetailRow(
                    label: LocaleKeys.delivery_to.tr(),
                    value: order.address,
                    isDark: isDark,
                  ),
                  SizedBox(height: 8.h),
                  _buildDetailRow(
                    label: LocaleKeys.payment_method.tr(),
                    value: order.paymentMethod,
                    isDark: isDark,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    LocaleKeys.order_items.tr(),
                    style: AppTextStyle.txtStyle.copyWith(
                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...order.items.map((item) => _buildItemTile(item, isDark)),
                  SizedBox(height: 12.h),
                  Divider(color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.2)),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.order_total.tr(),
                        style: AppTextStyle.txtStyle.copyWith(
                          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '${order.total.toStringAsFixed(2)} ${LocaleKeys.cart_currency.tr()}',
                        style: AppTextStyle.txtStyle.copyWith(
                          color: AppColors.Primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, required bool isDark}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: AppTextStyle.txtStyle.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.txtStyle.copyWith(
              color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemTile(OrderItemModel item, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item.imageUrl,
              width: 40.w,
              height: 40.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 40.w,
                height: 40.h,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported, size: 20.r, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.txtStyle.copyWith(
                    color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'x${item.quantity}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${item.price.toStringAsFixed(2)} ${LocaleKeys.product_currency.tr()}',
            style: AppTextStyle.txtStyle.copyWith(
              color: isDark ? DarkColors.textSecondary : AppColors.Secondary,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
