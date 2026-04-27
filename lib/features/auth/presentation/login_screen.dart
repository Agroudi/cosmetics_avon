import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:cosmetics_avon/features/auth/cubit/auth_cubit.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_form_field.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

import '../data/repo/auth_repo_impl.dart';
import '../data/services/auth_api_services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String countryCode = '+20';

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
        create: (context) => AuthCubit(AuthRepoImpl(AuthApiService())),
        child: Builder(
            builder: (context) {
              return BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    AppLoading.show(context);
                  } else {
                    AppLoading.hide(context);
                  }

                  if (state is AuthSuccess) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.success,
                      title: Text("Login Successful"),
                    );

                    Navigator.pushNamed(context, AppRoutes.home);
                  }

                  if (state is AuthError) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.error,
                      title: Text(state.message),
                    );
                  }
                },
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 13,
                    right: 13,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 43.h),
                          Assets.images.login.image(width: 284, height: 227),
                          SizedBox(height: 25.h),
                          Text(
                              LocaleKeys.login_now.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp
                              )
                          ),
                          SizedBox(height: 14.h),
                          Text(
                              LocaleKeys.login_statement.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Txt
                              )
                          ),
                          SizedBox(height: 41.h),
                          AppPhoneField(
                            controller: phoneController,
                            onCountryChanged: (code) {
                              countryCode = code;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone is required";
                              }
                              return validatePhone(value, countryCode);
                            },
                          ),
                          SizedBox(height: 8.h),
                          AppFormField(
                            controller: passwordController,
                            label: LocaleKeys.password_label.tr(),
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
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) return;

                                    context.read<AuthCubit>().login(
                                      countryCode: countryCode,
                                      phoneNumber: phoneController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                                  },
                                  child: Text(
                                      LocaleKeys.forgot_password.tr(),
                                      style: AppTextStyle.txtStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          color: AppColors.Primary
                                      )
                                  )
                              )
                          ),
                          SizedBox(height: 43.h),
                          AppButton(
                              onPressed: () {
                                context.read<AuthCubit>().login(
                                  countryCode: countryCode,
                                  phoneNumber: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              },
                              txt: LocaleKeys.login_button.tr()
                          ),
                        SizedBox(height: 82.h),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    LocaleKeys.dont_have_account.tr(),
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: AppColors.Txt,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    )
                                ),
                                TextButton(
                                    onPressed: () {Navigator.pushNamed(context, AppRoutes.register);},
                                    child: Text(
                                        LocaleKeys.register.tr(),
                                        style: AppTextStyle.txtStyle.copyWith(
                                            color: AppColors.Primary,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600
                                        )
                                    )
                                )
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
              );
            }
        )
    );
  }
}