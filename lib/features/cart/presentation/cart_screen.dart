import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CartCubit, CartState>(

        builder: (context, state) {

          final cubit = context.watch<CartCubit>();

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "My Cart",

                        style: AppTextStyle.txtStyle.copyWith(
                          color: AppColors.Secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                        ),
                      ),

                      SvgPicture.asset(
                        Assets.icons.checkout,
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "You have ${cubit.productsCount} products in your cart",

                    style: AppTextStyle.txtStyle.copyWith(
                      color: AppColors.TxtCart,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Expanded(
                    child: ListView.builder(

                      itemCount: cubit.cartItems.length,

                      itemBuilder: (context, index) {

                        final item = cubit.cartItems[index];

                        return CartItem(

                          item: item,

                          onDelete: () {
                            cubit.removeItem(item.productId);
                          },

                          onPlus: () {
                            cubit.increaseQuantity(item);
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