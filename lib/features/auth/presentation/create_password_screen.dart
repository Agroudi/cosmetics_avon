import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/auth/widgets/dialog.dart';
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
  String? value;
  String? countryCode;
  VerificationType? type;
  bool isFormValid = false;

  void validateForm() {
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    final isPasswordValid =
        password.length >= 8 &&
            RegExp(r'[A-Z]').hasMatch(password) &&
            RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    final isConfirmValid = password == confirm && confirm.isNotEmpty;

    setState(() {
      isFormValid = isPasswordValid && isConfirmValid;
    });
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      value = args['value'];
      countryCode = args['countryCode'];
      type = args['type'];
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepoImpl(AuthApiService())),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ResetPasswordLoading) {
                AppLoading.show(context);
              } else {
                if (state is ResetPasswordSuccess || state is ResetPasswordError) {
                  AppLoading.hide(context);
                }
              }

              if (state is ResetPasswordSuccess) {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  title: Text("Password reset successfully"),
                  autoCloseDuration: const Duration(seconds: 5),
                );
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return SharedDialog(
                      title: "Password Created!",
                      description: "Congratulations! Your password\n has been successfully created",
                      buttonText: "Return to Login",
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                              (route) => false,
                        );
                      },
                    );
                  },
                );
              }

              if (state is ResetPasswordError) {
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: SingleChildScrollView(
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
                                icon: Icon(Icons.arrow_back_ios, color: AppColors.Secondary),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            SvgPicture.asset(Assets.icons.authLogo),
                            SizedBox(height: 40.h),
                            Text(
                              LocaleKeys.create_pass_title.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Text(
                              textAlign: TextAlign.center,
                              LocaleKeys.create_pass_statement.tr(),
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Txt,
                              ),
                            ),
                            SizedBox(height: 62.h),
                            AppFormField(
                              controller: passwordController,
                              label: LocaleKeys.new_pass_form.tr(),
                              isPassword: true,
                              onChanged: (val) {
                                validateForm();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.password_required.tr();
                                }
                                if (value.length < 8) {
                                  return LocaleKeys.min_8_char.tr();
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return LocaleKeys.must_upper_case.tr();
                                }
                                if (!RegExp(r'[!@#$%^&*(),.?\":{}|<>]').hasMatch(value)) {
                                  return LocaleKeys.must_special.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            AppFormField(
                              controller: confirmController,
                              label: LocaleKeys.confirm_pass_label,
                              isPassword: true,
                              onChanged: (val) {
                                validateForm();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.confirm_pass_validate.tr();
                                }
                                if (value != passwordController.text) {
                                  return LocaleKeys.pass_not_match.tr();
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 56.h),
                            AppButton(
                              onPressed: isFormValid
                                  ? () {
                                if (!_formKey.currentState!.validate()) return;

                                context.read<AuthCubit>().resetPassword(
                                  countryCode: countryCode ?? '',
                                  phoneNumber: value ?? '',
                                  newPassword: passwordController.text,
                                  confirmPassword: confirmController.text,
                                );
                              }
                                  : null,
                              txt: LocaleKeys.confirm_button.tr(),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
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