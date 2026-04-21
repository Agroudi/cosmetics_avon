import 'package:cosmetics_avon/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/theme/colors.dart';
import 'app_form_field.dart';

class AppPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String countryCode)? onCountryChanged;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.onCountryChanged,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  String countryCode = '+20';

  final List<String> countryCodes = ['+20', '+966', '+971', '+1'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Country Code
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 2.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.Border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: countryCode,
            underline: SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.Border),
            items: countryCodes.map((code) {
              return DropdownMenuItem(
                value: code,
                child: Text(
                  code,
                  style: TextStyle(color: AppColors.Primary),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                countryCode = value!;
              });

              if (widget.onCountryChanged != null) {
                widget.onCountryChanged!(countryCode);
              }
            },
          ),
        ),

        SizedBox(width: 6.w),

        Expanded(
          child: AppFormField(
            label: LocaleKeys.phone_label.tr(),
            controller: widget.controller,
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}