import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Seleziona esercizi"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

    body: Column(
      children: [

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

  );
  }
}