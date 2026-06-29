import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/assets.gen.dart';
import '../data/models/category_model.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/app_routes.dart';
import '../../home/cubit/home_cubit.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final categoryTitle = isArabic ? category.titleAr : category.titleEn;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.categoryProducts,
              arguments: {
                'categoryId': category.id,
                'categoryTitle': categoryTitle,
                'products': context.read<HomeCubit>().products,
              },
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          splashColor: AppColors.Primary.withOpacity(0.12),
          highlightColor: AppColors.Primary.withOpacity(0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    category.imageUrl,
                    width: 64.w,
                    height: 69.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    categoryTitle,
                    style: AppTextStyle.txtStyle.copyWith(
                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  Assets.icons.goto,
                  width: 12.w,
                  height: 12.h,
                  matchTextDirection: true,
                  colorFilter: ColorFilter.mode(
                    isDark ? DarkColors.textSecondary : AppColors.Secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Divider(
          color: isDark ? DarkColors.divider : Colors.grey.withOpacity(.2),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}