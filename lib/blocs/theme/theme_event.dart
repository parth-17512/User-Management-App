part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

// Event to toggle the theme
class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}
