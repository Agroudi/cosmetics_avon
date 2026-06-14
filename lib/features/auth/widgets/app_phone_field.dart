import 'package:cosmetics_avon/core/theme/text_style.dart';
import 'package:cosmetics_avon/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';

class AppPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String countryCode)? onCountryChanged;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.onCountryChanged,
    required this.validator,
    this.onChanged,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  String countryCode = '+20';
  final List<String> countryCodes = ['+20', '+966', '+971', '+7', '+33', '+90'];

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: (_) {
        if (widget.validator != null) {
          return widget.validator!(widget.controller.text);
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 9.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasError
                            ? AppColors.Error
                            : (isDark ? DarkColors.textSecondary : AppColors.Border),
                        width: hasError ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: countryCode,
                        dropdownColor: isDark ? DarkColors.cardBackground : Colors.white,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: hasError
                              ? AppColors.Error
                              : (isDark ? DarkColors.textSecondary : AppColors.Border),
                        ),
                        items: countryCodes.map((code) {
                          return DropdownMenuItem(
                            value: code,
                            child: Text(
                              code,
                              style: AppTextStyle.txtStyle.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              countryCode = value;
                            });
                            widget.onCountryChanged?.call(countryCode);
                            state.didChange(widget.controller.text);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      cursorColor: AppColors.Primary,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (val) {
                        state.didChange(val);
                        widget.onChanged?.call(val);
                      },
                      style: AppTextStyle.txtStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                      ),
                      decoration: InputDecoration(
                        labelText: LocaleKeys.phone_label.tr(),
                        labelStyle: AppTextStyle.txtStyle.copyWith(
                          color: hasError ? AppColors.Error : AppColors.Txt,
                        ),
                        // Force no error text in input decoration
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: hasError
                                ? AppColors.Error
                                : (isDark ? DarkColors.textSecondary : AppColors.Txt),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: hasError ? AppColors.Error : AppColors.Primary,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: AppColors.Error,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: AppColors.Error,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (hasError && state.errorText != null)
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 8.w, right: 8.w),
                child: Text(
                  state.errorText!,
                  style: AppTextStyle.txtStyle.copyWith(
                    color: AppColors.Error,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}