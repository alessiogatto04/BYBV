import 'package:bybv/Pages/home_screen.dart';
import 'package:bybv/Pages/modifica.dart';
import 'package:bybv/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}): super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> signOut() async{
    await Auth.instance.signOut();
  }

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

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

      body: SingleChildScrollView(
        child: Column(
          children: [

            Row(
              children: [       
                InkWell(          //molto semplicemente rende un widget cliccabile (come un button normale ma per widget general)
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
                ),

                FutureBuilder<String>(
                  future: getUsername(),
                  builder: (context, snapshot){
                    // if(!snapshot.hasData){
                      
                    // }
                    return TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Modifica())
                          );
                      },
                      child: Text(
                        snapshot.data!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                )


              ],
            ),
            

            SizedBox(height: screenHeight* 0.04),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20) 
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

                SizedBox(width: screenWidth * 0.08),

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

            SizedBox(height: screenHeight*0.02),

            SizedBox(
              width: screenWidth* 0.7,
              height: screenHeight* 0.7,

              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.now(),

                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),


                onDaySelected: (selectedDay,focusedDay){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; 

                  });
                },

                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },

                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.white),
                  holidayTextStyle: TextStyle(color: Colors.red),
                  holidayDecoration: BoxDecoration(),   //rimuove il cerchio dai giorni indicati come festivi

                ),
                holidayPredicate: (date){
                  return date.weekday == DateTime.sunday;     //queste 3 righe impostano tutte le domeniche rosse nel calendaario per segnarle come giorno festivo
                },

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  )
                ),

                shouldFillViewport: false,
                availableGestures: AvailableGestures.all,

              )
            )
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
      ),

    );





  }


}
