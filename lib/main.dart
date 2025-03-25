import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:question_app/pages/auth_page.dart';
import 'package:question_app/pages/course_selection_page.dart';
import 'package:question_app/providers/user_provider.dart';
import 'package:question_app/providers/theme_provider.dart';
import 'package:question_app/blocs/year_selection/year_selection_bloc.dart';
import 'pages/field_selection_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/year_selection_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'کنکوریان',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Vazir',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade700,
          secondary: Colors.blue.shade500,
        ),
        useMaterial3: true,
        fontFamily: 'Vazir',
      ),
      home: const AuthPage(),
      routes: {
        '/field_selection': (context) => const FieldSelectionPage(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) {
          final userData = UserProvider.getUserData();
          if (userData == null) {
            return const AuthPage();
          }
          return ProfilePage(userData: userData);
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/year_selection') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => YearSelectionPage(
              fieldName: args['fieldName'],
            ),
          );
        } else if (settings.name == '/course_selection') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CourseSelectionPage(
              fieldName: args['fieldName'],
              year: args['year'],
            ),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

