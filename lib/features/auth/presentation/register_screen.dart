import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_form_field.dart';
import 'package:cosmetics_avon/features/auth/widgets/app_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../cubit/auth_cubit.dart';
import '../data/repo/auth_repo_impl.dart';
import '../data/services/auth_api_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController countyCodeController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        AuthRepoImpl(
          AuthApiService(),
        ),
      ),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {

              if (state is RegisterLoading)
              {
                AppLoading.show(context);
              }

              if (state is RegisterSuccess || state is RegisterError)
              {
                AppLoading.hide(context);
              }
              if (state is RegisterSuccess)
              {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  title: const Text("Account created successfully"),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerificationScreen(
                      type: VerificationType.email,
                      value: emailController.text.trim(),
                    ),
                  ),
                );
              }

              if (state is RegisterError)
              {
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

                        SizedBox(height: 40.h),

                        SvgPicture.asset(Assets.icons.authLogo),

                        SizedBox(height: 40.h),

                        Text(
                          LocaleKeys.create_account.tr(),
                          style: AppTextStyle.txtStyle.copyWith(
                            color: AppColors.Secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        ),

                        SizedBox(height: 72.h),

                        AppFormField(
                          label: LocaleKeys.name_label.tr(),
                          controller: userNameController,
                        ),

                        SizedBox(height: 38.h),

                        AppFormField(
                          label: LocaleKeys.email_label.tr(),
                          controller: emailController,
                        ),

                        SizedBox(height: 33.h),

                        AppPhoneField(
                          controller: phoneNumberController,
                        ),

                        SizedBox(height: 16.h),

                        AppFormField(
                          label: LocaleKeys.create_pass_label.tr(),
                          controller: passwordController,
                          isPassword: true,
                        ),

                        SizedBox(height: 16.h),

                        AppFormField(
                          label: LocaleKeys.confirm_pass_label.tr(),
                          isPassword: true,
                        ),

                        SizedBox(height: 17.h),

                        AppButton(
                          onPressed: () {
                            context.read<AuthCubit>().register(
                              email: emailController.text.trim(),
                              userName: userNameController.text.trim(),
                              phoneNumber: phoneNumberController.text.trim(),
                              password: passwordController.text.trim(),
                              countryCode: '+20',
                            );
                          },
                          txt: LocaleKeys.next_button.tr(),
                        ),

                        Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.have_an_account.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Txt,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                LocaleKeys.login.tr(),
                                style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Primary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}