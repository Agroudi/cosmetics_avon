import 'dart:async';

import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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

enum VerificationType {
  email,
  phone,
}

class VerificationScreen extends StatefulWidget {
  final VerificationType type;
  final String value;
  final String? countryCode;
  final String? phoneNumber;

  const VerificationScreen({
    super.key,
    required this.type,
    required this.value,
    this.countryCode,
    this.phoneNumber,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  int seconds = 30;
  int resendAttempt = 0;
  final List<int> backoffTimes = [30, 60, 120, 300];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AuthCubit(AuthRepoImpl(AuthApiService())),
        child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is VerifyLoading) {
                AppLoading.show(context);
              } else {
                if (state is VerifySuccess || state is VerifyError || state is ResendOtpSuccess) {
                  AppLoading.hide(context);
                }
              }

              if (state is ResendOtpSuccess) {
                toastification.show(
                  context: context,
                  type: ToastificationType.info,
                  title: const Text("Another code has been sent"),
                  autoCloseDuration: const Duration(seconds: 5),
                );
              }

              if (state is VerifySuccess) {
                if (widget.type == VerificationType.email) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => SharedDialog(
                      title: "Account Activated!",
                      description: "Congratulations! Your account has been successfully activated",
                      buttonText: "Go to login",
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                              (route) => false,
                        );
                      },
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => SharedDialog(
                      title: "Password Created!",
                      description: "Congratulations! Your password\n has been successfully created",
                      buttonText: "Return to login",
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                    ),
                  );
                }
              }

              if (state is VerifyError) {
                toastification.show(
                  context: context,
                  type: ToastificationType.error,
                  title: Text(state.message),
                  autoCloseDuration: const Duration(seconds: 5),
                );
              }
            },
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
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
                            SvgPicture.asset(Assets.icons.authLogo),
                            SizedBox(height: 40.h),
                            Text(
                                LocaleKeys.verify_code.tr(),
                                style: AppTextStyle.txtStyle.copyWith(
                                    color: AppColors.Secondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp
                                )
                            ),
                            SizedBox(height: 40.h),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: AppTextStyle.txtStyle.copyWith(
                                  color: AppColors.Txt,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.type == VerificationType.email
                                        ? LocaleKeys.verify_statement_1_email.tr()
                                        : LocaleKeys.verify_statement_1_phone.tr(),
                                  ),

                                  TextSpan(
                                    text: widget.value,
                                    style: TextStyle(
                                      color: AppColors.Secondary,
                                    ),
                                  ),

                                  TextSpan(
                                    text: LocaleKeys.verify_statement_2.tr(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Align(
                              alignment: AlignmentGeometry.centerLeft,
                              child: InkWell(
                                onTap: (){Navigator.pop(context);},
                                child: Text(
                                  widget.type == VerificationType.email
                                      ? 'Edit the email'
                                      : 'Edit the number',
                                  style: AppTextStyle.txtStyle.copyWith(
                                    color: AppColors.Primary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            MaterialPinField(
                              length: 4,
                              onCompleted: (pin) {},
                              onChanged: (value) {
                                setState(() {
                                  otpController.text = value;
                                });
                              },
                              theme: MaterialPinTheme(
                                enableErrorShake: true,
                                cursorColor: AppColors.Primary,
                                borderColor: AppColors.PinBorder,
                                focusedBorderColor: AppColors.Primary,
                                focusedFillColor: Colors.transparent,
                                fillColor: Colors.transparent,
                                filledBorderColor: AppColors.Primary,
                                filledFillColor: Colors.transparent,
                                errorBorderColor: AppColors.Error,
                                errorColor: AppColors.Error,
                                completeFillColor: Colors.transparent,
                                completeBorderColor: AppColors.Primary,
                                completeTextStyle: AppTextStyle.txtStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                                textStyle: AppTextStyle.txtStyle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                                cellSize: Size(45.w, 45.h),
                                shape: MaterialPinShape.outlined,
                                spacing: 12.w,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(height: 43.h),
                            Row(
                              children: [
                                Text(
                                  LocaleKeys.code_receive.tr(),
                                  style: AppTextStyle.txtStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    if (seconds != 0) return;

                                    if (widget.type == VerificationType.phone) {
                                  context.read<AuthCubit>().resendOtp(
                                    countryCode: widget.countryCode,
                                    phoneNumber: widget.value,
                                  );
                                } else {
                                  context.read<AuthCubit>().resendOtp(
                                    email: widget.value,
                                    countryCode: widget.countryCode,
                                    phoneNumber: widget.phoneNumber,
                                  );
                                }

                                    setState(() {
                                      if (resendAttempt < backoffTimes.length - 1) {
                                        resendAttempt++;
                                      } else {
                                        resendAttempt = backoffTimes.length - 1;
                                      }
                                      seconds = backoffTimes[resendAttempt];
                                    });
                                    startTimer();
                                  },
                                  child: Text(
                                    LocaleKeys.resend.tr(),
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: seconds == 0
                                          ? AppColors.Primary
                                          : AppColors.Disabled,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),

                                Spacer(),

                                Text(
                                  "${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}",
                                  style: AppTextStyle.txtStyle.copyWith(
                                    color: AppColors.Txt,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 80.h),
                            AppButton(
                                onPressed: otpController.text.length < 4 ? null : () {
                                  if (widget.type == VerificationType.email) {
                                  context.read<AuthCubit>().verifyCode(
                                    email: widget.value,
                                    otpCode: otpController.text,
                                    countryCode: widget.countryCode,
                                    phoneNumber: widget.phoneNumber,
                                  );
                                } else {
                                  context.read<AuthCubit>().verifyCode(
                                    countryCode: widget.countryCode,
                                    phoneNumber: widget.value,
                                    otpCode: otpController.text,
                                  );
                                }
                              },
                                txt: LocaleKeys.done_button.tr()
                            ),
                            SizedBox(height: 20.h),
                          ]
                        )
                      )
                    ),
                  )
                );
              }
            )
        )
    );
  }
}