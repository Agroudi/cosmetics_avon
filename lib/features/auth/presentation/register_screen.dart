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
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../cubit/auth_cubit.dart';
import '../data/repo/auth_repo_impl.dart';
import '../data/services/auth_api_services.dart';
import '../widgets/dialog.dart';

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
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedCountryCode = '+20';
  bool isSubmitting = false;
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
    final username = userNameController.text.trim();
    final phone = phoneNumberController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final isUsernameValid = username.isNotEmpty && username.length >= 3;

    final isPhoneValid = validatePhone(phone, selectedCountryCode) == null;

    final isEmailValid = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.com$',
    ).hasMatch(email);

    final isPasswordValid = password.length >= 8;

    final isConfirmPasswordValid =
        confirmPassword == password && confirmPassword.isNotEmpty;

    setState(() {
      isFormValid =
          isUsernameValid &&
              isPhoneValid &&
              isEmailValid &&
              isPasswordValid &&
              isConfirmPasswordValid;
    });
  }

  bool isPasswordMatch = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
              if (state is RegisterLoading) {
                AppLoading.show(context);
              } else {
                if (state is RegisterSuccess || state is RegisterError) {
                  AppLoading.hide(context);
                }
              }

              if (state is RegisterSuccess) {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  title: Text(LocaleKeys.reg_success_toast.tr()),
                  autoCloseDuration: const Duration(seconds: 5),
                );
                Navigator.pushNamed(
                  context,
                  AppRoutes.verification,
                  arguments: {
                    "type": VerificationType.email,
                    "value": emailController.text.trim(),
                    "countryCode": selectedCountryCode,
                    "phoneNumber": phoneNumberController.text.trim(),
                  },
                );
              }

              if (state is RegisterError) {
                setState(() => isSubmitting = false);
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
                                icon: SvgPicture.asset(Assets.icons.backButton),
                              ),
                            ),
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
                              onChanged: (value) {
                                validateForm();
                                _formKey.currentState!.validate();
                              },
                              label: LocaleKeys.name_label.tr(),
                              controller: userNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.user_required.tr();
                                }

                                if (value.length < 3) {
                                  return LocaleKeys.user_min_characters.tr();
                                }

                                if (value.length > 20) {
                                  return LocaleKeys.user_max_characters.tr();
                                }

                                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                  return LocaleKeys.allowed_char_user.tr();
                                }

                                if (value.startsWith('_') || value.endsWith('_')) {
                                  return LocaleKeys.user_cant_start.tr();
                                }

                                return null;
                              },
                            ),

                            SizedBox(height: 38.h),

                            AppFormField(
                              label: LocaleKeys.email_label.tr(),
                              controller: emailController,
                              onChanged: (value) {
                                validateForm();
                              },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys.email_required.tr();
                                  }

                                  final emailRegex = RegExp(
                                    r'^[\w\.-]+@[\w\.-]+\.com$',
                                  );

                                  if (!emailRegex.hasMatch(value)) {
                                    return LocaleKeys.email_must_be.tr();
                                  }

                                  return null;
                                }
                            ),

                            SizedBox(height: 33.h),

                            AppPhoneField(
                              controller: phoneNumberController,
                              onCountryChanged: (code) {
                                selectedCountryCode = code;
                                validateForm();
                              },
                              validator: (value) {
                                return validatePhone(value!, selectedCountryCode);
                              },
                            ),

                            SizedBox(height: 16.h),

                            AppFormField(
                              label: LocaleKeys.create_pass_label.tr(),
                              controller: passwordController,
                              onChanged: (value) {
                                validateForm();
                              },
                              isPassword: true,
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
                              },
                            ),

                            SizedBox(height: 16.h),

                            AppFormField(
                              label: LocaleKeys.confirm_pass_label.tr(),
                              isPassword: true,
                              controller: confirmPasswordController,
                              onChanged: (value) {
                                validateForm();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.confirm_pass_validate.tr();
                                }
                                if (value != passwordController.text) {
                                  return LocaleKeys.pass_match_validate.tr();
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 17.h),

                            AppButton(
                              onPressed: isFormValid
                                  ? () {
                                if (!_formKey.currentState!.validate()) return;

                                context.read<AuthCubit>().register(
                                  userName: userNameController.text.trim(),
                                  countryCode: selectedCountryCode,
                                  phoneNumber: phoneNumberController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                                  : null,
                              txt: LocaleKeys.next_button.tr(),
                            ),

                            SizedBox(height: 50.h),

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
                                  onPressed: () {Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);},
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
              ),
            ),
          );
        },
      ),
    );
  }
}