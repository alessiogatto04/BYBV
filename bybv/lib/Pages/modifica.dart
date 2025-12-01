import 'package:bybv/Pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Modifica extends StatefulWidget {
  const Modifica({super.key});

  @override
  State<Modifica> createState() => _ModificaState();
}

class _ModificaState extends State<Modifica> {
  String? selectedSex;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController =TextEditingController();
  DateTime? dataDiNascita;


  int height = 170;


  @override
  void initState() {    
    super.initState();
    caricaTuttiIDati();
    // height = 170; // assicurato prima del build
  }

  Future<void> saveNome() async {
    final user = FirebaseAuth.instance.currentUser;
      if(user == null) return; //questo indica che --> se user non loggato allora non fare nulla

      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await docRef.set({
        'name': nameController.text,
      }, SetOptions(merge: true)); // merge --> true. Aggiorna se il valore è gia presente
  }


  Future<void> saveUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set({
      'username': usernameController.text,
    }, SetOptions(merge: true),
    );
  }

  Future<void> saveHeight() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set({
      'height': height,
    }, SetOptions(merge: true));
  }

  Future<void> saveSex() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set({
      'sesso': selectedSex,
    }, SetOptions(merge: true));
  }

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
              initialDateTime: dataDiNascita ?? DateTime(1900, 1,1),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (newDate) {
                setState(() {
                  dataDiNascita = newDate;
                });
              },
            ),
          )
        ),
      ),
    );
  }
  Future<void> saveDateOfBirth() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set({
      'Data Di Nascita': dataDiNascita,
    }, SetOptions(merge: true));
  }

  Future<void> caricaTuttiIDati() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    if(snapshot.exists){
      final data = snapshot.data();
      setState(() {
        if(data != null){
          if(data['name'] != null){
            nameController.text = data['name'];
          }
          if(data['username'] != null){
            usernameController.text = data['username'];
          }
          if(data['height'] != null){
            height = data['height'];
          }else{
            height = 170;
          }
          if(data['sesso'] != null){
            selectedSex = data['sesso'];
          }else{
            selectedSex ="";
          }
          if(data['Data Di Nascita'] != null){
            dataDiNascita = (data['Data Di Nascita'] as Timestamp).toDate();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        title: const Text(
          "Modifica Profilo",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, //TORNA ALLA PAGINA DI PRIMA NON SALVANDO
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed:
                () async {
                  await saveNome();
                  await saveUsername();
                  await saveHeight();
                  await saveSex();
                  await saveDateOfBirth();
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dati salvati!')),
                  );
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => HomePage()));
                }, //TORNA ALLA PAGINA DI PRIMA SALVANDO TUTTI I DATI E CAMBIAMENTI
            child: const Text(
              "Fatto",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.12,
                    backgroundColor: Colors.black,
                    backgroundImage: const AssetImage("images/imgprofile.png"),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            const Text(
              "Dati personali",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            SizedBox(height: screenHeight * 0.02),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Nome",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Inserisci nome",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Username",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Inserisci username",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Altezza ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: NumberPicker(
                    minValue: 60, 
                    maxValue: 235,
                    value: height.clamp(60, 235),
                    onChanged: (v){
                      setState(() {
                        height = v;
                      });
                    }
                  )
                ),
              ],
            ),

            // SizedBox(height: screenHeight * 0.03),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Sesso",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSex,
                      dropdownColor: Colors.black,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 28,
                      ),
                      hint: const Text(
                        "Seleziona",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "M",
                          child: Text(
                            "Maschio",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "F",
                          child: Text(
                            "Femmina",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "N",
                          child: Text(
                            "Poco e niente",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSex = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Nascita",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: _showDatePicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dataDiNascita == null
                                ? "Seleziona data di nascita"
                                : "${dataDiNascita!.day}/${dataDiNascita!.month}/${dataDiNascita!.year}",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
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

            
          ],
        ),
      ),
    );
  }
}
