import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class ThemeLocalStorage {
  static const _storage = FlutterSecureStorage();
  static const _themeModeKey = 'theme_mode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _storage.write(
      key: _themeModeKey,
      value: mode.name,
    );
  }

  Future<ThemeMode> getThemeMode() async {
    final value = await _storage.read(key: _themeModeKey);

    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}