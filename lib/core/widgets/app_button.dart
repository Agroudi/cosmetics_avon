import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/text_style.dart';

class AppButton extends StatelessWidget {
  AppButton({super.key, required this.txt,required this.onPressed, this.color});

  final String txt;
  Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.Primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60)
        ),
        minimumSize: Size(268.w, 65.h),
      ),
      child: Text(
        txt.tr(),
          style: AppTextStyle.txtStyle.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Segoe UI'
          )
      ),
    );
  }
}