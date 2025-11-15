import 'package:flutter/material.dart'; //Flutter dispone di tutte le funzionalità, 
// colori e widget, noti come material component, necessari per lo sviluppo di applicazioni che rispettino i principi del material design.

import 'package:bybv/Pages/home_screen.dart';

void main() {
  runApp(const BYBV());
}

class BYBV extends StatelessWidget {
  const BYBV({super.key});


  @override
  Widget build(BuildContext context) {
    //Metodo che costruisce l'interfaccia grafica dell'applicazione
    return MaterialApp(home: HomeScreen(),);
  }
}

