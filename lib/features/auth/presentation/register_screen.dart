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
      return "Phone number is required";
    }

    switch (countryCode) {
      case '+20': // Egypt
        if (value.length < 10) {
          return "Egypt number is too short (10 digits required)";
        }
        if (value.length > 10) {
          return "Egypt number is too long (10 digits only)";
        }
        break;

      case '+966': // Saudi
        if (value.length < 9) {
          return "Saudi number is too short (9 digits required)";
        }
        if (value.length > 9) {
          return "Saudi number is too long (9 digits only)";
        }
        break;

      case '+971': // UAE
        if (value.length < 9) {
          return "UAE number is too short (9 digits required)";
        }
        if (value.length > 9) {
          return "UAE number is too long (9 digits only)";
        }
        break;

      case '+1': // USA
        if (value.length < 10) {
          return "US number is too short (10 digits required)";
        }
        if (value.length > 10) {
          return "US number is too long (10 digits only)";
        }
        break;

      case '+49': // Germany
        if (value.length < 10) {
          return "Germany number is too short (min 10 digits)";
        }
        if (value.length > 11) {
          return "Germany number is too long (max 11 digits)";
        }
        break;

      case '+98': // Iran
        if (value.length < 10) {
          return "Iran number is too short (10 digits required)";
        }
        if (value.length > 10) {
          return "Iran number is too long (10 digits only)";
        }
        break;

      default:
        return "This country is not supported yet";
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
                  title: const Text("User registered successfully. Please check your email for OTP."),
                  autoCloseDuration: const Duration(seconds: 5),
                );
                
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.verification,
                  arguments: {
                    "countryCode": selectedCountryCode,
                    "type": VerificationType.email,
                    "value": emailController.text.trim(),
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
                              onChanged: (value) {
                                validateForm();
                                _formKey.currentState!.validate();
                              },
                              label: LocaleKeys.name_label.tr(),
                              controller: userNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Username is required";
                                }

                                if (value.length < 3) {
                                  return "Username must be at least 3 characters";
                                }

                                if (value.length > 20) {
                                  return "Username can't exceed 20 characters";
                                }

                                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                  return "Only letters, numbers and _ allowed";
                                }

                                if (value.startsWith('_') || value.endsWith('_')) {
                                  return "Username can't start or end with _";
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
                                    return "Email is required";
                                  }

                                  final emailRegex = RegExp(
                                    r'^[\w\.-]+@[\w\.-]+\.com$',
                                  );

                                  if (!emailRegex.hasMatch(value)) {
                                    return "Email must be like example@example.com";
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
                                  return "Password is required";
                                }
                                if (value.length < 8) {
                                  return "Min 8 characters";
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return "Must contain 1 uppercase letter";
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return "Must contain 1 number";
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
                                  return "Confirm your password";
                                }
                                if (value != passwordController.text) {
                                  return "Passwords do not match";
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

                            SizedBox(height: 55.h),

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
              ),
            ),
          );
        },
      ),
    );
  }
}