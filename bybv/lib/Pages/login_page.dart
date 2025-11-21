import 'package:bybv/Pages/signup_page.dart';
import 'package:bybv/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super (key:key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
  
class _LoginPageState extends State<LoginPage>{
  final _email = TextEditingController();
  final _password = TextEditingController();


Future<void> signIn() async {
  try {
    await Auth.instance.signInWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login effettuato con successo!")),
    );
  } on FirebaseAuthException catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Errore Firebase: ${error.code}")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Altro errore: $e")),
    );
  }
}



  @override
  Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
    backgroundColor: const Color.fromARGB(255, 47, 142, 226),
      // leading: , QUA ANDRA IL LOGO BYBV 
      title: const Text("Accedi con email e password",
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
          style: TextStyle(color :Colors.white),
          decoration: InputDecoration(label: Text(
            'email',
            style: TextStyle(color :Colors.white),
            ),
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          style: TextStyle(color :Colors.white),
          decoration: InputDecoration(label: Text('password',
          style: TextStyle(color :Colors.white),
            ),
          ),
        ),
        ElevatedButton(onPressed: (){
          signIn();
        }, child: Text("Accedi")),
        TextButton(onPressed: (){
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
              );
        }, child: Text("Non hai un account? Registrati"))
      ],
    ),
  );
}

}