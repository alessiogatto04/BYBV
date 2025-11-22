import 'package:bybv/Pages/home_page.dart';
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
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
    //Questi servono per adattare i widget ai vari dispositivi
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
    backgroundColor: Colors.black,
    // appBar: AppBar(
    // backgroundColor: const Color.fromARGB(255, 47, 142, 226),
    //   // leading: , QUA ANDRA IL LOGO BYBV 
    //   title: const Text("Accedi con email e password",
    //   style: TextStyle(color :Colors.white),
    //   ),
    //   iconTheme: const IconThemeData(
    //   color: Colors.white, // 🎨 colore della freccia
    //   ),
    // ),
//     body: Column(
//       children: [
//         TextField(
//           controller: _email,
//           style: TextStyle(color :Colors.white),
//           decoration: InputDecoration(label: Text(
//             'email',
//             style: TextStyle(color :Colors.white),
//             ),
//           ),
//         ),
//         TextField(
//           controller: _password,
//           obscureText: true,
//           style: TextStyle(color :Colors.white),
//           decoration: InputDecoration(label: Text('password',
//           style: TextStyle(color :Colors.white),
//             ),
//           ),
//         ),
//         ElevatedButton(onPressed: (){
//           signIn();
//         }, child: Text("Accedi")),
//         TextButton(onPressed: (){
//           Navigator.push(
//             context,
//               MaterialPageRoute(builder: (context) => SignUpPage()),
//               );
//         }, child: Text("Non hai un account? Registrati"))
//       ],
//     ),
//   );
// }

      body: Padding(
        padding: EdgeInsets.only(
          left:screenWidth *0.1 ,
          top: screenHeight * 0.25,
          right: screenWidth *0.1, 
          bottom: screenHeight *0.29),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black,              // colore dello sfondo
              border: Border.all(
              color: Colors.white,            // <-- colore del bordo
              width: 2,                      // spessore
            ),
            borderRadius: BorderRadius.circular(10), // opzionale
          ),
          child: Center(
            child: Column(
            children:[
              SizedBox(height: screenHeight * 0.03), //MESSO VALORE A CASO
              Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: screenWidth*0.07,
                  ),
                ),
              SizedBox(height: screenHeight * 0.04), //MESSO VALORE A CASO
              
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
                          labelText: 'Email',             // più semplice di label: Text(...)
                          labelStyle: TextStyle(color: Colors.white),
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


              SizedBox(height: screenHeight * 0.03), //MESSO VALORE A CASO
            
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
                        controller: _email,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',             // più semplice di label: Text(...)
                          labelStyle: TextStyle(color: Colors.white),
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

              SizedBox(height: screenHeight * 0.09), //MESSO VALORE A CASO
            
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
                    signIn();
                    }, child: Text(
                      "Accedi",
                      style: TextStyle(
                        color:Colors.black),
                    )
                ),
              ),

              SizedBox(height: screenHeight * 0.003), //MESSO VALORE A CASO

              TextButton(onPressed: (){
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
              }, child: Text(
                  "Non hai un account? Registrati",
                  style: TextStyle(
                      color:Colors.white,
                  ),))
            ],
          ),
        )
      ),
    ),
  );
}
}