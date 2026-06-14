import 'package:easy_localization/easy_localization.dart';
import '../../gen/locale_keys.g.dart';

class PhoneValidator {
  static String? validate(String? value, String countryCode) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.empty_number.tr();
    }

    final trimmed = value.trim();

    // Check if it contains only digits
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return LocaleKeys.only_numbers_error.tr();
    }

    switch (countryCode) {
      case '+20': // Egypt
        if (trimmed.length < 10) {
          return LocaleKeys.short_egy_number.tr();
        }
        if (trimmed.length > 10) {
          return LocaleKeys.long_egy_number.tr();
        }
        break;

      case '+966': // Saudi Arabia
        if (trimmed.length < 9) {
          return LocaleKeys.short_ksa_number.tr();
        }
        if (trimmed.length > 9) {
          return LocaleKeys.long_ksa_number.tr();
        }
        break;

      case '+971': // UAE
        if (trimmed.length < 9) {
          return LocaleKeys.short_uae_number.tr();
        }
        if (trimmed.length > 9) {
          return LocaleKeys.long_uae_number.tr();
        }
        break;

      case '+7': // Russia
        if (trimmed.length < 10) {
          return LocaleKeys.short_russia_number.tr();
        }
        if (trimmed.length > 10) {
          return LocaleKeys.long_russia_number.tr();
        }
        break;

      case '+33': // France
        if (trimmed.length < 9) {
          return LocaleKeys.short_france_number.tr();
        }
        if (trimmed.length > 9) {
          return LocaleKeys.long_france_number.tr();
        }
        break;

      case '+90': // Mexico / maxceco
        if (trimmed.length < 10) {
          return LocaleKeys.short_mexico_number.tr();
        }
        if (trimmed.length > 10) {
          return LocaleKeys.long_mexico_number.tr();
        }
        break;

      default:
        return LocaleKeys.unsupported_number.tr();
    }

    return null;
  }
}
