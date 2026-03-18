import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme(bool isOn) {
    state = isOn ? ThemeMode.dark : ThemeMode.light;
  }

  void setSystemTheme() {
    state = ThemeMode.system;
  }
}
