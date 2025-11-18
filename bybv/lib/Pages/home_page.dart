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

    );
  }


}
