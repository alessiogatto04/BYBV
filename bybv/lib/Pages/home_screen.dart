import 'package:bybv/Pages/login_page.dart';
import 'package:bybv/Pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:bybv/Widget/Acces_Login_Button.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    //Questi servono per adattare i widget ai vari dispositivi
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(  
      backgroundColor: Colors.black,  // Puoi cambiare il colore
      body: Column(
        children: <Widget> [
          Positioned(
            top: screenHeight *0.1,
            left: screenWidth *0.1,
            child: Text(
              "BYBV",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth *0.06,
              ),
            ),
          ),
          
          Positioned(
            top: screenHeight * 0.2, // usa una variabile definita
            left: screenWidth * 0.1,
            child: Text(
              "Become Your Best Version",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight *0.12,
            left: 0,
            right: 0,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:screenWidth *0.40,
                  height:screenHeight *0.075,
                  child: A_L_Button(
                    text: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth *0.045,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => SignUpPage()),  
                      );
                    },
                  ),
                ),
                SizedBox(width: screenWidth *0.08), // Regola questo numero per lo spazio che vuoi
                SizedBox(
                  width:screenWidth *0.40,
                  height:screenHeight *0.075,
                  child: A_L_Button (
                    text: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth *0.045,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),  
                      );
                    },
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

