part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

// Initial state, usually defaults to system or dark
class ThemeInitial extends ThemeState {
  const ThemeInitial(super.themeMode);
}

// State representing the currently applied theme
class ThemeLoaded extends ThemeState {
  const ThemeLoaded(super.themeMode);
}

