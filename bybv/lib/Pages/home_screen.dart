import 'package:bybv/Pages/login_page.dart';
import 'package:bybv/Pages/signup_page.dart';
import 'package:bybv/Widget/Video_Back_Ground_Widget.dart';
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
      body: Stack(
        children: <Widget> [
          //video di sfondo 
          const VideoBackGround(videoPath: "video/homeScreenVideo.mp4"),
          //Essendo un logo già scontornato non mi serve il circleAvatar ma mi basta semplicemente 
          //fare un positioned
          Positioned(
            top: screenHeight * 0.050,
            left: screenWidth * 0.1,
            child: Image.asset(
              "images/imglogo.png",
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
          ),
          
          //Uso la classe RichText con TextSpan che mi permette di applicare stili diversi a parti diverse del testo in
          Positioned(
            top: screenHeight * 0.713, // usa una variabile definita
            left: screenWidth * 0.1,
            child: RichText(
              text: TextSpan(
                children: [

                  TextSpan(
                      text:"B",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"ecome ",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"Y",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"our ",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"B",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"est ",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                TextSpan(
                    text:"V",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"ersion \n",
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                  TextSpan(
                    text:"La tua forza parte da qui. \nAllenati con noi.",
                      style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth * 0.06, // dimensione testo proporzionale alla larghezza
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight *0.08,
            left: 0,
            right: 0,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:screenWidth *0.40,
                  height:screenHeight *0.080,
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
                  height:screenHeight *0.080,
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

