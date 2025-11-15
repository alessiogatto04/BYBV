import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget{
  final String text; // è final perchè è StatelessWidget
  final VoidCallback onPressed;  //VoidCallBack è una classe che specifica che il cliccare un bottone non effettua nessuan funzione con ritorno

  const LoginButton({
    super.key,          // Super.key serve alla classe superiore per accedere a questo nel widget tree
    required this.text,
    required this.onPressed
  });
  //required serve per definire che la variabile , in questo caso this.text e onPressed, sono strettamente necessaria da inserire

  @override
  Widget build(BuildContext context){ // build serve a definire qualcosa di nuovo che stiamo creiamo . Memtre buildContext serve sempre per definire 
  //dove si trova nella gerarchia dell'albero dei context widget
    return OutlinedButton(    // return OutlinedButton(onPressed: onPressed, child: child) --> si aspetta questi valori, ovvero onPressed --> cosa succede quando clicco il bottone. child --> definisce cosa c'è dentro il bottone (TEXT)
      onPressed: onPressed, 
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(      // con shape definiamo la forma di un bottone, nel nostro caso un rettangoo con bordi modificabili e arrotondati di 8 pixel
          borderRadius: BorderRadius.circular(8),
        )
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
      )
    );

  }
}