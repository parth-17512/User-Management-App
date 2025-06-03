part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

// State holding the current ThemeData
class ThemeLoaded extends ThemeState {
  final ThemeData themeData;

  const ThemeLoaded(this.themeData);

  @override
  List<Object> get props => [themeData];
}
