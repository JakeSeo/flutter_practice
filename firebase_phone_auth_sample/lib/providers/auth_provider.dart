import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthState {
  loggedOut,
  phoneNumberVerification,
  phoneNumberVerificationTimeout,
  emailLogin,
  emailSignup,
  emailVerification,
  forgotPassword,
  loggedIn,
  loading,
}

class AuthProvider extends ChangeNotifier {
  final StreamController<AuthState> _authStateChange =
      StreamController<AuthState>.broadcast();
  Stream<AuthState> get authStateChange => _authStateChange.stream;

  AuthState _authState = AuthState.loggedOut;
  AuthState get authState => _authState;

  String? _verificationId;
  String? get verificationId => _verificationId;

  final TextEditingController inputController = TextEditingController();

  set authState(AuthState state) {
    _authState = state;
    _authStateChange.add(state);
    notifyListeners();
  }

  loginWithPhoneNumber(String phoneNumber) async {
    verificationCompleted(PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
      authState = AuthState.loggedIn;
    }

    verificationFailed(FirebaseAuthException error) {
      authState = AuthState.loggedOut;
    }

    codeSent(String verificationId, int? forceResendingToken) {
      _verificationId = verificationId;
      authState = AuthState.phoneNumberVerification;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      authState = AuthState.phoneNumberVerificationTimeout;
    }

    authState = AuthState.loading;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  verifyPhoneNumber(String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.user == null) {
      authState = AuthState.loggedOut;
      return;
    }

    authState = AuthState.loggedIn;
  }

  Future<bool> emailSignedUp(String email) async {
    List<String> methodList =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (methodList.contains('password')) {
      return true;
    }
    return false;
  }

  signupWithEmail({required String email, required String password}) async {
    authState = AuthState.loading;
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user!.emailVerified) {
      authState = AuthState.loggedIn;
    } else {
      resendVerificationEmail();
      authState = AuthState.emailVerification;
    }
  }

  Future<bool> resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> checkIfVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  loginWithEmail({required String email, required String password}) async {
    authState = AuthState.loading;
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user!.emailVerified) {
      authState = AuthState.loggedIn;
    } else {
      authState = AuthState.emailVerification;
    }
  }

  logout() {
    FirebaseAuth.instance.signOut();
    authState = AuthState.loggedOut;
  }
}
