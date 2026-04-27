import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../cubit/auth_cubit.dart';
import '../data/repo/auth_repo_impl.dart';
import '../data/services/auth_api_services.dart';

enum VerificationType {
  email,
  phone,
}

class VerificationScreen extends StatefulWidget {
  final VerificationType type;
  final String value;
  final String? countryCode;

  const VerificationScreen({super.key, required this.type, required this.value, required this.countryCode});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  int seconds = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (seconds == 0) return false;

      setState(() {
        seconds--;
      });

      return true;
    });
  }

  @override
  Widget build(BuildContext context)

  {
    return BlocProvider(
        create: (_) => AuthCubit(AuthRepoImpl(AuthApiService())),
        child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is VerifySuccess) {
                Navigator.pushNamed(context, AppRoutes.createPassword);
              }

              if (state is VerifyError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
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
                SizedBox(height: 76.h),
                MaterialPinField(
                  length: 4,
                  onCompleted: (pin) {
                    if (widget.type == VerificationType.email) {
                      context.read<AuthCubit>().verifyCode(
                        email: widget.value,
                        otpCode: pin,
                      );
                    } else {
                      if (widget.type == VerificationType.phone) {
                        context.read<AuthCubit>().verifyCode(
                          countryCode: widget.countryCode,
                          phoneNumber: widget.value,
                          otpCode: pin,
                        );
                      } else {
                        context.read<AuthCubit>().verifyCode(
                          email: widget.value,
                          otpCode: pin,
                        );
                      }
                    }
                  },
                  onChanged: (value) => debugPrint('Changed: $value'),
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

                          context.read<AuthCubit>().resendOtp(
                            countryCode: widget.countryCode!,
                            phoneNumber: widget.value,
                          );

                          setState(() {
                            seconds = 30;
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
                      "00:${seconds.toString().padLeft(2, '0')}",
                      style: AppTextStyle.txtStyle.copyWith(
                        color: AppColors.Txt,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                AppButton(
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
                        );
                      }
                      setState(() => seconds = 30);
                      startTimer();
                    },
                    txt: LocaleKeys.done_button.tr()
                ),
                Spacer()
              ]
            )
          )
        )
      )
      )
        )
    );
  }
}