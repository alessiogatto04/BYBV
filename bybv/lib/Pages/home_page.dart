import 'package:bybv/Pages/home_screen.dart';
import 'package:bybv/Pages/modifica.dart';
import 'package:bybv/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}): super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> signOut() async{
    await Auth.instance.signOut();
  }

  Future<String> getUsername() async{
    final user = FirebaseAuth.instance.currentUser; //prende l'utente loggato su firebase nel momento attuale
    if (user == null) return "";   //devo gestire il caso di nessun username (anche se non è possibile non avere username)

    final doc = await FirebaseFirestore.instance    //recupera il documento dell'utente --> va nella collezione eser, prende il documento con id = uid dell'utente e lo legge
    .collection('users')
    .doc(user.uid)
    .get();

    return doc.data()?['username'];   //restituisce l'username
  }
  
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
        leading: FutureBuilder<String?>(    //futureBuilder crea un widget che aspetta il risultato di un future, in questo caso di username
          future: getUsername(),            
          builder: (context, snapshot) {    //viene eseguito ogni volta che cambia lo stato di future
            if (!snapshot.hasData) {        //questo vuol dire--> se non ci sono ancora risultati allora mostra ...
              return const Text("...");
            }
            return Center(
              child: Text(
                snapshot.data!,
                style: TextStyle(
                  color :Colors.white,
                  fontSize: 13,
                  ),
              ),
            );
          },
      ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Modifica()),
                );
            },
            icon: Icon(Icons.edit)),

          IconButton(
            onPressed: (){}, //va inserito un navigato che porta alla pagina delle impostazioni delle applicazioni
            icon: Icon(Icons.settings)),

          IconButton(onPressed: () async{
            await signOut();
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => HomeScreen())
              );
          }, icon: Icon(Icons.logout)),
         
        ],
      ),
      
      body: Column(
        children: [

          Row(
            children: [
              
              InkWell(          //molto semplicemente rende un widget cliccabile (come un button ma per widget general)
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> Modifica()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                    child: Row(
                    children: <Widget>[
                      //bisogna inserire CircleAvatar così diventa circolare come le img di profilo
                        CircleAvatar(
                          radius: 40, // dimensione dell'immagine
                          backgroundImage:AssetImage("images/imgprofile.png")
                        ),

                      SizedBox(width: 16),   //distanza tra immagini e testo
                      Text(
                        "",//nomeUtente da inserire come nel title a riga 11
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                  
                  ],)
                ),
              )
              


            ],
          ),
          

          SizedBox(height: screenHeight* 0.01),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20) // MESSO VALORE A CASO, CONTROLLATE E AGGIUSTATE CON L'EMULATORE
                  ),
                  backgroundColor: const Color.fromARGB(255, 50, 50, 50)
                ),
                child: Text(
                "Statistiche",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )),

              SizedBox(width: screenWidth * 0.05), //MESSO VALORE A CASO

              ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: const Color.fromARGB(255, 50, 50, 50)
                ),
                child: Text(
                "Esercizi",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )),
            ],
          ),

          //ciao
          SizedBox(height: screenHeight*0.01),
          // ElevatedButton(onPressed: (){},       HO COMPLETAMENTE SBAGLIATO ANDREBBE INSERITO IL CALENDARIO, DA CAPIRE COME SI FA
          //   style: ElevatedButton.styleFrom(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     backgroundColor:  const Color.fromARGB(255, 50, 50, 50)
          //   ),
          // child: Text(
          //   ""
          // ))          


        ]        
      )


    );





  }


}
