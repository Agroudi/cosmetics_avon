import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../gen/assets.gen.dart';
import '../data/models/cart_item_model.dart';
import 'quantity_controller.dart';

class CartItem extends StatelessWidget {

  final CartItemModel item;

  final VoidCallback onDelete;

  final VoidCallback onPlus;

  final VoidCallback onMinus;

  const CartItem({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onPlus,
    required this.onMinus,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Padding(
              padding: EdgeInsets.only(
                left: 6.w,
                top: 6.h,
              ),

              child: GestureDetector(
                onTap: onDelete,

                child: SvgPicture.asset(
                  Assets.icons.delete,
                ),
              ),
            ),

            SizedBox(width: 10.w),

            Container(
              width: 117.w,
              height: 113.h,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),

                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                ),
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
                        fontSize: 16.sp,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Text(
                      "${item.price.toStringAsFixed(0)} EGP",

                      style: AppTextStyle.txtStyle.copyWith(
                        color: AppColors.Secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),

                    const Spacer(),

                    Align(
                      alignment: Alignment.bottomRight,

                      child: QuantityController(
                        quantity: item.quantity,
                        onPlus: onPlus,
                        onMinus: onMinus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        Divider(
          color: AppColors.SearchBar,
        ),
      ],
    );
  }
}