import 'package:bybv/Pages/home_page.dart';
import 'package:bybv/Pages/login_page.dart';
import 'package:bybv/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 47, 142, 226),
        title: const Text("Registrati",
        style: TextStyle(color :Colors.white),
        ),
      iconTheme: const IconThemeData(
      color: Colors.white, // 🎨 colore della freccia
      ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            //questo style serve per il colore della scritta che inseriamo
            style: const TextStyle(color:Colors.white),
            decoration: const InputDecoration(
              label: Text(
                "email" , 
                style: TextStyle(color :Colors.white), //questo style come anche quello sotto , 
                //inseriti nell'Input decoration servono a colorare di bianco le intestazione dell'input decoration
                ),
              ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            //questo style serve per il colore dei pallini e della scritta man mano che inseriamo
            style: const TextStyle(color:Colors.white),
            decoration: const InputDecoration(label: 
            Text(
              "password",
              style: TextStyle(color :Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              registerUser();
            },
            child: const Text("Crea Account"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage())); // torna al login
            },
            child: const Text("Hai già un account? Accedi"),
          ),
        ],
      ),
    );
  }
}