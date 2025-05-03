import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Import actual screens (LoginScreen, HomeScreen, etc.)
// TODO: Import actual BLoCs (AuthBloc, ThemeBloc, etc.)
// TODO: Import AppThemes

// Placeholder imports - Replace with actual ones
import 'presentation/screens/auth/login_screen.dart'; // Assuming LoginScreen is the initial route if not logged in
// import 'presentation/blocs/auth/auth_bloc.dart'; // Placeholder AuthBloc - Removed due to conflict with login_screen.dart definition
import 'presentation/blocs/theme/theme_bloc.dart';
// import 'presentation/blocs/theme/theme_state.dart'; // Removed direct import of part file
import 'presentation/theme/app_themes.dart';

void main() {
  // TODO: Initialize BLoCs, Repositories, etc. (e.g., using GetIt or Provider)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide BLoCs at the top level
    return MultiBlocProvider(
      providers: [
        // TODO: Provide actual AuthBloc instance
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(), // Placeholder
        ),
        // Provide ThemeBloc
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(), // TODO: Inject repository if persistence is added
        ),
        // TODO: Provide other BLoCs (MapBloc, BookingBloc, ChatBloc, etc.)
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Taxi Ai',
            theme: AppThemes.lightTheme, // Light theme data
            darkTheme: AppThemes.darkTheme, // Dark theme data
            themeMode: themeState.themeMode, // Controlled by ThemeBloc
            debugShowCheckedModeBanner: false,
            // TODO: Implement routing logic based on AuthState
            home: const LoginScreen(), // Start with LoginScreen for now
            // Example routing based on auth state:
            /*
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthSuccess) {
                  return const HomeScreen(); // Or your main authenticated screen
                } else {
                  return const LoginScreen();
                }
              },
            ),
            */
          );
        },
      ),
    );
  }
}

