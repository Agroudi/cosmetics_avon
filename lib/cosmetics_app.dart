import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';

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
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRoutes.login,
        )
    );
  }
}