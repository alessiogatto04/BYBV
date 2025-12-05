import 'package:bybv/Pages/allenamento_page.dart';
import 'package:bybv/Pages/esercizi_page.dart';
import 'package:bybv/Pages/home_screen.dart';
import 'package:bybv/Pages/impostazioni.dart';
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
      'createdAt': FieldValue.serverTimestamp(),  // si può evitate ma va a salvare in firestore a che ora creo l'allenamento --> in un futuro aggiornamento dell'app potremmo utilizzarlo per capire quanto dura l'allenamento 
    });

    setState(() {
      events[d] = ['allenamento'];
    });
  }

  Future<void> removeWorkout(DateTime day) async{
    final user = FirebaseAuth.instance.currentUser;
    
    if(user == null)return;

    final uid = user.uid;

    final d = _stripTime(day);
    final id = _dateId(d);
    final coll = _firestore.collection('users').doc(uid).collection('workouts');

    await coll.doc(id).delete();

    setState(() {
      events.remove(d);
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        centerTitle: true,  //centra il titolo
        title: Image.asset(
          'images/imgLogo.png',
          width: screenWidth *0.13,
          height: screenHeight*0.13,
        ),
        leadingWidth: screenWidth*0.3,
        leading:Padding(
          padding: EdgeInsets.only(left: screenWidth*0.04),
          child: FutureBuilder<String?>(    //futureBuilder crea un widget che aspetta il risultato di un future, in questo caso di username
          
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
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Settings_Page()));

            }, //va inserito un navigato che porta alla pagina delle impostazioni delle applicazioni
            icon: Icon(Icons.settings),
            color: Theme.of(context).colorScheme.onSurface,
            ),

          IconButton(onPressed: () async{
            await signOut();
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => HomeScreen())
              );
          },
          icon: Icon(Icons.logout),
          color: Theme.of(context).colorScheme.onSurface,
          ),
         
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        onTap: (index){
          if(index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllenamentoPage()));
          }
        },
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Allenamento'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home-page')
      ]),
      

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin:  EdgeInsets.only(
                right: screenWidth*0.35,
                top: screenHeight*0.015,
              ),
              width: screenWidth * 0.5,
              height: screenHeight*0.18,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(0  ),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                )
              ),
              child: Row(
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
                      ],)
                    ),
                  ),
                  
                  SizedBox(width: screenWidth*0.035),   //distanza tra immagini e testo

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
            ),
            

            SizedBox(height: screenHeight* 0.04),

            Padding(
              padding: EdgeInsets.only(left: screenWidth *0.07),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pannello di controllo",
                  style: TextStyle(
                    fontSize: 14,
                    color:  const Color.fromARGB(255, 50, 50, 50),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            ),

            SizedBox(height: screenHeight* 0.02),

            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth*0.08),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10) 
                      ),
                    ),
                    child: Text(
                    "Statistiche",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  )),
                ),

                  SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => EserciziPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    child: Text(
                      "Esercizi",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )),
                ),
                SizedBox(width: screenWidth*0.08),
              ],
            ),

            SizedBox(height: screenHeight*0.035),

            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: screenWidth*0.25,
            //   ),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(onPressed: (){
            //       // Navigator.push(
            //       //   context, 
            //       //   MaterialPageRoute(
            //       //     builder: (context) => PageCalendario()),
            //       // );
            //       },
            //       style: ElevatedButton.styleFrom(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)
            //         ),
            //       backgroundColor: const Color.fromARGB(255, 50, 50, 50)
            //       ),
            //       child: Text(
            //         "Calendario",
            //         style: TextStyle(
            //           fontSize: 17,
            //           color: Colors.white,
            //         ),
            //       )
            //     ),
            //   )
            // ),
            
            SizedBox(
              width: screenWidth* 0.7,
              // height: screenHeight* 0.7,

              child: TableCalendar(
                rowHeight: screenHeight* 0.07,
                
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

                  final normalized = _stripTime(selectedDay);
                  final giaPresente = events.containsKey(normalized);

                  if(!giaPresente){
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

                  }else{
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text(
                            "Vuoi rimuovere la seduta di allenamento?",
                          ),
                          actions: [
                            TextButton(
                              onPressed:(){Navigator.pop(context);},
                               child: Text(
                                "No",
                               )),
                               TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  removeWorkout(selectedDay);
                                },
                                child: Text(
                                  "Si",
                                )),
                          ],
                        );
                      }
                    );
                  }



                  
                },

                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },

                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.red),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.white),
                  holidayTextStyle: TextStyle(color: Colors.red),
                  holidayDecoration: BoxDecoration(),   //rimuove il cerchio dai giorni indicati come festivi
                  outsideDaysVisible: false,
                  

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
                  ),

                //Devo manualmente cambiare il colore delle frecce che mi permettono di muovermi nel calendar inserendo nuove Icon che le rappresentano
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),

                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 28,
                  ),

                ),

                shouldFillViewport: false,
                availableGestures: AvailableGestures.all,

              ),
            ),


            SizedBox(height: screenHeight*0.04),

            Padding(
              padding:  EdgeInsets.only(left: screenWidth*0.07),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Allenamenti registrati",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color:  const Color.fromARGB(255, 50, 50, 50),
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            ),

            SizedBox(height: screenHeight*0.03),
            



          ]        
        )
      ),

    );





  }


}
