import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../../home/cubit/home_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartItemRemoved) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: Text(LocaleKeys.cart_item_removed.tr()),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.watch<CartCubit>();

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 20.h),

                SizedBox(
                  height: 32.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        LocaleKeys.my_cart_title.tr(),
                        style: AppTextStyle.txtStyle.copyWith(
                          color: AppColors.Secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.checkout),
                          child: SvgPicture.asset(Assets.icons.checkout),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                Text(
                  LocaleKeys.products_in_cart.tr(args: [cubit.productsCount.toString()]),

                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.TxtCart,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(height: 24.h),

                Expanded(
                  child: cubit.cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                Assets.lottie.shoppingOnline,
                                width: 250.w,
                                height: 250.h,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                LocaleKeys.empty_cart_msg.tr(),
                                style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Txt,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cubit.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cubit.cartItems[index];
                            final product = context
                                .read<HomeCubit>()
                                .products
                                .where((p) => p.id == item.productId)
                                .firstOrNull;
                            final stock = product?.stock ?? 999;
                            final isMaxStock = item.quantity >= stock;

                            return CartItem(
                              item: item,
                              isMaxStock: isMaxStock,
                              onDelete: () {
                                cubit.removeItem(item.productId);
                              },
                              onPlus: () {
                                if (isMaxStock) {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.info,
                                    title: Text(
                                      LocaleKeys.out_of_stock_toast.tr(),
                                    ),
                                    autoCloseDuration: const Duration(
                                      seconds: 5,
                                    ),
                                  );
                                } else {
                                  cubit.increaseQuantity(item);
                                  final left = stock - (item.quantity + 1);
                                  if (left == 1 || left == 2) {
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.info,
                                      title: Text(
                                        LocaleKeys.low_stock_toast.tr(args: [left.toString()]),
                                      ),
                                      autoCloseDuration: const Duration(
                                        seconds: 5,
                                      ),
                                    );
                                  }
                                }
                              },
                              onMinus: () {
                                cubit.decreaseQuantity(item);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
