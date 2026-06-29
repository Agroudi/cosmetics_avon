import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/theme/text_style.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/home_search_bar.dart';
import '../../../gen/locale_keys.g.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_banner.dart';
import '../widgets/product_grid_item.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    final homeState = context.watch<HomeCubit>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: Text(state.message),
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
        ),
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartItemAdded) {
              AppToast.show(
                context,
                type: ToastificationType.success,
                title: Text(LocaleKeys.added_to_cart_success.tr()),
              );
            }

            if (state is CartInfoState) {
              AppToast.show(
                context,
                type: ToastificationType.info,
                title: Text(state.message),
              );
            }

            if (state is CartError) {
              AppToast.show(
                context,
                type: ToastificationType.error,
                title: Text(state.message),
              );
            }
          },
        ),
      ],
      child: SafeArea(
        child: homeState is HomeLoading
            ? const Center(child: LoadingWidget())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      const HomeSearchBar(),
                      SizedBox(height: 24.h),
                      if (cubit.sliders.isNotEmpty)
                        HomeBanner(sliders: cubit.sliders),
                      SizedBox(height: 30.h),
                      Text(
                        LocaleKeys.top_rated_products.tr(),
                        style: AppTextStyle.txtStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      cubit.filteredProducts.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64.r,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      LocaleKeys.no_results_found.tr(),
                                      style: AppTextStyle.txtStyle.copyWith(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.filteredProducts.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 16.h,
                                childAspectRatio: 176 / 273,
                              ),
                              itemBuilder: (context, index) {
                                return ProductGridItem(
                                  product: cubit.filteredProducts[index],
                                );
                              },
                            ),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
