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

  );
  }
}