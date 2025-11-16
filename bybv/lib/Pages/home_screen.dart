import 'package:flutter/material.dart';
import 'package:bybv/Widget/Acces_Login_Button.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(  // ✅ AGGIUNGI QUESTO - è fondamentale!
      backgroundColor: Colors.black,  // Puoi cambiare il colore
      body: Stack(
        children: <Widget> [
          Positioned(
            top: 75,
            left: 50,
            child: Text(
              "BYBV",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                A_L_Button(
                  text: "Register",
                  onPressed: (){},
                ),
                SizedBox(width: 30), // Regola questo numero per lo spazio che vuoi
                A_L_Button(
                  text: "Login",
                  onPressed: (){},
                ),
              ],
            )
          ),
        ]
      ),
    );
  }
}

