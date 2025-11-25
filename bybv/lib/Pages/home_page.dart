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


  //appena viene aperta l'home page vengono presi da firebase i giorni in cui mi sono allenato
  @override 
  void initState(){
    super.initState();
    loadWorkouts();
  }

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<DateTime, List> events = {};


  DateTime _stripTime(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
  }

  //con questo dico che la data ha solo anno, mese e giorno senza ora. infatti anche con l'orario l'utente potrebbe prenotare lo stesso giorno ma con orari diversi
  String _dateId(DateTime dt){
    final d = _stripTime(dt);
    final y = d.year.toString().padLeft(4, '0');  
    final m = d.month.toString().padLeft(2, '0'); // se inserisco mese 2 inserirà in automatico 02 (arriva a 2 cifre inserendo 0 from left)
    final day = d.day.toString().padLeft(2, '0');

    return '$y-$m-$day';
  }

  Future<void> loadWorkouts() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final uid = user.uid;

    final coll = _firestore.collection('users').doc(uid).collection('workouts');

    final snap = await coll.get();
    final Map<DateTime, List> loaded = {};

    for(final doc in snap.docs){
      final dateStr = doc.id;
      final date = DateTime.parse(dateStr);
      loaded[_stripTime(date)] = ["allenamento"];
    }

    setState(() {
      events = loaded;
    });
}


Future<void> saveWorkout(DateTime day)async{
  final user = FirebaseAuth.instance.currentUser;
  if(user == null)return;

  final uid = user.uid;

  final d = _stripTime(day);
  final id = _dateId(d);
  final coll = _firestore.collection('users').doc(uid).collection('workouts');     //va a cercare in firestore dentro la collezione con l'uid che sto utilizzando attualmente dentro la subcollection workouts
  await coll.doc(id).set({
    'date': id,
    'createdAt': FieldValue.serverTimestamp(),
  });

  setState(() {
    events[d] = ['allenamento'];
  });
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

                eventLoader: (day){
                  final d = _stripTime(day);
                  return events[d] ?? [];
                },

                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.now(),

                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),


                onDaySelected: (selectedDay,focusedDay){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; 
                  });

                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text(
                          "Vuoi registrare l'allenamento?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                              child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              saveWorkout(_selectedDay!);
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "Vuoi anche registrare gli esercizi?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(builder: (context) => HomePage()),
                                          //   );
                                          },
                                        child: Text("No"),
                                      ),

                                      TextButton( 
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigator.push(context, MaterialPageRoute(builder: builder))    //va inserito l'invio alla pagina creaAllenamento;
                                        },   //va inserito l'invio alla pagina creaAllenamento;
                                        child: Text("Si"),
                                      ),
                                    ],
                                  );
                                });
                            },
                            child: Text("Sì"),
                          ),
                        ],
                      );
                    },
                  );
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


                  //queste righe servono a colorare i giorni in cui si è registrato l'allenamento
                  markerDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 25, 99, 28),
                    shape: BoxShape.circle,
                  ),
                selectedDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 25, 99, 28),
                  shape: BoxShape.circle,
                ),


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
