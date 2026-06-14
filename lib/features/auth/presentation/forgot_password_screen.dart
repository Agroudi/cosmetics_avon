import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
import 'package:cosmetics_avon/core/helpers/phone_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../cubit/auth_cubit.dart';
import '../data/repo/auth_repo_impl.dart';
import '../data/services/auth_api_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = '+20';
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  void validateForm() {
    final phone = phoneController.text.trim();

    final isPhoneValid = PhoneValidator.validate(phone, selectedCountryCode) == null;

    setState(() {
      isFormValid = isPhoneValid;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AuthCubit(AuthRepoImpl(AuthApiService())),
        child: Builder(
            builder: (context) {
              return BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordLoading) {
                      AppLoading.show(context);
                    } else {
                      AppLoading.hide(context);
                    }

                    if (state is ForgotPasswordSuccess) {
                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        title: Text(LocaleKeys.forgot_pass_otp.tr()),
                        autoCloseDuration: const Duration(seconds: 5),
                      );

                      Navigator.pushNamed(
                        context,
                        AppRoutes.verification,
                        arguments: {
                          "type": VerificationType.phone,
                          "value": phoneController.text.trim(),
                          "countryCode": selectedCountryCode,
                          "phoneNumber": phoneController.text.trim(),
                        },
                      );
                    }

                    if (state is ForgotPasswordError) {
                      toastification.show(
                        context: context,
                        type: ToastificationType.error,
                        title: Text(state.message),
                        autoCloseDuration: const Duration(seconds: 5),
                      );
                    }
                  },
                  child: Scaffold(
                      body: SafeArea(
                          child: SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 13),
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                      children: [
                                        SizedBox(height: 20.h),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            onPressed: () => Navigator.pop(context),
                                            icon: SvgPicture.asset(Assets.icons.backButton),
                                          ),
                                        ),
                                        SvgPicture.asset(Assets.icons.authLogo),
                                        SizedBox(height: 40.h),
                                          Text(
                                              LocaleKeys.forgot_pass_title.tr(),
                                              style: AppTextStyle.txtStyle
                                                  .copyWith(
                                                  color: AppColors.Secondary,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 24.sp
                                              )
                                          ),
                                          SizedBox(height: 40.h),
                                          Text(
                                              textAlign: TextAlign.center,
                                              LocaleKeys.forgot_pass_statement
                                                  .tr(),
                                              style: AppTextStyle.txtStyle
                                                  .copyWith(
                                                  color: AppColors.Txt
                                              )
                                          ),
                                          SizedBox(height: 62.h),
                                          AppPhoneField(
                                            controller: phoneController,
                                            onChanged: (value) {
                                              validateForm();
                                            },
                                            onCountryChanged: (code) {
                                              selectedCountryCode = code;
                                              validateForm();
                                            },
                                            validator: (value) {
                                              return PhoneValidator.validate(value, selectedCountryCode);
                                            },
                                          ),
                                          SizedBox(height: 56.h),
                                          AppButton(
                                            onPressed: isFormValid
                                                ? () {
                                              if (!_formKey.currentState!.validate()) return;

                                              context.read<AuthCubit>().forgotPassword(
                                                phoneNumber: phoneController.text.trim(),
                                                countryCode: selectedCountryCode,
                                              );
                                            }
                                                : null,
                                            txt: LocaleKeys.next_button.tr(),
                                          ),
                                          SizedBox(height: 20.h),
                                        ]
                                    ),
                                  )
                              )
                          )
                      )
                  )
              );
            }
        )
    );
  }
}
