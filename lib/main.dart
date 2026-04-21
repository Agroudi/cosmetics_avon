import 'package:cosmetics_avon/cosmetics_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/services/dio_helper.dart';

void main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await Future.wait([
    ScreenUtil.ensureScreenSize(),
    EasyLocalization.ensureInitialized()
  ]);
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: CosmeticsApp()
    ),
  );
}