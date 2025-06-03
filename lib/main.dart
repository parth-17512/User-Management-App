import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/blocs/user_list/user_list_bloc.dart';
import 'package:user_management_app/blocs/user_detail/user_detail_bloc.dart';
import 'package:user_management_app/blocs/user_posts/user_posts_bloc.dart';
import 'package:user_management_app/blocs/user_todos/user_todos_bloc.dart';
import 'package:user_management_app/blocs/theme/theme_bloc.dart'; // Import the new ThemeBloc
import 'package:user_management_app/services/api_service.dart';
import 'package:user_management_app/screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(); // Create a single instance of ApiService

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          // THIS IS THE IMPORTANT ADDITION FOR THE THEME BUTTON
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<UserListBloc>(
          create: (context) => UserListBloc(apiService),
        ),
        BlocProvider<UserDetailBloc>(
          create: (context) => UserDetailBloc(apiService),
        ),
        BlocProvider<UserPostsBloc>(
          create: (context) => UserPostsBloc(apiService),
        ),
        BlocProvider<UserTodosBloc>(
          create: (context) => UserTodosBloc(apiService),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        // Use BlocBuilder to react to theme changes
        builder: (context, themeState) {
          // Ensure themeState is of type ThemeLoaded to access themeData
          final currentTheme =
              (themeState is ThemeLoaded)
                  ? themeState.themeData
                  : ThemeData.light(); // Default to light if somehow not loaded
          return MaterialApp(
            title: 'User Management App',
            theme: currentTheme, // Set the theme from BLoC state
            home: const UserListScreen(),
          );
        },
      ),
    );
  }
}
