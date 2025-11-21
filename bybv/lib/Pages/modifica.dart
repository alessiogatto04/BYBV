import 'package:flutter/material.dart';

class Modifica extends StatelessWidget {
  const Modifica({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        title: Text(
          "Modifica Profilo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Fatto",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("images/imgprofile.png"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
