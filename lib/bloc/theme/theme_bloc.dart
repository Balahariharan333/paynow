import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/theme/theme_event.dart';
import 'package:paynow/bloc/theme/theme_state.dart';
import 'package:paynow/hive/hive_service.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(_getInitialState()) {
    on<SetThemeModeEvent>(_onSetThemeMode);
  }

  static ThemeState _getInitialState() {
    final isDark = HiveService.getDarkMode();
    return ThemeState(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void _onSetThemeMode(SetThemeModeEvent event, Emitter<ThemeState> emit) {
    emit(ThemeState(event.themeMode));
    HiveService.saveDarkMode(event.themeMode == ThemeMode.dark);
  }
}
