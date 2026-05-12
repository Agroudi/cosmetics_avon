import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/assets.gen.dart';
import '../data/models/category_model.dart';

class CategoryItem extends StatelessWidget {

  final CategoryModel category;

  const CategoryItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Row(
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
                category.titleEn,
                style: AppTextStyle.txtStyle.copyWith(
                  color: AppColors.Secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),

            SvgPicture.asset(
              Assets.icons.goto,
              width: 12.w,
              height: 12.h,
              colorFilter: ColorFilter.mode(AppColors.Secondary, BlendMode.srcIn),
            ),
          ],
        ),

        SizedBox(height: 21.h),

        Divider(
          color: Colors.grey.withOpacity(.2),
        ),
        SizedBox(height: 21.h),
      ],
    );
  }
}