import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/app_form_field.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String value;
  String? countryCode;
  late VerificationType type;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    value = args['value'];
    countryCode = args['countryCode'];
    type = args['type'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Form(
                      key: _formKey,
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
                              controller: passwordController,
                              label: "New Password",
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password is required";
                                }
                                if (value.length < 8) {
                                  return "Min 8 characters";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            AppFormField(
                              controller: confirmController,
                              label: "Confirm Password",
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirm password";
                                }
                                if (value != passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 56.h),
                            AppButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;

                                context.read<AuthCubit>().resetPassword(
                                  countryCode: countryCode ?? '',
                                  phoneNumber: value,
                                  newPassword: passwordController.text,
                                  confirmPassword: confirmController.text,
                                );
                              },
                              txt: LocaleKeys.confirm_button.tr(),
                            ),
                            Spacer()
                          ]
                      ),
                    )
                )
            )
        )
    );
  }
}