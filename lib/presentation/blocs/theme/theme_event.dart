part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

// Event to toggle between light and dark theme
class ToggleTheme extends ThemeEvent {}

// Event to set a specific theme (e.g., when loading initial preference)
class SetTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const SetTheme(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

