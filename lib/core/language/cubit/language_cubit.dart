import 'dart:ui';
import 'package:erp_sales/core/language/language_local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageLocalStorage localStorage;

  LanguageCubit(this.localStorage)
      : super(const LanguageState(Locale('en')));

  Future<void> loadLanguage() async {
    final locale = await localStorage.getLocale();
    emit(LanguageState(locale));
  }

  Future<void> changeLanguage(Locale locale) async {
    await localStorage.saveLocale(locale);
    emit(LanguageState(locale));
  }
}