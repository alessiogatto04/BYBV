import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // Costruttore privato per il singleton
  Auth._privateConstructor();

  // Istanza singleton
  static final Auth instance = Auth._privateConstructor();

  // Istanza di FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Utente corrente
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream degli stati di autenticazione
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Registrazione
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
