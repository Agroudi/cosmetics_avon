import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/models/slider_model.dart';

class HomeBanner extends StatelessWidget {

  final SliderModel slider;

  const HomeBanner({
    super.key,
    required this.slider,
  });

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),

      child: Image.network(
        slider.imageUrl,
        width: 364.w,
        height: 320.h,
        fit: BoxFit.cover,
      ),
    );
  }
}