import 'package:bybv/Pages/home_screen.dart';
import 'package:bybv/Pages/modifica.dart';
import 'package:flutter/material.dart';
import 'package:bybv/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bybv/Pages/home_page.dart';


class EserciziPage extends StatelessWidget{

   Future<String> getUsername() async{
    final user = FirebaseAuth.instance.currentUser; //prende l'utente loggato su firebase nel momento attuale
    if (user == null) return "";   //devo gestire il caso di nessun username (anche se non è possibile non avere username)

    final doc = await FirebaseFirestore.instance    //recupera il documento dell'utente --> va nella collezione eser, prende il documento con id = uid dell'utente e lo legge
    .collection('users')
    .doc(user.uid)
    .get();

    return doc.data()?['username'];   //restituisce l'username
  }

    Future<void> signOut() async{
    await Auth.instance.signOut();
  }



  final List<Map<String, String>> esercizi = [
    {
      'nome': 'Panca piana',
      'muscolo': 'Petto',
      'img': 'images/panca.png',
      'descrizione': 'Sdraiati sulla panca, solleva il bilanciere e abbassalo lentamente sul petto.'
    },
  ];


  @override
  Widget build(BuildContext context){

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      backgroundColor: Colors.black,

          centerTitle: true,  //centra il titolo
          title: Image.asset(
            'images/imgLogo.png',
            width: screenWidth *0.13,
            height: screenHeight*0.13,
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Modifica()),
                  );
              },
              icon: Icon(Icons.edit),
              color: Colors.white,
              
              
              ),

            IconButton(
              onPressed: (){}, //va inserito un navigato che porta alla pagina delle impostazioni delle applicazioni
              icon: Icon(Icons.settings),
              color: Colors.white,
              ),

            IconButton(onPressed: () async{
              await signOut();
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => HomeScreen())
                );
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
            ),
          ],
        ),

        body: ListView.builder(
          itemCount: esercizi.length,
          itemBuilder: (context, index){
            final esercizio = esercizi[index];
            return InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(esercizio['nome']!),
                    content: Text(esercizio['descrizione']!),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, child: Text(("Chiudi"))),
                    ],
                  ));
              },
            );
          },
          
          ),
          



    );
  }
}