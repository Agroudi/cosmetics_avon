import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:cosmetics_avon/features/auth/cubit/auth_cubit.dart';
import 'package:cosmetics_avon/features/cart/cubit/cart_cubit.dart';
import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_form_field.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
import 'package:cosmetics_avon/core/helpers/phone_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  bool isFormValid = false;

  void validateForm() {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    final isPhoneValid = PhoneValidator.validate(phone, countryCode) == null;
    final isPasswordValid = password.length >= 8;

    setState(() {
      isFormValid = isPhoneValid && isPasswordValid;
    });
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
                      title: Text(LocaleKeys.toast_success_login.tr()),
                      autoCloseDuration: const Duration(seconds: 5),
                    );

                    // The global CartCubit ran getCart() at app startup, before
                    // this session had a valid token, so its result was empty.
                    // Re-fetch now that we're authenticated so the cart (and the
                    // stock checks that depend on it) reflect the real server state.
                    context.read<CartCubit>().getCart(showLoading: false);

                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                  }

                  if (state is AuthUnverified) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.info,
                      title: Text(LocaleKeys.account_not_verified.tr()),
                      autoCloseDuration: const Duration(seconds: 5),
                    );

                    Navigator.pushNamed(
                      context,
                      AppRoutes.verification,
                      arguments: {
                        "type": VerificationType.phone,
                        "value": phoneController.text.trim(),
                        "countryCode": countryCode,
                        "phoneNumber": phoneController.text.trim(),
                        "isFromLogin": true,
                      },
                    );
                  }

                  if (state is AuthError) {
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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 13.w,
                    right: 13.w,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          SizedBox(height: 43.h),
                          Assets.images.login.image(width: 284.w, height: 227.h),
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
                              onChanged: (value) {
                                validateForm();
                              },
                              onCountryChanged: (code) {
                                countryCode = code;
                                validateForm();
                              },
                              validator: (value) {
                                return PhoneValidator.validate(value, countryCode);
                              },
                            ),
                          SizedBox(height: 8.h),
                          AppFormField(
                              controller: passwordController,
                              onChanged: (value) {
                                validateForm();
                              },
                              label: LocaleKeys.password_label.tr(),
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.password_required.tr();
                                }
                                if (value.length < 8) {
                                  return LocaleKeys.min_8_char.tr();
                                }
                                return null;
                              },
                            ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
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
                              onPressed: isFormValid
                                  ? () {
                                if (!_formKey.currentState!.validate()) return;

                                context.read<AuthCubit>().login(
                                  countryCode: countryCode,
                                  phoneNumber: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                                  : null,
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