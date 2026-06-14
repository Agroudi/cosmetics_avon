import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/cubit/home_cubit.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    _controller = TextEditingController(text: cubit.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return TextField(
      controller: _controller,
      onChanged: (value) {
        cubit.searchProducts(value);
        setState(() {}); // Redraw suffix icon (clear/search)
      },
      decoration: InputDecoration(
        hintText: LocaleKeys.search_hint.tr(),
        hintStyle: AppTextStyle.txtStyle.copyWith(
          color: AppColors.SearchBar,
          fontSize: 14.sp,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  cubit.searchProducts('');
                  setState(() {});
                },
              )
            : Padding(
                padding: EdgeInsets.all(14.r),
                child: SvgPicture.asset(
                  Assets.icons.search,
                ),
              ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(
            color: AppColors.SearchBar,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(
            color: AppColors.SearchBar,
          ),
        ),
      ),
    );
  }
}