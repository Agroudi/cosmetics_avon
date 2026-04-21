import 'package:cosmetics_avon/core/theme/colors.dart';
import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/app_button.dart';
import '../../../gen/locale_keys.g.dart';
import '../../auth/presentation/login_screen.dart';
import '../model/data_list.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (currentIndex != boardingList.length - 1)
            TextButton(
              onPressed: () {
                setState(() {
                  currentIndex = boardingList.length - 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child:
                  Text(
                      'Skip',
                      style: AppTextStyle.txtStyle.copyWith(
                        color: AppColors.Secondary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Segoe UI',
                  ),
                ),
              ),
            ),
        ],
      ),
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Column(
              key: ValueKey(currentIndex),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                boardingList[currentIndex].image,

                SizedBox(height: 67.h),

                Text(
                  boardingList[currentIndex].title,
                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.Secondary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Segoe UI',
                  ),
                ),

                SizedBox(height: 10.h),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    boardingList[currentIndex].description,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.txtStyle.copyWith(
                      color: AppColors.Secondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Segoe UI',
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                currentIndex == boardingList.length - 1
                    ? AppButton(
                  color: AppColors.Secondary,
                  txt: LocaleKeys.boarding_button.tr(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(),
                      ),
                    );
                  },
                )
                    : InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex++;
                    });
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(

                      color: AppColors.Secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 100.h),

              ],
            ),
          ),
        ),
    );
  }
}