import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../home/cubit/home_cubit.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final homeCubit = context.read<HomeCubit>();

    // Get unique voucher coupon codes from sliders
    final sliders = homeCubit.sliders;
    final vouchers = sliders.where((s) => s.couponCode.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.vouchers_title.tr(),
          style: AppTextStyle.txtStyle.copyWith(
            color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
            size: 20.r,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: vouchers.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 64.r,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        LocaleKeys.no_vouchers.tr(),
                        style: AppTextStyle.txtStyle.copyWith(
                          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        LocaleKeys.no_vouchers_desc.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.txtStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: vouchers.length,
                itemBuilder: (context, index) {
                  final voucher = vouchers[index];
                  final title = isArabic ? voucher.title1Ar : voucher.title1En;

                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: isDark ? DarkColors.cardBackground : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.15),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // Left side discount indicator
                          Container(
                            width: 100.w,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: AppColors.Primary.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                bottomLeft: Radius.circular(16.r),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.discount_off.tr(args: [voucher.discountPercent.toString()]),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.txtStyle.copyWith(
                                    color: AppColors.Primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Vertical divider dots (ticket look)
                          CustomPaint(
                            size: Size(1, double.infinity),
                            painter: DottedLinePainter(
                              color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          // Right side voucher details
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(16.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: isDark ? DarkColors.surfaceBackground : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.2),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Text(
                                      voucher.couponCode,
                                      style: TextStyle(
                                        fontFamily: 'Courier',
                                        color: AppColors.Primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleKeys.valid_coupon.tr(),
                                        style: AppTextStyle.txtStyle.copyWith(
                                          color: Colors.green,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: voucher.couponCode));
                                          toastification.show(
                                            context: context,
                                            type: ToastificationType.success,
                                            title: Text(LocaleKeys.code_copied.tr()),
                                            autoCloseDuration: const Duration(seconds: 2),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.copy_rounded,
                                              size: 14.r,
                                              color: AppColors.Primary,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              LocaleKeys.copy_code.tr(),
                                              style: AppTextStyle.txtStyle.copyWith(
                                                color: AppColors.Primary,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
