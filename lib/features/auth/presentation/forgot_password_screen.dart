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

  String? validatePhone(String value, String countryCode) {
    value = value.replaceAll(RegExp(r'\s+'), '');

    switch (countryCode) {
      case '+20': // Egypt
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return "Egypt phone must be 10 digits";
        }
        break;

      case '+966': // Saudi
        if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
          return "Saudi phone must be 9 digits";
        }
        break;

      case '+971': // UAE
        if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
          return "UAE phone must be 9 digits";
        }
        break;

      case '+1': // USA
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return "US phone must be 10 digits";
        }
        break;

      case '+49': // Germany
        if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
          return "Germany phone must be 10–11 digits";
        }
        break;

      case '+98': // Iran
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return "Iran phone must be 10 digits";
        }
        break;

      default:
        return "Unsupported country";
    }

    return null;
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
                        title: const Text("Code sent"),
                      );

                      Navigator.pushNamed(
                        context,
                        AppRoutes.verification,
                        arguments: {
                          "type": VerificationType.phone,
                          "value": phoneController.text.trim(),
                          "countryCode": "+20",
                        },
                      );
                    }

                    if (state is ForgotPasswordError) {
                      toastification.show(
                        context: context,
                        type: ToastificationType.error,
                        title: Text(state.message),
                      );
                    }
                  },
                  child: Scaffold(
                      body: SafeArea(
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                        children: [
                                          SizedBox(height: 43.h),
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
                                            onCountryChanged: (code) {
                                              selectedCountryCode = code;
                                            },
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Phone is required";
                                              }
                                              return validatePhone(value, selectedCountryCode);
                                            },
                                          ),
                                          SizedBox(height: 56.h),
                                          AppButton(
                                            onPressed: () {
                                              if (!_formKey.currentState!.validate()) return;

                                              context.read<AuthCubit>().forgotPassword(
                                                phoneNumber: phoneController.text.trim(),
                                                countryCode: selectedCountryCode,
                                              );
                                            },
                                            txt: LocaleKeys.next_button.tr(),
                                          ),
                                          Spacer()
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