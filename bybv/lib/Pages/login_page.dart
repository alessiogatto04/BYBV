import 'package:bybv/Pages/home_page.dart';
import 'package:bybv/Pages/signup_page.dart';
import 'package:bybv/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  // Login con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Errore login Google: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Image(image: const AssetImage('images/imgLogIn.png'),),

          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.35,
                  top: screenHeight * 0.015,
                  right: screenWidth * 0.35,
                  bottom: screenWidth * 0,
                ),
                child: Image(
                  image: const AssetImage('images/imglogo.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.12,
                  right: screenWidth * 0.1,
                  bottom: screenHeight * 0.17,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Accesso",
                          style: TextStyle(
                            fontFamily: 'Poppins-Bold',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: screenWidth * 0.07,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // EMAIL
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
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.03),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // PASSWORD
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
                                  controller: _password,
                                  style: TextStyle(color: Colors.white),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.03),
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        // BOTTONE LOGIN
                        Container(
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: signIn,
                            child: Text(
                              "Accedi",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins-Bold',
                                ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.003),

                        // REGISTRAZIONE
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Non hai un account? ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      ),
                                  ),
                                  TextSpan(
                                    text: "Registrati\n\n\n",
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Bold',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "------------ o continua con ------------",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // GOOGLE BUTTON
                        Container(
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.05,
                          child: ElevatedButton(
                            onPressed: () async {
                              final userCredential = await signInWithGoogle();
                              if (userCredential != null) {
                                print(
                                    "Login Google riuscito : ${userCredential.user?.displayName}");
                              } else {
                                print("Login Google fallito o annullato");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/googleLogo.png",
                                  width: screenWidth * 0.05,
                                  height: screenWidth * 0.05,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Accedi con Google",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
      
    );
  }
}
