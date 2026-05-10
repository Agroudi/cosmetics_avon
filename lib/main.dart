import 'package:cosmetics_avon/cosmetics_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/services/dio_helper.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/cart/data/repo/cart_repo_impl.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/home/data/repo/home_repo_impl.dart';
import 'features/home/data/services/home_api_service.dart';
import 'features/cart/data/services/cart_api_service.dart';

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
        child: MultiBlocProvider(
            providers: [

              BlocProvider(
                create: (_) => CartCubit(
                  CartRepoImpl(
                    CartApiService(),
                  ),
                )..getCart(),
              ),

              BlocProvider(
                create: (_) => HomeCubit(
                  HomeRepoImpl(
                    HomeApiService(),
                  ),
                )..getHomeData(),
              ),
            ],
            child: CosmeticsApp()
    ),
  )
  );
}