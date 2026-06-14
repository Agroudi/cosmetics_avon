import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../home/data/models/product_model.dart';
import '../../home/widgets/product_grid_item.dart';

class CategoryProductsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryTitle;
  final List<ProductModel> products;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Filter products locally by categoryId
    final filtered = products.where((p) => p.categoryId == categoryId).toList();

    // Cart state (loading overlay + add/error toasts) is handled globally by
    // the always-mounted HomeScreen/HomeBody listeners. Adding a listener here
    // too would fire those toasts twice for a single add, so this screen just
    // renders the product grid.
    return Scaffold(
        appBar: AppBar(
        title: Text(
          categoryTitle,
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
        child: filtered.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64.r,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      LocaleKeys.no_results_found.tr(), // or empty products translation
                      style: AppTextStyle.txtStyle.copyWith(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(13.r),
                child: GridView.builder(
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 176 / 273,
                  ),
                  itemBuilder: (context, index) {
                    return ProductGridItem(
                      product: filtered[index],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
