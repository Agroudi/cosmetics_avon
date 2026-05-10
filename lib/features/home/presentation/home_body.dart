import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/theme/text_style.dart';
import '../../../core/widgets/home_search_bar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_banner.dart';
import '../widgets/product_grid_item.dart';

class HomeBody extends StatelessWidget {

  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();

    return BlocListener<CartCubit, CartState>(

        listener: (context, state) {

          if(state is CartItemAdded){

            toastification.show(

              context: context,

              type: ToastificationType.success,

              autoCloseDuration: const Duration(seconds: 3),

              title: const Text(
                "Added to cart successfully",
              ),
            );
          }

          if(state is CartInfoState){

            toastification.show(

              context: context,

              type: ToastificationType.info,

              title: Text(state.message),
            );
          }

          if(state is CartError){

            toastification.show(

              context: context,

              type: ToastificationType.error,

              title: Text(state.message),
            );
          }
        },

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  const HomeSearchBar(),
                  SizedBox(height: 24.h),
                  if (cubit.sliders.isNotEmpty)
                    HomeBanner(
                      slider: cubit.sliders.first,
                    ),
                  SizedBox(height: 30.h),
                  Text(
                    "Top rated products",
                    style: AppTextStyle.txtStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cubit.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 176 / 273,
                    ),
                    itemBuilder: (context, index) {
                      return ProductGridItem(
                        product: cubit.products[index],
                      );
                    },
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        )
    );
  }
}