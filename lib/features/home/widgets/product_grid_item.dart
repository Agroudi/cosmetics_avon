import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';
import '../../cart/cubit/cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/locale_keys.g.dart';
import '../data/models/product_model.dart';
import '../presentation/product_details_screen.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final name = isArabic ? product.nameAr : product.nameEn;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetails,
          arguments: product,
        );
      },
      child: Container(
      width: 176.w,
      height: 273.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: isDark ? Colors.black.withOpacity(.3) : Colors.black.withOpacity(.08),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 11,
                  left: 8,
                  right: 8,
                ),
                child: Hero(
                  tag: productHeroTag(product.id),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: Image.network(
                      product.imageUrl,
                      height: 169.h,
                      width: 181.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              BlocSelector<CartCubit, CartState, int>(
                selector: (state) {
                  final item = context
                      .read<CartCubit>()
                      .cartItems
                      .where((e) => e.productId == product.id)
                      .firstOrNull;
                  return item?.quantity ?? 0;
                },
                builder: (context, currentQuantity) {
                  final isOutOfStock = currentQuantity >= product.stock;

                  return Positioned(
                    top: 14.h,
                    right: 15.w,
                    child: GestureDetector(
                      onTap: () {
                        if (isOutOfStock) {
                          AppToast.show(
                            context,
                            type: ToastificationType.info,
                            title: Text(LocaleKeys.out_of_stock_toast.tr()),
                            autoCloseDuration: const Duration(seconds: 5),
                          );
                          return;
                        }

                        debugPrint("ADD CLICKED");

                        context.read<CartCubit>().addToCart(product);

                        final left = product.stock - (currentQuantity + 1);
                        if (left == 1 || left == 2) {
                          AppToast.show(
                            context,
                            type: ToastificationType.info,
                            title: Text(
                              LocaleKeys.low_stock_toast.tr(args: [left.toString()]),
                            ),
                            autoCloseDuration: const Duration(seconds: 5),
                          );
                        }
                      },
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: isDark ? DarkColors.surfaceBackground : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.icons.addCart,
                            colorFilter: isOutOfStock
                                ? ColorFilter.mode(
                                    AppColors.Disabled,
                                    BlendMode.srcIn,
                                  )
                                : ColorFilter.mode(
                                    AppColors.Primary,
                                    BlendMode.srcIn,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.txtStyle.copyWith(
                    color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 11.h),

                Text(
                  "${product.price} ${LocaleKeys.product_currency.tr()}",
                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.GridPrices,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
