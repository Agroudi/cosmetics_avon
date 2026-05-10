import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/home_search_bar.dart';
import '../../home/cubit/home_cubit.dart';
import '../widgets/categories_item.dart';

class CategoriesScreen extends StatelessWidget {

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {

        final cubit = context.watch<HomeCubit>();

        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Text(state.message),
          );
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                SizedBox(height: 20.h),

                Center(
                  child: Text(
                    "Categories",

                    style: AppTextStyle.txtStyle.copyWith(
                      color: AppColors.Secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                const HomeSearchBar(),

                SizedBox(height: 32.h),

                Expanded(
                  child: ListView.separated(

                    itemCount: cubit.categories.length,

                    separatorBuilder: (_, __) =>
                        SizedBox(height: 0.h),

                    itemBuilder: (context, index) {

                      return CategoryItem(
                        category: cubit.categories[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}