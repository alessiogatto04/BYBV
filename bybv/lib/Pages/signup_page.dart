import 'package:bybv/Pages/home_page.dart';
import 'package:bybv/Pages/login_page.dart';
import 'package:bybv/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();


  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  void validateInputs(String email, String password) {
    if (!emailRegex.hasMatch(email)) {
      print("Email non valida");
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      print("Password non valida");
      return;
    }

    print("OK, puoi creare l'account");
    createUser();          
  }

  Future<void> createUser() async {
    await Auth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future<void> salvaUsername(String username) async {
  try {
    // Ottieni riferimento alla collezione "utenti"
    CollectionReference utenti = FirebaseFirestore.instance.collection('utenti');

    // Aggiungi un documento con campo "username"
    await utenti.add({
      'username': username,
      'timestamp': FieldValue.serverTimestamp(), // opzionale
    });

    print("Username salvato con successo!");
  } catch (e) {
    print("Errore nel salvare username: $e");
  }
}

Future<void> registerUser() async {
  try {
    // Stampo i valori prima di inviare
    print("Email: ${_email.text}");
    print("Password: ${_password.text}");

    await Auth.instance.createUserWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );

    // Utente creato
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Utente creato correttamente!")),
    );
    print("Utente creato correttamente: ${_email.text}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

  } on FirebaseAuthException catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Errore Firebase: ${error.code}")),
    );
    print("Errore Firebase: ${error.code} - ${error.message}");
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Altro errore: $e")),
    );
    print("Altro errore: $e");
  }
}

@override
  Widget build(BuildContext context){
    //Questi servono per adattare i widget ai vari dispositivi
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
    backgroundColor: Colors.black,

    body: Stack(
      children: <Widget> [
          Image(
            image: const AssetImage('images/imgSignUp.png'),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
      
          AppBar(
            backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(
              color: Colors.white,
              ),
            ),

        Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.35,
              top: screenHeight * 0.10,
              right: screenWidth * 0.35,
              bottom: screenWidth * 0,
            ), 
              child: Image(
                image: const AssetImage('images/imglogo.png'),  
              ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left:screenWidth *0.1 ,
              top: screenHeight * 0.09,
              right: screenWidth *0.1, 
              bottom: screenHeight *0.17),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,              // colore dello sfondo
                  border: Border.all(
                  color: Colors.white,            // colore del bordo
                  width: 2,                      // spessore
                ),
                borderRadius: BorderRadius.circular(10), 
              ),
              child: Center(
                child: Column(
                children:[
                  SizedBox(height: screenHeight * 0.03), 
                  Text(
                      "Registrati",
                      style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: screenWidth*0.07,
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.041), 
                  Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _email,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color:Colors.white,
                                fontFamily: 'Poppins',
                              ),             
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                ),
                              border: InputBorder.none,       // rimuove il bordo interno
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(
                            right: screenWidth *0.030, 
                            ),
                          child:  Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),


                  SizedBox(height: screenHeight * 0.023),
                  
                  Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _username,  
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),             
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(
                              right: screenWidth *0.030, 
                          ),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(height: screenHeight * 0.023),


                  Container(
                    width: screenWidth * 0.6,          // 90% della larghezza dello schermo
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _password,
                            style: TextStyle(color: Colors.white),
                            obscureText: true,                           
                            decoration: InputDecoration(
                              hintText: 'Password',             // più semplice di label: Text(...)
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                ),
                              border: InputBorder.none,       // rimuove il bordo interno
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(
                            right: screenWidth *0.030, 
                            ),
                          child:  Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.065), 
                
                  Container(
                    width: screenWidth * 0.6,          // 90% della larghezza dello schermo
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:ElevatedButton(onPressed: (){
                        validateInputs(_email.text.trim(), _password.text.trim());  //trim toglie gli spazi a inizio e fine riga
                        String username = _username.text.trim();
                        if(username.isNotEmpty) {
                          salvaUsername(username); // salva su Firestore
                        } else {
                            // mostra errore se vuoto
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Inserisci un username"))
                            );
                        }

                        }, child: Text(
                          "Registrati",
                          style: TextStyle(
                            color:Colors.black,
                            fontFamily: 'Poppins-Bold',
                            ),
                        )
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.003), 

                  TextButton(onPressed: (){
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }, 
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:"Hai già un account? ",
                            style: TextStyle(
                              color:Colors.white,
                              fontFamily: 'Poppins'
                            ),
                          ),
                          TextSpan(
                            text:"Accedi",
                            style: TextStyle(
                              color:Colors.white,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.bold,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ),
                  )
                ],
                ),
              )
            ),
          ),
        ]
      )
      ],
    )
  );
}
}