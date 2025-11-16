import 'package:flutter/material.dart';
import 'package:bybv/Widget/Acces_Login_Button.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  //vediamo
  @override
  Widget build(BuildContext context){
    return Stack(
      //videoPlayer
      children: <Widget> [
        Positioned(
          top: 75,
          left: 50,
          child: Text("BYBV",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]
    );
  }
}
