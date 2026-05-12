import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {

    return TextField(

      decoration: InputDecoration(
        hintText: LocaleKeys.search_hint.tr(),
        hintStyle: AppTextStyle.txtStyle.copyWith(
          color: AppColors.SearchBar,
          fontSize: 14.sp,
        ),

        suffixIcon: Padding(
          padding: EdgeInsets.all(14.r),
          child: SvgPicture.asset(
            Assets.icons.search,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(
            color: AppColors.SearchBar,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(
            color: AppColors.SearchBar,
          ),
        ),
      ),
    );
  }
}