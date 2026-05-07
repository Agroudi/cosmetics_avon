import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
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

  String? validatePhone(String value, String countryCode) {
    value = value.replaceAll(RegExp(r'\D'), '');

    if (value.isEmpty) {
      return LocaleKeys.empty_number.tr();
    }

    switch (countryCode) {
      case '+20': // Egypt
        if (value.length < 10) {
          return LocaleKeys.short_egy_number.tr();
        }
        if (value.length > 10) {
          return LocaleKeys.long_egy_number.tr();
        }
        break;

      case '+966': // Saudi
        if (value.length < 9) {
          return LocaleKeys.short_ksa_number.tr();
        }
        if (value.length > 9) {
          return LocaleKeys.long_ksa_number.tr();
        }
        break;

      case '+971': // UAE
        if (value.length < 9) {
          return LocaleKeys.short_uae_number.tr();
        }
        if (value.length > 9) {
          return LocaleKeys.long_uae_number;
        }
        break;

      case '+1': // USA
        if (value.length < 10) {
          return LocaleKeys.short_us_number.tr();
        }
        if (value.length > 10) {
          return LocaleKeys.long_us_number.tr();
        }
        break;

      case '+49': // Germany
        if (value.length < 10) {
          return LocaleKeys.short_german_number.tr();
        }
        if (value.length > 11) {
          return LocaleKeys.long_german_number.tr();
        }
        break;

      case '+98': // Iran
        if (value.length < 10) {
          return LocaleKeys.short_iran_number.tr();
        }
        if (value.length > 10) {
          return LocaleKeys.long_iran_number.tr();
        }
        break;

      default:
        return LocaleKeys.unsupported_number.tr();
    }

    return null;
  }

  void validateForm() {
    final phone = phoneController.text.trim();

    final isPhoneValid = validatePhone(phone, selectedCountryCode) == null;

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
                          "PhoneNumber": phoneController.text.trim(),
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
                                              if (value == null || value.isEmpty) {
                                                return LocaleKeys.empty_number.tr();
                                              }
                                              return validatePhone(value, selectedCountryCode);
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