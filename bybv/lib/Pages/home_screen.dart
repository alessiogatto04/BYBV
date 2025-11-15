import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({
    super.key
  })
  
  //Capiamo
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
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

      ]
    );
    


  }
  
}
