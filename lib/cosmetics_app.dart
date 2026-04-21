import 'package:cosmetics_avon/features/auth/presentation/forgot_password_screen.dart';
import 'package:cosmetics_avon/features/auth/presentation/register_screen.dart';
import 'package:cosmetics_avon/features/auth/presentation/verification_screen.dart';
import 'package:cosmetics_avon/features/boarding/presentation/boarding_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/auth/presentation/create_password_screen.dart';

class CosmeticsApp extends StatelessWidget
{
  const CosmeticsApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return ScreenUtilInit
      (
        designSize: const Size(390, 844),
        splitScreenMode: true,
        minTextAdapt: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: BoardingScreen(),
        )
    );
  }
}