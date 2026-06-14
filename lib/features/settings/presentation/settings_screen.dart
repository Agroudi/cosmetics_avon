import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../core/cubit/theme_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
    if (mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: Text(
          value
              ? LocaleKeys.notifications_enabled.tr()
              : LocaleKeys.notifications_disabled.tr(),
        ),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear everything except dark mode and notifications
    final isDark = prefs.getBool('dark_mode') ?? false;
    final notifications = prefs.getBool('notifications_enabled') ?? true;
    await prefs.clear();
    await prefs.setBool('dark_mode', isDark);
    await prefs.setBool('notifications_enabled', notifications);

    if (mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: Text(LocaleKeys.cache_cleared.tr()),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final themeCubit = context.watch<ThemeCubit>();

    final preferencesTitle = LocaleKeys.preferences.tr();
    final systemTitle = LocaleKeys.system.tr();
    final clearConfirmTitle = LocaleKeys.clear_cache_confirm.tr();
    final clearTitle = LocaleKeys.clear.tr();
    final aboutUsTitle = LocaleKeys.about_us.tr();
    final versionTitle = LocaleKeys.version.tr();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.settings.tr(),
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
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            _buildSectionHeader(preferencesTitle, isDark),
            SizedBox(height: 8.h),
            _buildSettingCard(
              children: [
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: LocaleKeys.dark_mode.tr(),
                  value: themeCubit.state.isDarkMode,
                  onChanged: (val) {
                    context.read<ThemeCubit>().toggleDarkMode();
                  },
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildSwitchTile(
                  icon: Icons.notifications_none_outlined,
                  title: LocaleKeys.notifications.tr(),
                  value: _notificationsEnabled,
                  onChanged: _toggleNotifications,
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildLanguageTile(isDark),
              ],
              isDark: isDark,
            ),
            SizedBox(height: 24.h),
            _buildSectionHeader(systemTitle, isDark),
            SizedBox(height: 8.h),
            _buildSettingCard(
              children: [
                _buildActionTile(
                  icon: Icons.delete_outline_rounded,
                  title: LocaleKeys.clear_cache.tr(),
                  subtitle: LocaleKeys.clear_cache_desc.tr(),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(LocaleKeys.clear_cache.tr()),
                        content: Text(clearConfirmTitle),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(LocaleKeys.cancel.tr()),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _clearCache();
                            },
                            child: Text(
                              clearTitle,
                              style: TextStyle(color: AppColors.Error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  isDark: isDark,
                  iconColor: AppColors.Error,
                ),
                _buildDivider(isDark),
                _buildActionTile(
                  icon: Icons.info_outline_rounded,
                  title: aboutUsTitle,
                  subtitle: '$versionTitle 1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Cosmetics Avon',
                      applicationVersion: '1.0.0',
                      applicationIcon: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(Icons.spa_rounded, color: AppColors.Primary, size: 40.r),
                      ),
                      children: [
                        Text(LocaleKeys.about_desc.tr()),
                      ],
                    );
                  },
                  isDark: isDark,
                ),
              ],
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyle.txtStyle.copyWith(
          color: isDark ? DarkColors.textSecondary : AppColors.Txt,
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required List<Widget> children, required bool isDark}) {
    return Card(
      elevation: 0,
      color: isDark ? DarkColors.cardBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56.w,
      color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.1),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDark ? DarkColors.surfaceBackground : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
          size: 20.r,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.txtStyle.copyWith(
          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.Primary,
      ),
    );
  }

  Widget _buildLanguageTile(bool isDark) {
    final currentLanguage = context.locale.languageCode == 'ar' ? 'العربية' : 'English';

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDark ? DarkColors.surfaceBackground : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.language_rounded,
          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
          size: 20.r,
        ),
      ),
      title: Text(
        LocaleKeys.language.tr(),
        style: AppTextStyle.txtStyle.copyWith(
          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLanguage,
            style: AppTextStyle.txtStyle.copyWith(
              color: isDark ? DarkColors.textSecondary : AppColors.Txt,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: isDark ? DarkColors.textSecondary : AppColors.Txt,
            size: 14.r,
          ),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: isDark ? DarkColors.cardBackground : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'English',
                    style: TextStyle(
                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                      fontWeight: context.locale.languageCode == 'en'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: context.locale.languageCode == 'en'
                      ? Icon(Icons.check, color: AppColors.Primary)
                      : null,
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                Divider(color: isDark ? DarkColors.divider : Colors.grey.withOpacity(0.2)),
                ListTile(
                  title: Text(
                    'العربية',
                    style: TextStyle(
                      color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
                      fontWeight: context.locale.languageCode == 'ar'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: context.locale.languageCode == 'ar'
                      ? Icon(Icons.check, color: AppColors.Primary)
                      : null,
                  onTap: () {
                    context.setLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isDark ? DarkColors.surfaceBackground : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? (isDark ? DarkColors.textPrimary : AppColors.Secondary),
          size: 20.r,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.txtStyle.copyWith(
          color: isDark ? DarkColors.textPrimary : AppColors.Secondary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyle.txtStyle.copyWith(
          color: isDark ? DarkColors.textSecondary : AppColors.Txt,
          fontSize: 12.sp,
        ),
      ),
      onTap: onTap,
    );
  }
}
