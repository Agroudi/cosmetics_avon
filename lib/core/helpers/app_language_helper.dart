import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

extension LangHelper on BuildContext {

  bool get isArabic => locale.languageCode == 'ar';
}