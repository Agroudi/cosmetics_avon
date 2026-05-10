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
  String? countryCode;
  String? phoneNumber;
  VerificationType? type;
  bool isFormValid = false;

  void validateForm() {
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    final isPasswordValid =
        password.length >= 8 &&
            RegExp(r'[A-Z]').hasMatch(password) &&
            RegExp(r'[0-9]').hasMatch(password) &&
            RegExp(r'[!@#\$&*~%^()_\-+=<>?/{}[\]|]').hasMatch(password);

    final isConfirmValid =
        confirm.isNotEmpty &&
            password == confirm;

    setState(() {
      isFormValid = isPasswordValid && isConfirmValid;
    });
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map) {
      countryCode = args['countryCode'];
      phoneNumber = args['phoneNumber'];
      type = args['type'];

      debugPrint("ARGS => $args");
      debugPrint("PHONE => $phoneNumber");
      debugPrint("COUNTRY => $countryCode");
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
                  title: Text(LocaleKeys.pass_reset_toast.tr()),
                  autoCloseDuration: const Duration(seconds: 5),
                );
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return PopScope(
                      canPop: false,
                      child: SharedDialog(
                        title: LocaleKeys.pass_title_dialog.tr(),
                        description: LocaleKeys.pass_desc_dialog.tr(),
                        buttonText: LocaleKeys.pass_button_dailog.tr(),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                                (route) => false,
                          );
                        },
                      ),
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
            child: PopScope(
              canPop: false,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 40.h),
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

                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return LocaleKeys.must_number.tr();
                                }

                                if (!RegExp(r'[!@#\$&*~%^()_\-+=<>?/{}[\]|]').hasMatch(value)) {
                                  return LocaleKeys.must_special.tr();
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            AppFormField(
                              controller: confirmController,
                              label: LocaleKeys.confirm_pass_label.tr(),
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

                                      if (phoneNumber == null || phoneNumber!.isEmpty) {
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.error,
                                          title: const Text("Error: Phone number missing"),
                                        );
                                        return;
                                      }
                                      context.read<AuthCubit>().resetPassword(
                                        countryCode: countryCode ?? '+20',
                                        phoneNumber: phoneNumber!,
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
