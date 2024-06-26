import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  Future<UserCredential?> createWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    print('Oh eu aqui');
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      print('credential: $credential');

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print('credential: $credential');

    return credential;
  }
}
