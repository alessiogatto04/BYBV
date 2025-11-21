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
      await Auth().signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
    } on FirebaseAuthException catch (error) {}
  }


  @override
  Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
    backgroundColor: const Color.fromARGB(255, 50, 50, 50),

      // leading: , QUA ANDRA IL LOGO BYBV  
      title: const Text("Accedi con email e password"),
    ),
    body: Column(
      children: [
        TextField(
          controller: _email,
          decoration: InputDecoration(label: Text('email')),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          decoration: InputDecoration(label: Text('password')),
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