import 'package:flutter/material.dart';

import '../../core/storage/local_storage.dart';
import '../../core/storage/storage_keys.dart';

enum AppThemeMode { light, dark, orange }

class ThemeController extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.light;

  AppThemeMode get themeMode => _themeMode;
  ThemeController() {
    _loadSavedTheme(); // App start hote hi saved theme load karein
  }

  // Local storage se theme read karna
  Future<void> _loadSavedTheme() async {
    final savedThemeStr = await LocalStorage.read(StorageKeys.theme);
    if (savedThemeStr != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (e) => e.name == savedThemeStr,
        orElse: () => AppThemeMode.light,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    // Local storage mein theme save karna (.name string mein convert karta hai)
    await LocalStorage.write(StorageKeys.theme, mode.name);
  }

  Future<void> toggleTheme() async {
    switch (_themeMode) {
      case AppThemeMode.light:
        await setTheme(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        await setTheme(AppThemeMode.orange);
        break;
      case AppThemeMode.orange:
        await setTheme(AppThemeMode.light);
        break;
    }
  }
}
