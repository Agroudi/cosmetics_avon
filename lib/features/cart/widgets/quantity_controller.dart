import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';

class QuantityController extends StatelessWidget {

  final int quantity;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final bool isMaxStock;

  const QuantityController({
    super.key,
    required this.quantity,
    required this.onPlus,
    required this.onMinus,
    this.isMaxStock = false,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 144.w,
      height: 48.h,

      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.SearchBar,
        ),

        borderRadius: BorderRadius.circular(12.r),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          IconButton(
            onPressed: quantity > 1 ? onMinus : null,
            icon: Icon(
              Icons.remove,
              color: quantity > 1 ? AppColors.Secondary : AppColors.Disabled,
            ),
          ),

          Text(
            quantity.toString(),

            style: AppTextStyle.txtStyle.copyWith(
              color: AppColors.Secondary,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),

          IconButton(
            onPressed: onPlus,
            icon: Icon(
              Icons.add,
              color: isMaxStock ? AppColors.Disabled : AppColors.Secondary,
            ),
          ),
        ],
      ),
    );
  }
}