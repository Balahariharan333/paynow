import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/theme/theme_event.dart';
import 'package:paynow/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<SetThemeModeEvent>(_onSetThemeMode);
  }

  void _onSetThemeMode(SetThemeModeEvent event, Emitter<ThemeState> emit) {
    emit(ThemeState(event.themeMode));
  }
}
