import 'package:cosmetics_avon/features/cart/cubit/cart_cubit.dart';
import 'package:cosmetics_avon/features/cart/presentation/cart_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../gen/locale_keys.g.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../profile/presentation/profile_screen.dart';

import '../cubit/home_cubit.dart';
import 'home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.watch<HomeCubit>();

        final screens = [
          const HomeBody(),

          const CategoriesScreen(),

          const CartScreen(),

          const ProfileScreen(),
        ];

        return MultiBlocListener(
          listeners: [
            BlocListener<CartCubit, CartState>(
              listener: (context, state) {
                if (state is CartUnauthorizedError) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    title: Text(LocaleKeys.session_expired.tr()),
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                } else if (state is CartItemUpdating || state is CartLoading) {
                  AppLoading.show(context);
                } else if (state is CartItemAdded ||
                    state is CartItemRemoved ||
                    state is CartLoaded ||
                    state is CartError ||
                    state is CartSuccess) {
                  AppLoading.hide(context);
                }
              },
            ),
          ],
          child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
              if (context.read<HomeCubit>().state is HomeLoading) return; // Ignore back during loading

              final cubit = context.read<HomeCubit>();
              if (cubit.currentIndex != 0) {
                cubit.changeBottomNav(0);
                return;
              }

              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                toastification.show(
                  context: context,
                  type: ToastificationType.info,
                  title: Text(LocaleKeys.press_back_to_exit.tr()),
                  autoCloseDuration: const Duration(seconds: 2),
                );
              } else {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              body: IndexedStack(index: cubit.currentIndex, children: screens),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: cubit.currentIndex,
                onTap: cubit.changeBottomNav,
              ),
            ),
          ),
        );
      },
    );
  }
}
