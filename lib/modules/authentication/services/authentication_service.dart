import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  Future<UserCredential?> createWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }
}
