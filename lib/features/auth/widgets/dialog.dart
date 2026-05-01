import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../gen/assets.gen.dart';


class SharedDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onPressed;

  const SharedDialog({
    super.key,
    this.title,
    this.description,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 360.w,
        height: 343.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.successDialouge,
              width: 80.w,
              height: 80.h,
            ),

            SizedBox(height: 20.h),

            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyle.txtStyle.copyWith(
                  color: AppColors.Secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 12.h),
            ],

            if (description != null) ...[
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTextStyle.txtStyle.copyWith(
                  color: AppColors.Txt,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30.h),
            ],

            if (buttonText != null && onPressed != null)
              AppButton(
                txt: buttonText!,
                onPressed: onPressed,
              ),
          ],
        ),
      ),
    );
  }
}