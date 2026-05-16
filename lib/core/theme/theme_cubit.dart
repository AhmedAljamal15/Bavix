import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_local_storage.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeLocalStorage localStorage;

  ThemeCubit(this.localStorage)
      : super(
          const ThemeState(
            themeMode: ThemeMode.system,
          ),
        );

  Future<void> loadTheme() async {
    final mode = await localStorage.getThemeMode();
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> changeTheme(ThemeMode mode) async {
    await localStorage.saveThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }
}