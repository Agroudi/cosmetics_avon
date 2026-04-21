import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../widgets/app_form_field.dart';

class CreatePasswordScreen extends StatelessWidget {
  const CreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                        children: [
                          SizedBox(height: 43.h),
                          SvgPicture.asset(Assets.icons.authLogo),
                          SizedBox(height: 40.h),
                          Text(
                              LocaleKeys.create_pass_title.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp
                              )
                          ),
                          SizedBox(height: 40.h),
                          Text(
                              textAlign: TextAlign.center,
                              LocaleKeys.create_pass_statement.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Txt
                              )
                          ),
                          SizedBox(height: 62.h),
                          AppFormField(
                              label: LocaleKeys.new_pass_label.tr(),
                              isPassword: true
                          ),
                          SizedBox(height: 16.h),
                          AppFormField(
                              label: LocaleKeys.confirm_pass_label.tr(),
                              isPassword: true
                          ),
                          SizedBox(height: 56.h),
                          AppButton(
                            onPressed: () {},
                            txt: LocaleKeys.confirm_button.tr(),
                          ),
                          Spacer()
                        ]
                    )
                )
            )
        )
    );
  }
}