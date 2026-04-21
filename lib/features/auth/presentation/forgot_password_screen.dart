import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();

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
                              LocaleKeys.forgot_pass_title.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp
                              )
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            textAlign: TextAlign.center,
                              LocaleKeys.forgot_pass_statement.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Txt
                              )
                          ),
                          SizedBox(height: 62.h),
                          AppPhoneField(controller: phoneController),
                          SizedBox(height: 56.h),
                          AppButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VerificationScreen(
                                    type: VerificationType.phone,
                                    value: phoneController.text.trim(),
                                  ),
                                ),
                              );
                            },
                            txt: LocaleKeys.next_button.tr(),
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