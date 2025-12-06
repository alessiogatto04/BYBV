import 'package:bybv/Pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SelezionaEserciziPage extends StatefulWidget{
  final DateTime? selectedDay;

  SelezionaEserciziPage(this.selectedDay, {super.key});

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

  @override
  void initState(){
    super.initState();
    giornoAllenamento = widget.selectedDay;
  }


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


    await allenamentiCollection.add({
      'giorno': giornoAllenamento,
      'esercizi': selezionati,  // salva tutti gli esercizi selezionati insieme
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
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(

        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
        title: Text(
          "Seleziona esercizi",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),

    body: Column(
      children: [
        Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.04),
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
                  if(!isSelected){
                   showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, //permette di fare andare il showModalBottom oltre la metà. sennò flutter lo bloccherebbe a metà
                    builder: (context){

                      final TextEditingController serieController = TextEditingController(); // serve per gestire il TextField per il numero di serie.
                      List<TextEditingController> repsControllers = [];
                      List<TextEditingController> pesoControllers = [];

                      int numeroSerie = 0;
                      
                      return StatefulBuilder(   //permette di avviare un mini setState locale valido solo per  il builder di cui faccio il return
                        builder: (context, setStateModal){  //setStateModal è la funzione setState locale che StateFulBuilder passa automaticamente. AGGIORNA SOLO IL CONTENUTO DELLO StatefulBuilder non il widget esterno.
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,  //serve per spostare un widget verso l’alto quando appare la tastiera, in modo che non venga coperto.
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              height: screenHeight*0.75,
                              color: Colors.transparent,
                                
                                child: Column(
                                  children: [
                                    Text(
                                      "Aggiungi le serie e le rep per ${esercizio['nome']}",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),

                                    SizedBox(height: screenHeight*0.04),

                                    TextField(
                                      controller: serieController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Numero serie",
                                        labelStyle: TextStyle(color: Colors.white70),
                                         enabledBorder: UnderlineInputBorder(  //serve a "sottolineare" un campo quando è selezionato
                                          borderSide: BorderSide(color: Colors.white54),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (value){    //passa il testo corrente come parametro --> quello inserito nel textfield
                                        int n = int.tryParse(value) ?? 0;   //converte una stringa in un intero --> evita errori se non è un numero
                                        if(n != numeroSerie){
                                          numeroSerie = n;
                                          repsControllers = List.generate(
                                            numeroSerie,
                                            (_) => TextEditingController(),   //crea dinamicamente numeroSerie di TextEditingController in maniera dinamica. (_) --> parametro anonimo poichè non serve 
                                            );


                                          pesoControllers = List.generate(
                                            numeroSerie, 
                                            (_) => TextEditingController(),
                                          );

                                          setStateModal((){});  //ricostruisce il builder alla fine delle modifiche
                                        }
                                      },
                                    ),

                                    SizedBox(height: screenHeight*0.03),

                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: numeroSerie,     //crea una lista scrollabile in base al numeroSerie
                                        itemBuilder: (context, i){    //i = indice per indicare l'elemento i-esimo (da 0 a numeroSerie-1)
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: screenHeight*0.01),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: repsControllers[i],
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      labelText: "Reps serie ${i+1}",
                                                      labelStyle: TextStyle(color:Colors.white70),
                                                    ),
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth*0.035),

                                                Expanded(
                                                  child: TextField(
                                                    controller: pesoControllers[i],
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      labelText: "Peso serie ${i+1} (kg)",
                                                      labelStyle: TextStyle(color: Colors.white70),
                                                    ),
                                                  ) 
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        
                                        )
                                      ),

                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: (){
                                            List<Map<String, String>> serieDati = [];
                                            for(int i = 0; i != numeroSerie; i++){
                                              serieDati.add({
                                                'reps' : repsControllers[i].text,
                                                'peso' : pesoControllers[i].text,
                                              });
                                            }
                                            esercizio['serie'] = numeroSerie.toString();
                                            esercizio['dettagli'] = serieDati.toString();
                                            Navigator.pop(context);
                                          }, child: Text("Salva")),
                                      )


                                  ]
                                ),
                            ),
                          );
                        });
                       
                    },
                    
                    );

                  }
                },

                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight* 0.005
                  ),

                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Theme.of(context).primaryColor.withOpacity(0.7)
                      : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor.withOpacity(0.5),
                      width: isSelected ? 2 : 1,
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.10,
                        height: screenHeight * 0.10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          esercizio['img']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: screenWidth *0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              esercizio['nome']!,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              esercizio['muscolo']!,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                      ),
                      Spacer(),
                      if(isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 24,
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