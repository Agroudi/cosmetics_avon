import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECEC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'Checkout',
                    style: AppTextStyle.txtStyle.copyWith(
                      color: AppColors.Secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        Assets.icons.backButton,
                        width: 32.w,
                        height: 32.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.Secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Scrollable Body ───────────────────────────────────
            SizedBox(height: 14.h),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x1C29D3DA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),

                            // ─── Delivery Section ────────────────────────────
                            Text(
                              'Delivery to',
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Address Card
                            Center(
                              child: Container(
                                width: 309.w,
                                height: 84.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color(0xFF73B9BB),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Map thumbnail
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          5.r,
                                        ),
                                        child: Assets.images.mansoura.image(
                                          width: 97.w,
                                          height: 60.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15.h),
                                          Text(
                                            'Home',
                                            style: AppTextStyle.txtStyle
                                                .copyWith(
                                                  color: AppColors.Secondary,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.sp,
                                                ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            'Mansoura, 14 Porsaid St',
                                            style: AppTextStyle.txtStyle
                                                .copyWith(
                                                  color: AppColors.Txt,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.sp,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: SvgPicture.asset(
                                        Assets.icons.down,
                                        width: 6.w,
                                        height: 14.h,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.Primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 48.h),

                            // ─── Payment Method Section ──────────────────────
                            Text(
                              'Payment Method',
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 18.h),

                            // Card Row
                            Center(
                              child: Container(
                                width: 309.w,
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(25.r),
                                  border: Border.all(
                                    color: const Color(0xFF73B9BB),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Mastercard icon
                                    SizedBox(
                                      width: 40.w,
                                      height: 28.h,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            child: Container(
                                              width: 24.w,
                                              height: 24.h,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFEB001B),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              width: 24.w,
                                              height: 24.h,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFFF79E1B,
                                                ).withOpacity(0.9),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        '**** **** **** 0256',
                                        style: AppTextStyle.txtStyle.copyWith(
                                          color: AppColors.Secondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      Assets.icons.down,
                                      width: 6.w,
                                      height: 14.h,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.Primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Voucher Row
                            Center(
                              child: Container(
                                width: 309.w,
                                height: 57.h,
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(25.r),
                                  border: Border.all(
                                    color: const Color(0xFF73B9BB),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.icons.voucher,
                                      width: 22.w,
                                      height: 22.h,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.Secondary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: TextField(
                                        controller: _voucherController,
                                        style: AppTextStyle.txtStyle.copyWith(
                                          color: AppColors.Secondary,
                                          fontSize: 13.sp,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Add vaucher',
                                          hintStyle: AppTextStyle.txtStyle
                                              .copyWith(
                                                color: AppColors.Txt,
                                                fontSize: 13.sp,
                                              ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.Primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                          vertical: 10.h,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Apply',
                                        style: AppTextStyle.txtStyle.copyWith(
                                          color: const Color(0xFFFFF5EE),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // ─── Divider ─────────────────────────────────────
                            _DashedDivider(
                              color: AppColors.Txt.withOpacity(0.35),
                            ),

                            SizedBox(height: 32.h),

                            // ─── Payment Summary ─────────────────────────────
                            Text(
                              '- REVIEW PAYMENT',
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Txt,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'PAYMENT SUMMARY',
                              style: AppTextStyle.txtStyle.copyWith(
                                color: AppColors.Secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 22.sp,
                                letterSpacing: 0.5,
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Subtotal Row
                            _SummaryRow(
                              label: 'Subtotal',
                              value: '16.100 EGP',
                              labelColor: AppColors.Txt,
                              valueColor: AppColors.Secondary,
                              labelWeight: FontWeight.w400,
                              valueWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 10.h),
                            _SummaryRow(
                              label: 'SHIPPING FEES',
                              value: 'TO BE CALCULATED',
                              labelColor: AppColors.Secondary,
                              valueColor: AppColors.Txt,
                              labelWeight: FontWeight.w600,
                              valueWeight: FontWeight.w400,
                              labelSize: 11.sp,
                              valueSize: 11.sp,
                            ),

                            SizedBox(height: 20.h),

                            Divider(
                              color: const Color(0xFF73B9BB),
                              thickness: 1,
                              height: 1,
                            ),

                            SizedBox(height: 16.h),

                            // Total Row
                            _SummaryRow(
                              label: 'TOTAL + VAT',
                              value: '16.100 EGP',
                              labelColor: AppColors.Secondary,
                              valueColor: AppColors.Secondary,
                              labelWeight: FontWeight.w500,
                              valueWeight: FontWeight.w700,
                              labelSize: 12.sp,
                              valueSize: 15.sp,
                            ),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),

                    // ─── Order Button ──────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      child: SizedBox(
                        width: 268.w,
                        height: 60.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.Primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.icons.order,
                                width: 22.w,
                                height: 22.h,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFFFF5EE),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'ORDER',
                                style: AppTextStyle.txtStyle.copyWith(
                                  color: const Color(0xFFFFF5EE),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final FontWeight labelWeight;
  final FontWeight valueWeight;
  final double? labelSize;
  final double? valueSize;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    required this.labelWeight,
    required this.valueWeight,
    this.labelSize,
    this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.txtStyle.copyWith(
            color: labelColor,
            fontWeight: labelWeight,
            fontSize: labelSize ?? 14.sp,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.txtStyle.copyWith(
            color: valueColor,
            fontWeight: valueWeight,
            fontSize: valueSize ?? 14.sp,
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const _DashedDivider({
    required this.color,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
