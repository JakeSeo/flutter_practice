import 'package:firebase_auth/firebase_auth.dart';

// https://dhruvnakum.xyz/flutter-bloc-v8-google-sign-in-and-firebase-authentication-2022-guide
class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<bool> isLoggedIn() async {
    if (_firebaseAuth.currentUser != null) {
      return true;
    }
    return false;
  }

  Future<void> login({required String email, required String password}) async {
    try {
      print("login: $email $password");
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("login successful!");
    } on FirebaseAuthException catch (e) {
      print("login FirebaseAuthException $e!");
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    } catch (e) {
      print("login Exception!!");
      throw Exception(e.toString());
    }
  }

  Future<void> signup({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendResetPasswordEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("sendResetPasswordEmail FirebaseAuthException $e!");
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      }
    } catch (e) {
      print("sendResetPasswordEmail Exception $e!");
      throw Exception(e.toString());
    }
  }

  Future<void> signout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
