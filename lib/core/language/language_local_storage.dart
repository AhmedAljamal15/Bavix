import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageLocalStorage {
  static const _storage = FlutterSecureStorage();
  static const _languageKey = 'app_language';

  Future<void> saveLocale(Locale locale) async {
    await _storage.write(
      key: _languageKey,
      value: locale.languageCode,
    );
  }

  Future<Locale> getLocale() async {
    final value = await _storage.read(key: _languageKey);

    switch (value) {
      case 'ar':
        return const Locale('ar');
      case 'en':
        return const Locale('en');
      default:
        return const Locale('en');
    }
  }
}