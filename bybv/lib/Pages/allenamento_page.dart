import 'package:bybv/Geolocalization/WorkoutUtils.dart';
import 'package:bybv/Pages/seleziona_esercizi_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bybv/Geolocalization/location_service.dart';
import 'package:bybv/Geolocalization/place.dart';
import 'dart:convert';

class AllenamentoPage extends StatefulWidget {
  const AllenamentoPage({Key? key}): super(key: key);

  @override
  State<AllenamentoPage> createState() => _AllenamentoPage();
}

class _AllenamentoPage extends State<AllenamentoPage> {

  // ============================================
  // LIFECYCLE: initState()
  // ============================================
  // Questa funzione si chiama UNA SOLA VOLTA quando la pagina viene aperta
  // Qui controlliamo se l'utente è in palestra e mostriamo il popup

  @override
  void initState() {
    super.initState();
    
    // Chiama la funzione che controlla se sei in palestra
    // Usiamo Future.delayed per aspettare che il widget sia costruito
    Future.delayed(Duration.zero, () {
      _checkIfInGymAndShowAdvice();
    });
  }

  // ============================================
  // FUNZIONE: Controlla se sei in palestra e mostra popup
  // ============================================
  // Questa funzione:
  // 1. Ottiene la tua posizione GPS
  // 2. Legge la palestra salvata
  // 3. Controlla se sei vicino alla palestra
  // 4. Se sì, mostra il popup con i consigli

  Future<void> _checkIfInGymAndShowAdvice() async {
    try {
      // ============================================
      // STEP 1: Leggi la palestra salvata
      // ============================================
      final prefs = await SharedPreferences.getInstance();
      final gymJson = prefs.getString('selected_gym');

      // Se l'utente non ha scelto una palestra, non fare nulla
      if (gymJson == null) {
        return;
      }

      // Trasforma il JSON in oggetto Place
      final gymData = jsonDecode(gymJson);
      final gym = Place.fromJson(gymData);

      // ============================================
      // STEP 2: Ottieni la tua posizione attuale
      // ============================================
      final locationService = LocationService();
      final userPosition = await locationService.getCurrentPosition();

      // ============================================
      // STEP 3: Controlla se sei vicino alla palestra
      // ============================================
      // isNearbyGym() ritorna true se sei entro 200 metri
      final isNearby = WorkoutUtils.isNearbyGym(
        userPosition.latitude,
        userPosition.longitude,
        gym.latitudine,
        gym.longitudine,
        radiusMeters: 200, // 200 metri di raggio
      );

      // Se NON sei in palestra, non mostrare il popup
      if (!isNearby) {
        return;
      }

      // ============================================
      // STEP 4: Se SEI in palestra, mostra il popup
      // ============================================
      // Ottieni il consiglio completo (orario, stagione, giorno)
      String advice = WorkoutUtils.getWorkoutAdvice();

      // Mostra il popup dialog
      if (mounted) {
        // "mounted" verifica che la pagina sia ancora visibile
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              '💪 Consiglio per l\'Allenamento',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              advice,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

      // ============================================
      // STEP 5: Salva la sessione di allenamento
      // ============================================
      // Registra che l'utente è in palestra e a che ora
      Map<String, String> session = WorkoutUtils.createWorkoutSession();
      await prefs.setString('last_workout', jsonEncode(session));

    } catch (e) {
      // Se c'è un errore (es: GPS spento, no internet)
      // Silenziosamente ignora l'errore (non mostrare niente all'utente)
      // Puoi aggiungere un log se vuoi debuggare
      print('Errore nel controllo palestra: $e');
    }
  }

  @override
  Widget build(BuildContext context){
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor, 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color), 
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Crea il tuo allenamento",
            style: TextStyle(
              fontFamily: 'Padding',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? Colors.white, 
            ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          SizedBox(height: screenHeight*0.03),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.05,
            ),
            
            child: SizedBox(
              width: double.infinity,
              height: screenHeight*0.06,
              child: ElevatedButton(
                onPressed: () async{
                  final selezionati = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SelezionaEserciziPage(null)));

                  if(selezionati != null){
                    print(selezionati);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface, 
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Theme.of(context).iconTheme.color, size: 24), 
                    SizedBox(width: screenWidth*0.05),
                    Text(
                      "Crea allenamento",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyLarge?.color, 
                      ),
                    )
                  ]
                  
                )
              ),
            ),
          ),

          SizedBox(height: screenHeight*0.05),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: screenWidth*0.08),
              child: Text(
                "Le mie routine di allenamento",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), 
                ),
              )
            )
          ),

          SizedBox(height: screenHeight*0.05),

        ]
      ),

    );
  }
}

  // @override
  // void initState(){
  //   super.initState();
  //   caricaRoutine();
  // }

//creo il metodo per caricare nel init --> primo widget che si costruisce quando si crea uno stateful widget la lista di routine

  // Future<void> caricaRoutine() async{

  //   final user = FirebaseAuth.instance.currentUser;
  //   if(user == null) return;

  //   final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  //   final snapshot = await docRef.get();

  //   if(snapshot.exists){
  //     final data = snapshot.data();
  //     setState(() {
  //       if(data != null){
  //         if(data['Routine'])
  //       }
  //     });
  //   }
  // }
