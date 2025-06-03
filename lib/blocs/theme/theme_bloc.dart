import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Initial state is light theme
  ThemeBloc() : super(ThemeLoaded(ThemeData.light())) {
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    // If current theme is light, switch to dark; otherwise, switch to light.
    if (state is ThemeLoaded &&
        (state as ThemeLoaded).themeData == ThemeData.light()) {
      emit(ThemeLoaded(ThemeData.dark()));
    } else {
      emit(ThemeLoaded(ThemeData.light()));
    }
  }
}
