import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_style.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/locale_keys.g.dart';
import '../../auth/widgets/dialog.dart';
import '../../categories/data/models/category_model.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/data/models/cart_item_model.dart';
import '../cubit/home_cubit.dart';
import '../data/models/product_model.dart';

/// Shared element tag so the grid thumbnail flies into the details hero.
String productHeroTag(int productId) => 'product-image-$productId';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductModel get product => widget.product;

  /// Cart add/remove/error toasts and the loading overlay are emitted globally
  /// by the always-mounted HomeBody / HomeScreen / CartScreen listeners, so we
  /// only raise the imperative low/out-of-stock hints here to avoid duplicates.
  CartItemModel? _cartItemFor(CartCubit cubit) {
    for (final item in cubit.cartItems) {
      if (item.productId == product.id) return item;
    }
    return null;
  }

  CategoryModel? _categoryFor(HomeCubit cubit) {
    for (final category in cubit.categories) {
      if (category.id == product.categoryId) return category;
    }
    return null;
  }

  void _infoToast(String message) {
    AppToast.show(
      context,
      type: ToastificationType.info,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  void _successToast(String message) {
    AppToast.show(
      context,
      type: ToastificationType.success,
      title: Text(message),
    );
  }

  void _onAddToCart() {
    if (product.stock <= 0) {
      _infoToast(LocaleKeys.out_of_stock_toast.tr());
      return;
    }
    // The "added to cart" toast is raised globally on CartItemAdded.
    context.read<CartCubit>().addToCart(product);
    final remaining = product.stock - 1;
    if (remaining == 1 || remaining == 2) {
      _infoToast(LocaleKeys.low_stock_toast.tr(args: [remaining.toString()]));
    }
  }

  void _onIncrease(CartItemModel item) {
    if (item.quantity >= product.stock) {
      _infoToast(LocaleKeys.out_of_stock_toast.tr());
      return;
    }
    context.read<CartCubit>().increaseQuantity(item);
    final remaining = product.stock - (item.quantity + 1);
    if (remaining == 1 || remaining == 2) {
      _infoToast(LocaleKeys.low_stock_toast.tr(args: [remaining.toString()]));
    } else {
      _successToast(LocaleKeys.cart_updated.tr());
    }
  }

  void _onDecrease(CartItemModel item) {
    context.read<CartCubit>().decreaseQuantity(item);
    _successToast(LocaleKeys.cart_updated.tr());
  }

  void _confirmRemove(CartCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => SharedDialog(
        title: LocaleKeys.remove_item_title.tr(),
        description: LocaleKeys.remove_item_desc.tr(),
        buttonText: LocaleKeys.remove.tr(),
        onPressed: () {
          Navigator.pop(context);
          cubit.removeItem(product.id);
        },
        secondButtonText: LocaleKeys.cancel.tr(),
        onSecondPressed: () => Navigator.pop(context),
        secondButtonColor: AppColors.Txt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';

    final name = isArabic ? product.nameAr : product.nameEn;

    // Prefer the current language; fall back to the other language, then to a
    // localized placeholder so the section never renders blank.
    final primaryDesc =
        (isArabic ? product.descriptionAr : product.descriptionEn).trim();
    final secondaryDesc =
        (isArabic ? product.descriptionEn : product.descriptionAr).trim();
    final description = primaryDesc.isNotEmpty
        ? primaryDesc
        : (secondaryDesc.isNotEmpty
            ? secondaryDesc
            : LocaleKeys.no_description.tr());

    final category = _categoryFor(context.read<HomeCubit>());
    final categoryName =
        category == null ? null : (isArabic ? category.titleAr : category.titleEn);

    return Scaffold(
      backgroundColor:
          isDark ? DarkColors.scaffoldBackground : Colors.white,
      body: Column(
        children: [
          _ImageHeader(product: product),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 32),
                  child: child,
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoryName != null) ...[
                      _CategoryChip(label: categoryName),
                      SizedBox(height: 16.h),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: AppTextStyle.txtStyle.copyWith(
                              color: isDark
                                  ? DarkColors.textPrimary
                                  : AppColors.Secondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 22.sp,
                              height: 1.3,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        _StockBadge(inStock: product.stock > 0),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "${product.price} ${LocaleKeys.product_currency.tr()}",
                      style: AppTextStyle.txtStyle.copyWith(
                        color: AppColors.Primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      LocaleKeys.product_description.tr(),
                      style: AppTextStyle.txtStyle.copyWith(
                        color: isDark
                            ? DarkColors.textPrimary
                            : AppColors.Secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      description,
                      style: AppTextStyle.txtStyle.copyWith(
                        color: isDark
                            ? DarkColors.textSecondary
                            : AppColors.Txt,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActionBar(
        product: product,
        onAdd: _onAddToCart,
        onIncrease: _onIncrease,
        onDecrease: _onDecrease,
        onRemove: _confirmRemove,
        cartItemFor: _cartItemFor,
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  final ProductModel product;

  const _ImageHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;

    return SizedBox(
      height: 360.h,
      width: double.infinity,
      child: Stack(
        children: [
          Hero(
            tag: productHeroTag(product.id),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 360.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: Colors.grey.withOpacity(.15),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 64.r,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Scrim so the back button stays legible over bright images.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.28),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 8.w,
            child: SafeArea(
              child: Material(
                color: Colors.white.withOpacity(.9),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.maybePop(context),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Icon(
                      isRtl
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      size: 18.r,
                      color: AppColors.Secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.Primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: AppTextStyle.txtStyle.copyWith(
          color: AppColors.Primary,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final bool inStock;

  const _StockBadge({required this.inStock});

  @override
  Widget build(BuildContext context) {
    final color = inStock ? const Color(0xFF2E9E5B) : AppColors.Error;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            (inStock ? LocaleKeys.in_stock : LocaleKeys.out_of_stock).tr(),
            style: AppTextStyle.txtStyle.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdd;
  final void Function(CartItemModel item) onIncrease;
  final void Function(CartItemModel item) onDecrease;
  final void Function(CartCubit cubit) onRemove;
  final CartItemModel? Function(CartCubit cubit) cartItemFor;

  const _BottomActionBar({
    required this.product,
    required this.onAdd,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.cartItemFor,
  });

  @override
  Widget build(BuildContext context) {
    // No background/shadow: the controls sit directly on the page so the bar
    // reads as part of the screen rather than a detached panel.
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final cubit = context.read<CartCubit>();
            final item = cartItemFor(cubit);
            final quantity = item?.quantity ?? 0;
            final inCart = quantity > 0 && item != null;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: inCart
                  ? _InCartControls(
                      key: const ValueKey('in-cart'),
                      quantity: quantity,
                      isMaxStock: quantity >= product.stock,
                      onIncrease: () => onIncrease(item),
                      onDecrease: () => onDecrease(item),
                      onRemove: () => onRemove(cubit),
                    )
                  : _AddToCartButton(
                      key: const ValueKey('add'),
                      enabled: product.stock > 0,
                      onTap: onAdd,
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _AddToCartButton({super.key, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.Primary,
          disabledBackgroundColor: AppColors.Disabled.withOpacity(.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.addCart,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              LocaleKeys.add_to_cart.tr(),
              style: AppTextStyle.txtStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InCartControls extends StatelessWidget {
  final int quantity;
  final bool isMaxStock;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _InCartControls({
    super.key,
    required this.quantity,
    required this.isMaxStock,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: Row(
        children: [
          // Same cart trash icon, in a soft circular button.
          Material(
            color: AppColors.Error.withOpacity(.1),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: SizedBox(
                width: 60.h,
                height: 60.h,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.delete,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          // Primary stepper pill with white circular +/- buttons.
          Expanded(
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: AppColors.Primary,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    color: AppColors.Primary.withOpacity(.3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StepperButton(
                    icon: Icons.remove_rounded,
                    enabled: quantity > 1,
                    onTap: onDecrease,
                  ),
                  Text(
                    quantity.toString(),
                    style: AppTextStyle.txtStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  _StepperButton(
                    icon: Icons.add_rounded,
                    enabled: !isMaxStock,
                    onTap: onIncrease,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(enabled ? 1 : .45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(7.r),
          child: Icon(
            icon,
            color: AppColors.Primary,
            size: 22.r,
          ),
        ),
      ),
    );
  }
}
