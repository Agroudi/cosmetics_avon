import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void> navigate() async {
    final prefs = await SharedPreferences.getInstance();

    bool isFirstTime = prefs.getBool('is_first_time') ?? true;
    String? token = prefs.getString('token');

    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    if (isFirstTime) {
      await prefs.setBool('is_first_time', false);

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.boarding,
        (route) => false,
      );
    } else if (token != null && token.isNotEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.info,
        title: Text(LocaleKeys.logging_in.tr()),
        autoCloseDuration: const Duration(seconds: 2),
      );

      AppLoading.show(context);

      await Future.delayed(const Duration(seconds: 2));

      AppLoading.hide(context);

      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: Text(LocaleKeys.logged_in_successfully.tr()),
        autoCloseDuration: const Duration(seconds: 3),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                      Assets.icons.splashLogo,
                      width: 200.w,
                      height: 200.h,
                    )
                    .animate()
                    .scale(
                      duration: 1200.ms,
                      curve: Curves.easeOutBack,
                      begin: const Offset(.4, .4),
                      end: const Offset(1, 1),
                    )
                    .fadeIn(duration: 900.ms)
                    .shimmer(duration: 1800.ms, delay: 1200.ms),

                SizedBox(height: 22.h),

                Text(
                      "AVON",
                      style: AppTextStyle.txtStyle.copyWith(
                        color: AppColors.Secondary,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 14,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1500.ms, duration: 900.ms)
                    .moveY(
                      begin: 20,
                      end: 0,
                      delay: 1500.ms,
                      duration: 900.ms,
                      curve: Curves.easeOut,
                    ),

                SizedBox(height: 10.h),

                Text(
                  "COSMETICS",
                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.Secondary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 7,
                  ),
                ).animate().fadeIn(delay: 2200.ms, duration: 800.ms),

                SizedBox(height: 8.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "the company for women",
                      style: AppTextStyle.txtStyle.copyWith(
                        color: AppColors.Secondary.withOpacity(.7),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ).animate().fadeIn(delay: 2800.ms, duration: 800.ms),

                    SizedBox(height: 2.h),

                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 1200),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.easeOut,
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(-10 * (1 - value), 0),
                              child: child,
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          Assets.icons.swoosh,
                          width: 20.w,
                          height: 6.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
