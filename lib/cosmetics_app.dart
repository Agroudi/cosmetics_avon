import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'core/cubit/theme_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';

class CosmeticsApp extends StatelessWidget {
  const CosmeticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          splitScreenMode: true,
          minTextAdapt: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: context.read<ThemeCubit>().themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.splash,
            // Hosts toasts in a top-level overlay above the navigator so they
            // stay visible over pushed routes (e.g. product details) and the
            // loading dialog, instead of rendering beneath them.
            builder: (context, child) =>
                ToastificationWrapper(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}