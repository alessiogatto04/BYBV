import 'package:bybv/Theme/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:bybv/Pages/home_page.dart';
import 'package:bybv/Pages/home_screen.dart';
import 'package:bybv/auth.dart';
import 'package:bybv/Theme/ThemeProvider.dart';
import 'firebase_options.dart';

void main() async {
  // Necessario per usare await prima di runApp
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const BYBV(),
    ),
  );
}

class BYBV extends StatelessWidget {
  const BYBV({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      // Tema chiaro e scuro
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,

      home: StreamBuilder(
        stream: Auth.instance.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
