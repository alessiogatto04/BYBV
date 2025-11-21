import 'package:bybv/Pages/home_page.dart';
import 'package:bybv/Pages/login_page.dart';
import 'package:bybv/auth.dart';
import 'package:flutter/material.dart'; //Flutter dispone di tutte le funzionalità, 
// colori e widget, noti come material component, necessari per lo sviluppo di applicazioni che rispettino i principi del material design.

import 'package:bybv/Pages/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(const BYBV());
}

class BYBV extends StatelessWidget {
  const BYBV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: Auth.instance.authStateChanges, // 🔹 Singleton corretto
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return HomeScreen();
          }
        },
      ),
    );
  }
}
