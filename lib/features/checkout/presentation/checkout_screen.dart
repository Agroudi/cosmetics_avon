import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/data/models/cart_item_model.dart';
import '../../home/cubit/home_cubit.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../data/services/checkout_api_service.dart';
import '../../../../core/widgets/app_loading.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _voucherController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Delivery info
  String _addressLabel = 'Home';
  String _streetAddress = '14 Porsaid St';
  String _city = 'Mansoura';

  // Payment method selection
  String _selectedPaymentMethod = 'Cash on Delivery'; // Or 'Credit Card'

  // Credit card info
  final _cardFormKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  bool _cardSaved = false;
  String _savedCardNumber = '';
  String _savedCardName = '';

  bool _isCalculated = true;
  final double _shippingFees = 50.0;

  String _getMapUrl() {
    final addressText = "$_streetAddress, $_city".trim();
    int hash = addressText.hashCode;

    // Base coordinates (Mansoura, Egypt)
    double baseLat = 31.0409;
    double baseLng = 31.3833;

    // Deterministic offset based on string hash
    double offsetLat = (hash.abs() % 200 - 100) / 1000.0; // range: -0.1 to 0.1 degrees
    double offsetLng = (hash.abs() % 300 - 150) / 1000.0; // range: -0.15 to 0.15 degrees

    double lat = baseLat + offsetLat;
    double lng = baseLng + offsetLng;

    return "https://static-maps.yandex.ru/1.x/?l=map&ll=$lng,$lat&z=14&size=200,120&lang=en_US";
  }

  @override
  void dispose() {
    _voucherController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  /// Formats card number input into groups of 4 separated by spaces.
  String _maskCardNumber(String raw) {
    final digits = raw.replaceAll(' ', '');
    if (digits.length <= 4) return '**** **** **** ${digits.padLeft(4, '*')}';
    return '**** **** **** ${digits.substring(digits.length - 4)}';
  }

  void _showCreditCardBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? DarkColors.cardBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
            left: 20.w,
            right: 20.w,
            top: 20.h,
          ),
          child: Form(
            key: _cardFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ───────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.credit_card_rounded, color: AppColors.Primary, size: 24.r),
                      SizedBox(width: 8.w),
                      Text(
                        LocaleKeys.credit_card.tr(),
                        style: AppTextStyle.txtStyle.copyWith(
                          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Enter your card details to continue',
                    style: AppTextStyle.txtStyle.copyWith(
                      color: isDark ? DarkColors.textSecondary : AppColors.Txt,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Card Number ──────────────────────────────────
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      _CardNumberInputFormatter(),
                    ],
                    style: TextStyle(
                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                      letterSpacing: 2,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                      hintText: '1234 5678 9012 3456',
                      hintStyle: TextStyle(color: isDark ? DarkColors.textSecondary.withOpacity(0.5) : AppColors.Txt.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.credit_card, color: AppColors.Primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: isDark ? DarkColors.divider : const Color(0xFF73B9BB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.Primary, width: 2),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Card number is required';
                      final digits = v.replaceAll(' ', '');
                      if (digits.length < 16) return 'Enter a valid 16-digit card number';
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // ── Cardholder Name ──────────────────────────────
                  TextFormField(
                    controller: _cardNameController,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                      hintText: 'Name on Card',
                      hintStyle: TextStyle(color: isDark ? DarkColors.textSecondary.withOpacity(0.5) : AppColors.Txt.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.Primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: isDark ? DarkColors.divider : const Color(0xFF73B9BB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.Primary, width: 2),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Cardholder name is required';
                      if (v.trim().length < 3) return 'Enter full name as on card';
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // ── Expiry + CVV ─────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cardExpiryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _ExpiryInputFormatter(),
                          ],
                          style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                          decoration: InputDecoration(
                            labelText: 'Expiry (MM/YY)',
                            labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                            hintText: 'MM/YY',
                            hintStyle: TextStyle(color: isDark ? DarkColors.textSecondary.withOpacity(0.5) : AppColors.Txt.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.calendar_month_outlined, color: AppColors.Primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: isDark ? DarkColors.divider : const Color(0xFF73B9BB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.Primary, width: 2),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final parts = v.split('/');
                            if (parts.length != 2) return 'Use MM/YY';
                            final month = int.tryParse(parts[0]);
                            final year = int.tryParse(parts[1]);
                            if (month == null || month < 1 || month > 12) return 'Invalid month';
                            if (year == null) return 'Invalid year';
                            final now = DateTime.now();
                            final expiry = DateTime(2000 + year, month + 1);
                            if (expiry.isBefore(now)) return 'Card expired';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextFormField(
                          controller: _cardCvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                            hintText: '•••',
                            hintStyle: TextStyle(color: isDark ? DarkColors.textSecondary.withOpacity(0.5) : AppColors.Txt.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.Primary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: isDark ? DarkColors.divider : const Color(0xFF73B9BB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.Primary, width: 2),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.length < 3) return 'Min 3 digits';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // ── Save Card Button ─────────────────────────────
                  ElevatedButton(
                    onPressed: () {
                      if (_cardFormKey.currentState!.validate()) {
                        setState(() {
                          _cardSaved = true;
                          _savedCardNumber = _cardNumberController.text;
                          _savedCardName = _cardNameController.text;
                        });
                        Navigator.pop(sheetCtx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Save Card',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditAddressBottomSheet(BuildContext context) {
    final labelController = TextEditingController(text: _addressLabel);
    final streetController = TextEditingController(text: _streetAddress);
    final cityController = TextEditingController(text: _city);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? DarkColors.cardBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          left: 20.w,
          right: 20.w,
          top: 20.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.delivery_to.tr(),
                style: AppTextStyle.txtStyle.copyWith(
                  color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: labelController,
                style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                decoration: InputDecoration(
                  labelText: LocaleKeys.address_label.tr(),
                  labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.address_required.tr() : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: streetController,
                style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                decoration: InputDecoration(
                  labelText: LocaleKeys.street_address.tr(),
                  labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.address_required.tr() : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: cityController,
                style: TextStyle(color: isDark ? DarkColors.textPrimary : AppColors.Secondary),
                decoration: InputDecoration(
                  labelText: LocaleKeys.city.tr(),
                  labelStyle: TextStyle(color: isDark ? DarkColors.textSecondary : AppColors.Txt),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.address_required.tr() : null,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _addressLabel = labelController.text;
                      _streetAddress = streetController.text;
                      _city = cityController.text;
                    });
                    Navigator.pop(bottomSheetContext);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  LocaleKeys.update_button.tr(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? DarkColors.cardBackground : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Column(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 64.r),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.order_placed.tr(),
              style: AppTextStyle.txtStyle.copyWith(
                color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        content: Text(
          LocaleKeys.order_placed_desc.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.txtStyle.copyWith(
            color: isDark ? DarkColors.textSecondary : AppColors.Txt,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // close the success dialog
                // Replace the checkout screen with order history so "Go to
                // orders" lands on the orders list (Back returns to the cart),
                // instead of just popping back to the cart.
                Navigator.pushReplacementNamed(context, AppRoutes.orderHistory);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.Primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                LocaleKeys.go_to_orders.tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final cartItems = ModalRoute.of(context)!.settings.arguments as List<CartItemModel>? ?? [];

    // Calculations
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item.price * item.quantity;
    }

    return BlocProvider(
      create: (context) => CheckoutCubit(CheckoutApiService()),
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is VoucherAppliedSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(LocaleKeys.voucher_applied.tr(args: ['${state.discountPercent}%'])),
              autoCloseDuration: const Duration(seconds: 3),
            );
          } else if (state is VoucherAppliedError) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(state.message),
              autoCloseDuration: const Duration(seconds: 3),
            );
          } else if (state is CheckoutSuccess) {
            // Success
            context.read<CartCubit>().getCart(showLoading: false); // Reload/clear cart on server
            _showOrderSuccessDialog(context);
          } else if (state is CheckoutError) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(state.errorMessage),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CheckoutCubit>();
          final double discount = subtotal * (cubit.discountPercent / 100);
          final double total = subtotal - discount + _shippingFees;

          return Scaffold(
            backgroundColor: isDark ? DarkColors.scaffoldBackground : const Color(0xFFE8ECEC),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          LocaleKeys.checkout_title.tr(),
                          style: AppTextStyle.txtStyle.copyWith(
                            color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
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
                                isDark ? DarkColors.textPrimary : AppColors.Secondary,
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
                        color: isDark ? DarkColors.cardBackground : const Color(0x1C29D3DA),
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
                                    LocaleKeys.delivery_to.tr(),
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  // Address Card
                                  Center(
                                    child: InkWell(
                                      onTap: () => _showEditAddressBottomSheet(context),
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Container(
                                        width: 309.w,
                                        height: 84.h,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(16.r),
                                          border: Border.all(
                                            color: isDark ? DarkColors.divider : const Color(0xFF73B9BB),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Map thumbnail
                                            Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.r),
                                                child: Image.network(
                                                  _getMapUrl(),
                                                  width: 97.w,
                                                  height: 60.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Assets.images.mansoura.image(
                                                      width: 97.w,
                                                      height: 60.h,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _addressLabel,
                                                    style: AppTextStyle.txtStyle.copyWith(
                                                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    '$_streetAddress, $_city',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyle.txtStyle.copyWith(
                                                      color: isDark ? DarkColors.textSecondary : AppColors.Txt,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(right: 12.w),
                                              child: Icon(
                                                Icons.edit_location_alt_outlined,
                                                color: AppColors.Primary,
                                                size: 20.r,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 24.h),

                                  // ─── Payment Method Section ──────────────────────
                                  Text(
                                    LocaleKeys.payment_method.tr(),
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  // Cash on Delivery Tile
                                  Center(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedPaymentMethod = 'Cash on Delivery'),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 309.w,
                                        height: 57.h,
                                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                                        decoration: BoxDecoration(
                                          color: _selectedPaymentMethod == 'Cash on Delivery'
                                              ? AppColors.Primary.withOpacity(0.08)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(25.r),
                                          border: Border.all(
                                            color: _selectedPaymentMethod == 'Cash on Delivery'
                                                ? AppColors.Primary
                                                : (isDark ? DarkColors.divider : const Color(0xFF73B9BB)),
                                            width: _selectedPaymentMethod == 'Cash on Delivery' ? 2.0 : 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.payments_outlined,
                                              color: _selectedPaymentMethod == 'Cash on Delivery'
                                                  ? AppColors.Primary
                                                  : (isDark ? DarkColors.textSecondary : AppColors.Secondary),
                                              size: 22.r,
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Text(
                                                LocaleKeys.cash_on_delivery.tr(),
                                                style: AppTextStyle.txtStyle.copyWith(
                                                  color: _selectedPaymentMethod == 'Cash on Delivery'
                                                      ? AppColors.Primary
                                                      : (isDark ? DarkColors.textPrimary : AppColors.Secondary),
                                                  fontWeight: _selectedPaymentMethod == 'Cash on Delivery'
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                            Radio<String>(
                                              value: 'Cash on Delivery',
                                              groupValue: _selectedPaymentMethod,
                                              activeColor: AppColors.Primary,
                                              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  // Credit Card Tile
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedPaymentMethod = 'Credit Card');
                                        _showCreditCardBottomSheet(context);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 309.w,
                                        height: _selectedPaymentMethod == 'Credit Card' && _cardSaved ? 72.h : 57.h,
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: _selectedPaymentMethod == 'Credit Card'
                                              ? AppColors.Primary.withOpacity(0.08)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(25.r),
                                          border: Border.all(
                                            color: _selectedPaymentMethod == 'Credit Card' && !_cardSaved
                                                ? Colors.orange
                                                : _selectedPaymentMethod == 'Credit Card'
                                                    ? AppColors.Primary
                                                    : (isDark ? DarkColors.divider : const Color(0xFF73B9BB)),
                                            width: _selectedPaymentMethod == 'Credit Card' ? 2.0 : 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.credit_card_outlined,
                                              color: _selectedPaymentMethod == 'Credit Card'
                                                  ? (_cardSaved ? AppColors.Primary : Colors.orange)
                                                  : (isDark ? DarkColors.textSecondary : AppColors.Secondary),
                                              size: 22.r,
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    LocaleKeys.credit_card.tr(),
                                                    style: AppTextStyle.txtStyle.copyWith(
                                                      color: _selectedPaymentMethod == 'Credit Card'
                                                          ? (_cardSaved ? AppColors.Primary : Colors.orange)
                                                          : (isDark ? DarkColors.textPrimary : AppColors.Secondary),
                                                      fontWeight: _selectedPaymentMethod == 'Credit Card'
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  if (_selectedPaymentMethod == 'Credit Card' && _cardSaved)
                                                    Text(
                                                      '${_maskCardNumber(_savedCardNumber)}  •  $_savedCardName',
                                                      style: AppTextStyle.txtStyle.copyWith(
                                                        color: isDark ? DarkColors.textSecondary : AppColors.Txt,
                                                        fontSize: 11.sp,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                  else if (_selectedPaymentMethod == 'Credit Card')
                                                    Text(
                                                      'Tap to add card details',
                                                      style: AppTextStyle.txtStyle.copyWith(
                                                        color: Colors.orange,
                                                        fontSize: 11.sp,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            if (_selectedPaymentMethod == 'Credit Card' && _cardSaved)
                                              GestureDetector(
                                                onTap: () => _showCreditCardBottomSheet(context),
                                                child: Icon(Icons.edit_outlined, color: AppColors.Primary, size: 18.r),
                                              )
                                            else
                                              Radio<String>(
                                                value: 'Credit Card',
                                                groupValue: _selectedPaymentMethod,
                                                activeColor: AppColors.Primary,
                                                onChanged: (val) {
                                                  setState(() => _selectedPaymentMethod = val!);
                                                  _showCreditCardBottomSheet(context);
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_selectedPaymentMethod == 'Credit Card' && !_cardSaved)
                                    Padding(
                                      padding: EdgeInsets.only(top: 6.h, left: 20.w),
                                      child: Text(
                                        '⚠ Card details required to place order',
                                        style: AppTextStyle.txtStyle.copyWith(
                                          color: Colors.orange,
                                          fontSize: 11.sp,
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
                                          color: isDark ? DarkColors.divider : const Color(0xFF73B9BB),
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
                                              isDark ? DarkColors.textSecondary : AppColors.Secondary,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: TextField(
                                              controller: _voucherController,
                                              style: AppTextStyle.txtStyle.copyWith(
                                                color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                                fontSize: 13.sp,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: LocaleKeys.add_voucher.tr(),
                                                hintStyle: AppTextStyle.txtStyle.copyWith(
                                                  color: isDark ? DarkColors.textSecondary : AppColors.Txt,
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
                                            onPressed: () {
                                              final homeCubit = context.read<HomeCubit>();
                                              cubit.applyVoucher(_voucherController.text, homeCubit.sliders);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.Primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 10.h,
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              LocaleKeys.apply.tr(),
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

                                  SizedBox(height: 24.h),

                                  // ─── Divider ─────────────────────────────────────
                                  _DashedDivider(
                                    color: isDark ? DarkColors.divider : AppColors.Txt.withOpacity(0.35),
                                  ),

                                  SizedBox(height: 24.h),

                                  // ─── Payment Summary ─────────────────────────────
                                  Text(
                                    LocaleKeys.review_payment.tr(),
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: isDark ? DarkColors.textSecondary : AppColors.Txt,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    LocaleKeys.payment_summary.tr(),
                                    style: AppTextStyle.txtStyle.copyWith(
                                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.sp,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  SizedBox(height: 20.h),

                                  // Subtotal Row
                                  _SummaryRow(
                                    label: LocaleKeys.subtotal.tr(),
                                    value: '${subtotal.toStringAsFixed(2)} ${LocaleKeys.cart_currency.tr()}',
                                    labelColor: isDark ? DarkColors.textSecondary : AppColors.Txt,
                                    valueColor: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                    labelWeight: FontWeight.w400,
                                    valueWeight: FontWeight.w600,
                                  ),
                                  SizedBox(height: 10.h),
                                  // Discount Row
                                  if (cubit.discountPercent > 0) ...[
                                    _SummaryRow(
                                      label: LocaleKeys.discount.tr(),
                                      value: '-${discount.toStringAsFixed(2)} ${LocaleKeys.cart_currency.tr()} (${cubit.discountPercent}%)',
                                      labelColor: Colors.green,
                                      valueColor: Colors.green,
                                      labelWeight: FontWeight.w500,
                                      valueWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                  _SummaryRow(
                                    label: LocaleKeys.shipping_fees.tr(),
                                    value: '${_shippingFees.toStringAsFixed(2)} ${LocaleKeys.cart_currency.tr()}',
                                    labelColor: isDark ? DarkColors.textSecondary : AppColors.Secondary,
                                    valueColor: isDark ? DarkColors.textSecondary : AppColors.Secondary,
                                    labelWeight: FontWeight.w600,
                                    valueWeight: FontWeight.w400,
                                    labelSize: 12.sp,
                                    valueSize: 12.sp,
                                  ),

                                  SizedBox(height: 20.h),

                                  Divider(
                                    color: isDark ? DarkColors.divider : const Color(0xFF73B9BB),
                                    thickness: 1,
                                    height: 1,
                                  ),

                                  SizedBox(height: 16.h),

                                  // Total Row
                                  _SummaryRow(
                                    label: LocaleKeys.total_vat.tr(),
                                    value: '${total.toStringAsFixed(2)} ${LocaleKeys.cart_currency.tr()}',
                                    labelColor: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                                    valueColor: isDark ? DarkColors.textPrimary : AppColors.Secondary,
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
                              child: state is CheckoutLoading
                                  ? const Center(child: LoadingWidget())
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_streetAddress.isEmpty || _city.isEmpty) {
                                          toastification.show(
                                            context: context,
                                            type: ToastificationType.warning,
                                            title: Text(LocaleKeys.address_required.tr()),
                                            autoCloseDuration: const Duration(seconds: 3),
                                          );
                                          return;
                                        }
                                        // Validate credit card info if selected
                                        if (_selectedPaymentMethod == 'Credit Card' && !_cardSaved) {
                                          toastification.show(
                                            context: context,
                                            type: ToastificationType.warning,
                                            title: const Text('Please add your card details'),
                                            autoCloseDuration: const Duration(seconds: 3),
                                          );
                                          _showCreditCardBottomSheet(context);
                                          return;
                                        }
                                        cubit.placeOrder(
                                          address: '$_streetAddress, $_city',
                                          paymentMethod: _selectedPaymentMethod == 'Cash on Delivery' ? 'cash' : 'credit_card',
                                          items: cartItems,
                                        );
                                      },
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
                                            LocaleKeys.order_btn.tr(),
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
        },
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

/// Formats card number digits into groups of 4: "1234 5678 9012 3456"
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats expiry input as MM/YY automatically
class _ExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

