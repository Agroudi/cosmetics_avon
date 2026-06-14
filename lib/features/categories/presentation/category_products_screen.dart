import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../home/data/models/product_model.dart';
import '../../home/widgets/product_grid_item.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../../../core/widgets/app_loading.dart';

class CategoryProductsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryTitle;
  final List<ProductModel> products;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Filter products locally by categoryId
    final filtered = products.where((p) => p.categoryId == categoryId).toList();

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartItemUpdating) {
          AppLoading.show(context);
        } else if (state is CartItemAdded ||
            state is CartItemRemoved ||
            state is CartLoaded ||
            state is CartError ||
            state is CartSuccess) {
          AppLoading.hide(context);
        }

        if (state is CartItemAdded) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            title: Text(LocaleKeys.added_to_cart_success.tr()),
          );
        } else if (state is CartError) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            title: Text(state.message),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
        title: Text(
          categoryTitle,
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
        child: filtered.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64.r,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LocaleKeys.no_results_found.tr(), // or empty products translation
                      style: AppTextStyle.txtStyle.copyWith(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(13.r),
                child: GridView.builder(
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 176 / 273,
                  ),
                  itemBuilder: (context, index) {
                    return ProductGridItem(
                      product: filtered[index],
                    );
                  },
                ),
              ),
      ),
    ),
    );
  }
}
