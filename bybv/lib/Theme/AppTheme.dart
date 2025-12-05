import 'package:flutter/material.dart';
//E' statica perchè non dobbiamo creare istanze di questa classe perchè serve solo a salvare informazioni sui temi 
class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Dice a Flutter che questo è un tema chiaro , Flutter userà automaticamente testi scuri su sfondi chiari
    primarySwatch: Colors.blue, // Imposta il colore principale dell'app (pulsanti, app bar, ecc.) ,Swatch è una "palette" di sfumature dello stesso colore
    scaffoldBackgroundColor: Colors.white, // essendo che scaffold è praticamente lo sfondo di ogni schermata trasforma lo sfondo di ogni schermata in bianco
    // questa che segue è fittizia , giusto per far capire 
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue, //modifica lo sfondo della app barr che è già stato modificato da primarySwatch sopra , solo che questo magari è una personalizzazione più dettagliata , questo lo possiamo fare di qualsiasi widget
      foregroundColor: Colors.white, // qui semplicemente imposta i componenti dell'app bar a bianco
    ),
    // Aggiungi altre personalizzazioni
  );
  
  //stesso funzionamento di sopra 
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.white,
    ),
    // Aggiungi altre personalizzazioni
  );
}