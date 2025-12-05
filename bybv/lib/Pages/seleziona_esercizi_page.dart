import 'package:bybv/Pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SelezionaEserciziPage extends StatefulWidget{
  @override
  _SelezionaEserciziPageState createState() => _SelezionaEserciziPageState();
}

class _SelezionaEserciziPageState extends State<SelezionaEserciziPage>{
  final List<Map<String, String>> esercizi = [
    {'nome': 'Panca piana','muscolo': 'Petto','img': 'images/petto.png'},
    {'nome': 'Croci ai cavi','muscolo': 'Petto','img': 'images/petto.png'},
    {'nome': 'Squat','muscolo': 'Quadricipiti','img': 'images/quadricipiti.png'},
    {'nome': 'Leg Pressa','muscolo': 'Quadricipiti','img': 'images/quadricipiti.png'},
    {'nome': 'Crunch','muscolo': 'Addome','img': 'images/addome.png'},
    {'nome': 'Leg Raises','muscolo': 'Addome','img': 'images/addome.png'},
    {'nome': 'Curl con bilanciere','muscolo': 'Bicipiti','img': 'images/bicipiti.png'},
    {'nome': 'Curl su panca inclinata','muscolo': 'Bicipiti','img': 'images/bicipiti.png'}
    ];
  
  List<Map<String,String>> selezionati = [];
  DateTime? giornoAllenamento;


    String _dateId(DateTime dt){
      final d = _stripTime(dt);
      final y = d.year.toString().padLeft(4, '0');  
      final m = d.month.toString().padLeft(2, '0'); // se inserisco mese 2 inserirà in automatico 02 (arriva a 2 cifre inserendo 0 from left)
      final day = d.day.toString().padLeft(2, '0');

      return '$y-$m-$day';
    }

    DateTime _stripTime(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day);
    }

  Future<void> salvaAllenamento() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final allenamentiCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('allenamenti');

    final workoutsCollection = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('workouts');

    await allenamentiCollection.add({
      'giorno': giornoAllenamento,
      'esercizi': selezionati,  // salva tutti gli esercizi selezionati insieme
    });

    final d = _stripTime(giornoAllenamento!);
    final id = _dateId(d);
    await workoutsCollection.doc(id).set({
      'date': id,
      'createdAt': FieldValue.serverTimestamp(),  // si può evitate ma va a salvare in firestore a che ora creo l'allenamento --> in un futuro aggiornamento dell'app potremmo utilizzarlo per capire quanto dura l'allenamento 
    });
  }

  // Future<void> salvaGiornoEAggiornaCalendario(){

  // }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.black,
        child: SafeArea(
          top: false,
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              brightness: Brightness.dark,
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: giornoAllenamento ?? DateTime.now(),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (newDate) {
                setState(() {
                  giornoAllenamento = newDate;
                });
              },
            ),
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Seleziona esercizi",
          style: TextStyle(color: Colors.white),
          ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

    body: Column(
      children: [
        Row(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: screenWidth*0.04),
                    child: SizedBox(
                      width: screenWidth * 0.25,
                      child: const Text(
                        "Giorno allenamento",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(width: screenWidth*0.17),
                  Expanded(
                  child: GestureDetector(
                    onTap: _showDatePicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            giornoAllenamento == null
                                ? "Seleziona giorno"
                                : "${giornoAllenamento!.day}/${giornoAllenamento!.month}/${giornoAllenamento!.year}",
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 28,
                          ),
                        ]
                      )
                    ),
                  ),
                 )
              ],
            ),

        Expanded(
          child: ListView.builder(
            itemCount: esercizi.length,
            itemBuilder: (context, index){
              final esercizio = esercizi[index];
              final isSelected = selezionati.contains(esercizio);

              return InkWell(
                onTap: (){
                  setState(() {
                    if(isSelected){
                      selezionati.remove(esercizio);
                    }else{
                      selezionati.add(esercizio);
                    }
                  });
                },

                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight* 0.005
                  ),

                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green:Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
                      Image.asset(
                        esercizio['img']!,
                        width:  screenWidth *0.10,
                        height: screenHeight*0.10,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: screenWidth *0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              esercizio['nome']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              esercizio['muscolo']!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                      ),
                    ],
                  )

                ),

              );
            },

            ) 
        )
      ],
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue,
      child: Icon(Icons.check),
      onPressed: () async{
        if(giornoAllenamento == null){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Metti la data"))
          );return;
        }
        await salvaAllenamento();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Allenamento salvato'))
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()));
      }
    
    ),

  );
  }
}