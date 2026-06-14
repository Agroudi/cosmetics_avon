import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../gen/assets.gen.dart';

class CustomBottomNavBar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final icons = [
      Assets.icons.home,
      Assets.icons.categories,
      Assets.icons.cart,
      Assets.icons.profile,
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.symmetric(
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.cardBackground : Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            offset: const Offset(0, 4),
            color: isDark ? Colors.black.withOpacity(.3) : Colors.black.withOpacity(.08),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: List.generate(
          icons.length,
          (index) => InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(100.r),
            splashColor: AppColors.Primary.withOpacity(0.15),
            highlightColor: AppColors.Primary.withOpacity(0.05),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: SvgPicture.asset(
                icons[index],
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  currentIndex == index
                      ? AppColors.Primary
                      : (isDark ? DarkColors.textSecondary : AppColors.Disabled),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}