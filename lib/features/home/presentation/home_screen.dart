import 'package:cosmetics_avon/features/cart/presentation/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../categories/presentation/categories_screen.dart';

import '../cubit/home_cubit.dart';
import 'home_body.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeCubit, HomeState>(

      builder: (context, state) {

        final cubit = context.watch<HomeCubit>();

        final screens = [

          const HomeBody(),

          const CategoriesScreen(),

          const CartScreen(),

          const Scaffold(
            body: Center(
              child: Text("Profile"),
            ),
          ),
        ];

        return Scaffold(

          body: IndexedStack(
            index: cubit.currentIndex,
            children: screens,
          ),

          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: cubit.currentIndex,
            onTap: cubit.changeBottomNav,
          ),
        );
      },
    );
  }
}