import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // title: --> bisognerà inserire il nome dell'utente. dobbiamo prima fare il firebase e capire come si fa
        // leading: TextButton(      //mi posiziona il child sulla sinistra
        //   onPressed: (){
        //     Navigator.push(        //mi permette di spostarmi in una nuova schermata interna alla directory dell'applicazione
        //       context,
        //      MaterialPageRoute(builder: (context) => paginaModifica()),  dobbiamo costruire la pagina paginaModifica
        //     );
        //   }, child: Text(
        //     "Modifica",
        //     style: TextStyle(
        //       fontSize: 18,
        //       color: Colors.lightBlueAccent
        //       ), 
        //   )
        // ),
      //     actions: [
      //       IconButton(
      //         onPressed: (){
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => pageSettings()),
      //           );
      //         }, icon: Icon(Icons.settings))
      //     ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Row(
          children: <Widget>[
            //bisogna inserire CircleAvatar così diventa circolare come le img di profilo
              //CircleAvatar(
                //radius: 40, // dimensione dell'immagine
                //backgroundImage: NetworkImage(
                //   'images/imgprofile.png'), // sostituisci con l'URL o File
                // ),
            Image(image: AssetImage("images/imgprofile.png")),

            SizedBox(width: 16),   //distanza tra immagini e testo
            Text(
              "",//nomeUtente da inserire come nel title a riga 11
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        
        ],)
        )
    );





  }


}
