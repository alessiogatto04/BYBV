import 'package:bybv/Pages/seleziona_esercizi_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AllenamentoPage extends StatefulWidget{
  const AllenamentoPage({Key? key}): super(key: key);

  @override
  State<AllenamentoPage> createState() => _AllenamentoPage();
}

class _AllenamentoPage extends State<AllenamentoPage>{

  // @override
  // void initState(){
  //   super.initState();
  //   caricaRoutine();
  // }

//creo il metodo per caricare nel init --> primo widget che si costruisce quando si crea uno stateful widget la lista di routine

  // Future<void> caricaRoutine() async{

  //   final user = FirebaseAuth.instance.currentUser;
  //   if(user == null) return;

  //   final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  //   final snapshot = await docRef.get();

  //   if(snapshot.exists){
  //     final data = snapshot.data();
  //     setState(() {
  //       if(data != null){
  //         if(data['Routine'])
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Crea il tuo allenamento",
            style: TextStyle(
              fontFamily: 'Padding',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          SizedBox(height: screenHeight*0.03),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.05,
            ),
            
            child: SizedBox(
              width: double.infinity,
              height: screenHeight*0.06,
              child: ElevatedButton(
                onPressed: () async{
                  final selezionati = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SelezionaEserciziPage()));

                  if(selezionati != null){
                    print(selezionati);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(255, 50, 50, 50)
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 24, fontWeight: FontWeight.bold),
                    SizedBox(width: screenWidth*0.05),
                    Text(
                      "Crea allenamento",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )
                  ]
                  
                )
              ),
            ),
          ),

          SizedBox(height: screenHeight*0.05),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: screenWidth*0.08),
              child: Text(
                "Le mie routine di allenamento",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white70,
                ),
              )
            )
          ),

          SizedBox(height: screenHeight*0.05),



        ]
      ),

    );
  }
}


