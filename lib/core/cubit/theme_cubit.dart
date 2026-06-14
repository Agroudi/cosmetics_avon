import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const _key = 'dark_mode';

  ThemeCubit() : super(const ThemeState(isDarkMode: false));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    emit(ThemeState(isDarkMode: isDark));
  }

  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newValue);
    emit(ThemeState(isDarkMode: newValue));
  }

  ThemeMode get themeMode =>
      state.isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
