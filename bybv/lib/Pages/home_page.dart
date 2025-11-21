import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 47, 142, 226),
        // leading: , QUA ANDRA IL LOGO BYBV 
        title: const Text("Qui ci vuole il nome dell'utente",
        style: TextStyle(color :Colors.white),
        ),
        iconTheme: const IconThemeData(
        color: Colors.white, // 🎨 colore della freccia
        ),
      ),
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
      
      body: Column(
        children: [
          Padding(
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
