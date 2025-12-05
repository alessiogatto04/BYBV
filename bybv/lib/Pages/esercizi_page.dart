import 'package:bybv/Pages/home_screen.dart';
import 'package:bybv/Pages/modifica.dart';
import 'package:flutter/material.dart';
import 'package:bybv/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class EserciziPage extends StatelessWidget{

   Future<String> getUsername() async{
    final user = FirebaseAuth.instance.currentUser; //prende l'utente loggato su firebase nel momento attuale
    if (user == null) return "";   //devo gestire il caso di nessun username (anche se non è possibile non avere username)

    final doc = await FirebaseFirestore.instance    //recupera il documento dell'utente --> va nella collezione users, prende il documento con id = uid dell'utente e lo legge
    .collection('users')
    .doc(user.uid)
    .get();

    return doc.data()?['username'];   //restituisce l'username
  }

    Future<void> signOut() async{
    await Auth.instance.signOut();
  }



  final List<Map<String, String>> esercizi = [
    {
      'nome': 'Panca piana',
      'muscolo': 'Petto',
      'img': 'images/petto.png',
      'descrizione': 'Sdraiati sulla panca, solleva il bilanciere e abbassalo lentamente sul petto.'
    },
    {
      'nome': 'Croci ai cavi',
      'muscolo': 'Petto',
      'img': 'images/petto.png',
      'descrizione': 'Con il tronco stabile, adduci orizzontalmente le braccia mantenendo una leggera flessione dei gomiti, enfatizzando la contrazione del pettorale.',
    },
    {
      'nome': 'Squat',
      'muscolo': 'Quadricipiti',
      'img': 'images/quadricipiti.png',
      'descrizione': 'In posizione eretta, fletti anche e ginocchia mantenendo la colonna neutra, scendi fino a rompere la parallela e risali estendendo completamente le anche.',
    },
    {
      'nome': 'Leg Pressa',
      'muscolo': 'Quadricipiti',
      'img': 'images/quadricipiti.png',
      'descrizione': 'Spingi la pedana estendendo anche e ginocchia, controlla la fase eccentrica mantenendo le ginocchia in linea con le punte dei piedi.',
    },
    {
      'nome': 'Crunch',
      'muscolo': 'Addome',
      'img': 'images/addome.png',
      'descrizione': 'In posizione supina, stabilizza il bacino e solleva il tronco contraendo il retto addominale fino a ridurre la distanza tra sterno e bacino.',    },
    {
      'nome': 'Leg Raises',
      'muscolo': 'Addome',
      'img': 'images/addome.png',
      'descrizione': 'In sospensione o supino, solleva gli arti inferiori estendendo l’anca e mantenendo il core in retroversione per evitare compensi lombari.',
    },
    {
      'nome': 'Curl con bilanciere',
      'muscolo': 'Bicipiti',
      'img': 'images/bicipiti.png',
      'descrizione': 'In stazione eretta, flette i gomiti mantenendo le braccia aderenti al tronco e controlla la fase eccentrica evitando compensi della spalla.',
      },
      {
      'nome': 'Curl su panca inclinata',
      'muscolo': 'Bicipiti',
      'img': 'images/bicipiti.png',
      'descrizione': 'Seduto su panca inclinata, estendi le braccia e flette i gomiti enfatizzando l’allungamento iniziale del bicipite e mantenendo il gomito fisso.',
      },

      //NON ABBIAMO LA FOTO DEI TRICIPITI DEVO FARLA GENERARE DA CHAT
      // {
    //   'nome': 'Pushdown ai cavi',
    //   'muscolo': 'Tricipiti',
    //   'img': 'images/tricipiti.png',
    //   'descrizione': 'Con il gomito stabile lungo il fianco, estendi l’avambraccio verso il basso fino alla completa estensione, controllando la fase eccentrica.',
    //   },
    //   {
    //   'nome': 'French press',
    //   'muscolo': 'Tricipiti',
    //   'img': 'images/tricipiti.png',
    //   'descrizione': 'Sdraiato su panca o seduto, flette e poi estendi i gomiti mantenendo l’omero perpendicolare al suolo per enfatizzare la tensione sul tricipite.',
    // },

    {
      'nome': 'Se mi clicchi sono interattivo',
      'muscolo': 'dentro è contenuto la spiegazione dell\'esercizio',
      'img': 'images/imgprofile.png',
      'descrizione': 'benvenuti in BYBV',
    }


  ];


  @override
  Widget build(BuildContext context){

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
      backgroundColor:Theme.of(context).appBarTheme.backgroundColor,

          centerTitle: true,  //centra il titolo
          title: Image.asset(
            'images/imgLogo.png',
            width: screenWidth *0.13,
            height: screenHeight*0.13,
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
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
              onPressed: () {}, //va inserito un navigator che porta alla pagina delle impostazioni delle applicazioni
              icon: const Icon(Icons.settings),
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
            color:  Theme.of(context).colorScheme.onSurface ,
            ),
          ],
        ),

        body: ListView.builder(
          itemCount: esercizi.length,
          itemBuilder: (context, index){
            final esercizio = esercizi[index];
            return InkWell(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(esercizio['nome']!),
                    content: Text(esercizio['descrizione']!),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, child: Text(("Chiudi"))),
                    ],
                  ));
              },

              child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth*0.025, vertical: screenHeight*0.005),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ), 
                child: Row(
                  children: [
                    Image.asset(
                      esercizio['img']!,
                      width: screenWidth*0.10,
                      height: screenHeight*0.10,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: screenWidth*0.037),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          esercizio['nome']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight*0.01),
                        Text(
                          esercizio['muscolo']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ]
                )
              )
            );
          },
          
          ),
          



    );
  }
}