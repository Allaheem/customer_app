import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

// TODO: Import ThemeRepository for persistence

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // TODO: Inject ThemeRepository
  // final ThemeRepository _themeRepository;

  ThemeBloc(/* required this._themeRepository */) : super(const ThemeInitial(ThemeMode.dark)) { // Default to dark theme
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);

    // TODO: Load initial theme preference from repository
    // _loadInitialTheme();
  }

  /* void _loadInitialTheme() async {
    try {
      final savedThemeMode = await _themeRepository.getThemeMode();
      add(SetTheme(savedThemeMode));
    } catch (_) {
      // Handle error or default to dark
      add(const SetTheme(ThemeMode.dark));
    }
  } */

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newThemeMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeLoaded(newThemeMode));
    // TODO: Save the new theme preference
    // _themeRepository.saveThemeMode(newThemeMode);
    // print("Theme toggled to: $newThemeMode"); // Removed print statement
  }

  void _onSetTheme(SetTheme event, Emitter<ThemeState> emit) {
    emit(ThemeLoaded(event.themeMode));
    // TODO: Save the new theme preference if needed (e.g., initial load might not require saving again)
    // _themeRepository.saveThemeMode(event.themeMode);
     // print("Theme set to: ${event.themeMode}"); // Removed print statement
  }
}

