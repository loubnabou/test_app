import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user != null ? user : null,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // Email & Password Sign Up
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    print(authResult);
    final FirebaseUser user = authResult.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    print('signUpEmail succeeded: $user');
    // Update the username
    await updateUserName(name, authResult.user);
    return user;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future convertUserWithEmail(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();
    final credential =
        EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  // GOOGLE

}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "من فضلك ادخل اسمك";
    }
    if (value.length < 2) {
      return "الاسم لا يجب ان يقل عن حرفين";
    }
    if (value.length > 50) {
      return "لا يمكن ان يزيد الاسم عن 50 حرف";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "من فضلك ادخل الايميل";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "من فضلك ادخل الباسورد";
    }
    return null;
  }
}
