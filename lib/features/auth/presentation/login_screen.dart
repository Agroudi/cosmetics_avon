import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:cosmetics_avon/features/auth/cubit/auth_cubit.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_form_field.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../../home/presentation/home_screen.dart';
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

  String countryCode = '+20';

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

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
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
                        ),
                        SizedBox(height: 8.h),
                        AppFormField(
                          controller: passwordController,
                          label: LocaleKeys.password_label.tr(),
                          isPassword: true,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
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
                                phone: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            },
                            txt: LocaleKeys.login_button.tr()
                        ),
                        Spacer(),
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
                                  onPressed: () {},
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
              );
            }
        )
    );
  }
}