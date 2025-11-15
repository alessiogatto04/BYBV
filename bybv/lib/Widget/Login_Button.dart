import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget{
  final String text; // è final perchè è StatelessWidget
  final VoidCallbackAction onPressed;  //VoidCallBack è una classe che specifica che il cliccare un bottone non effettua nessuan funzione con ritorno

  const LoginButton({super.key, required this.text});
  // SUper.key serve alla classe superiore per accedere a questo nel widget tree
  //required serve per definire che la variabile , in questo caso this.text , è strettamente necessaria da inserire

  @override
  Widget build(BuildContext context){ // build serve a definire qualcosa di nuovo che stiamo creiamo . Memtre buildContext serve sempre per definire 
  //dove si trova nella gerarchia dell'albero dei context widget
    return MaterialApp( //material app definisce la grafica del nostro bottone attraverso Scaffold
    home: Scaffold(
      
      )
    );
  }
}