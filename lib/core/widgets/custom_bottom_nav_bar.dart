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

    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.symmetric(
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(.08),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: List.generate(
          icons.length,
              (index) => GestureDetector(
            onTap: () => onTap(index),

            child: SvgPicture.asset(
              icons[index],

              colorFilter: ColorFilter.mode(
                currentIndex == index
                    ? AppColors.Primary
                    : AppColors.Disabled,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}