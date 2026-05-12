import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../data/models/cart_item_model.dart';
import 'quantity_controller.dart';

class CartItem extends StatelessWidget {
  final CartItemModel item;

  final VoidCallback onDelete;

  final VoidCallback onPlus;

  final VoidCallback onMinus;

  final bool isMaxStock;

  const CartItem({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onPlus,
    required this.onMinus,
    this.isMaxStock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 102.w,
                height: 102.h,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),

                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),

                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: 102.w,
                        height: 102.h,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onDelete,
                      child: Padding(
                        padding: EdgeInsets.only(left: 6.w, top: 6.h, right: 12.w, bottom: 12.h),
                        child: SvgPicture.asset(Assets.icons.delete),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: SizedBox(
                  height: 113.h,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        item.productNameEn,

                        style: AppTextStyle.txtStyle.copyWith(
                          color: AppColors.Secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      Text(
                        "${item.price.toStringAsFixed(0)} ${LocaleKeys.cart_currency.tr()}",

                        style: AppTextStyle.txtStyle.copyWith(
                          color: AppColors.Secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),

                      const Spacer(),

                      Align(
                        alignment: Alignment.bottomRight,

                        child: QuantityController(
                          quantity: item.quantity,
                          onPlus: onPlus,
                          onMinus: onMinus,
                          isMaxStock: isMaxStock,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Divider(color: AppColors.SearchBar),
        ],
      ),
    );
  }
}
