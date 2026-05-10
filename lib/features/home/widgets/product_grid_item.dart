import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../cart/cubit/cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/assets.gen.dart';
import '../data/models/product_model.dart';

class ProductGridItem extends StatelessWidget {

  final ProductModel product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 176.w,
      height: 273.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(.08),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 11, left: 8, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: Image.network(
                    product.imageUrl,
                    height: 169.h,
                    width: 181.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                top: 14.h,
                right: 15.w,

                child: GestureDetector(

                  onTap: () {

                    debugPrint("ADD CLICKED");

                    context.read<CartCubit>().addToCart(
                      product,
                    );
                  },

                  child: Container(
                    width: 32.w,
                    height: 32.h,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),

                    child: Center(
                      child: SvgPicture.asset(
                        Assets.icons.addCart,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  product.nameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.Secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 11.h),

                Text(
                  "\$${product.price}",
                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.GridPrices,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}