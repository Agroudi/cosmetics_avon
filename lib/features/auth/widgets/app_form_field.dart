import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../gen/assets.gen.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Function(String)? onChanged;
  final String? errorText;

  AppFormField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isPassword = false,
    this.onChanged,
    this.errorText
  });

  final ValueNotifier<bool> _obscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscure,
      builder: (context, obscure, _) {
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? obscure : false,
          validator: validator,
          onChanged: onChanged,
          cursorColor: AppColors.Primary,
          style: TextStyle(
            color: AppColors.Primary,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            labelText: label,
            errorText: errorText,
            labelStyle: AppTextStyle.txtStyle.copyWith(
              color: AppColors.Txt,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.Txt),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.Primary),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),

            suffixIcon: isPassword
                ? GestureDetector(
              onTap: () {
                _obscure.value = !obscure;
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SvgPicture.asset(
                  obscure
                      ? Assets.icons.eyeTrue
                      : Assets.icons.eyeFalse,
                  width: 20.w,
                  height: 15.h,
                ),
              ),
            )
                : null,
          ),
        );
      },
    );
  }
}