import 'package:flutter/material.dart';
import 'package:bybv/Widget/Acces_Login_Button.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(  
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
                SizedBox(
                  width:150,
                  height:60,
                  child: A_L_Button(
                    text: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: (){},
                  ),
                ),
                SizedBox(width: 30), // Regola questo numero per lo spazio che vuoi
                SizedBox(
                  width:150,
                  height:60,
                  child: A_L_Button (
                    text: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: (){},
                  ),
                ),
              ],
            )
          ),
        ]
      ),
    );
  }
}

