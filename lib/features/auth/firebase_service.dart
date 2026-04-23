import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }
  // --- Gast Account ---
  Future<User?> signInAnonymously() async {
    final credential = await _firebaseAuth.signInAnonymously();
    return credential.user;
  }

  Future<void> signOut() async {
    final user = _firebaseAuth.currentUser;
    if (user?.isAnonymous == true) {
      await user?.delete();
    } else {
      await _firebaseAuth.signOut();
    }
  }
}
