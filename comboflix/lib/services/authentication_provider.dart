import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comboflix/models/firestore_user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider {
  final FirebaseAuth? firebaseAuth;
  final FirebaseFirestore? firestore;
  //final GoogleSignIn? googleSignIn;
  //final FacebookAuth? facebookLogin;

  AuthenticationProvider({
    //this.googleSignIn,
    //this.facebookLogin,
    this.firestore,
    this.firebaseAuth,
  });

  anonymousSignIn() async {
    try {
      UserCredential credential = await firebaseAuth!.signInAnonymously();
      return credential.user;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      return [false, e];
    }
  }

  /*
  Future<bool> googleSignOption({bool isForTesting = false}) async {
    try {
      var googleLogin = await (googleSignIn!.signIn());

      var token = await googleLogin?.authentication;

      var credential = GoogleAuthProvider.credential(
          idToken: token?.idToken, accessToken: token?.accessToken);

      if (googleLogin != null) {
        var result = await firebaseAuth!.signInWithCredential(credential);

        if (!isForTesting) await _userCreate();

        return true;
      }
      return false;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      print(e);
      return false;
    }
  }

  Future<bool> appleSignOption({bool isForTesting = false}) async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.fullName,
        AppleIDAuthorizationScopes.email,
      ]);
      final appleIdCredential = result;

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken: appleIdCredential.authorizationCode,
        idToken: appleIdCredential.identityToken,
      );

      await firebaseAuth!.signInWithCredential(credential);

      List<String?> names = [
        result.givenName,
        result.familyName,
      ];

      String getFullName = names
          .where((element) => element != null && element.isNotEmpty)
          .join(" ");

      if (!isForTesting)
        await _userCreate(
            name: getFullName, email: appleIdCredential.email, apple: true);

      return true;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      print(e);
      return false;
    }
  }

  Future<bool> facebookSignOption({bool isForTesting = false}) async {
    try {
      var result = await facebookLogin!.login();

      print(result.message);

      var credential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      await firebaseAuth!.signInWithCredential(credential);

      if (!isForTesting) await _userCreate();

      return true;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      print(e);
    }
    return false;
  }
   */

  signInVerifiedUser(
      {required String email,
      required String password,
      bool isForTesting = false}) async {
    try {
      var result = await firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);

      await FirebaseAnalytics().setUserId(result.user!.uid);

      if (isForTesting) _userCreate(email: email, uid: result.user!.uid);

      return true;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      print(e);
      return false;
    }
  }

  Future<bool> emailSignUp({
    required String email,
    required String password,
    String? year,
    String? displayName,
    bool isForTesting = false,
  }) async {
    try {
      var create = await firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);

      await create.user!.sendEmailVerification();

      if (!isForTesting)
        await _userCreate(
          email: email,
          name: displayName,
          uid: create.user!.uid,
          year: year,
        );

      return true;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      print(e);

      return false;
    }
  }

  ///currently not in use
  /*
  Future<void> handleAuthException(
      dynamic e, String email, bool isForTesting) async {
    if (e == 'auth/account-exists-with-different-credential') {
      List<String> providers =
          await firebaseAuth!.fetchSignInMethodsForEmail(email);

      if (providers.indexOf(EmailAuthProvider.PROVIDER_ID) != -1) {
        // Password account already exists with the same email.
        // Ask user to provide password associated with that account.
        var password = 'Please provide the password for ' + email;
        firebaseAuth!
            .signInWithEmailAndPassword(email: email, password: password);
        //.then((value) => value.user.linkWithCredential(credential));
      } else if (providers.indexOf(GoogleAuthProvider.PROVIDER_ID) != -1) {
        var googleLogin = await (googleSignIn!.signIn());

        var token = await googleLogin?.authentication;

        var credential = GoogleAuthProvider.credential(
            idToken: token?.idToken, accessToken: token?.accessToken);

        await firebaseAuth!.signInWithCredential(credential);
      } else {}
    }
  }
   */

  Future<bool> sendResetPasswordEmail(String email) async {
    try {
      await firebaseAuth!.sendPasswordResetEmail(email: email);

      return true;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      print(e);

      return false;
    }
  }

  Future<void> signOut() async {
    //await facebookLogin!.logOut();

    //if (await googleSignIn!.isSignedIn()) await googleSignIn!.signOut();

    await firebaseAuth!.signOut();

    var prefs = await SharedPreferences.getInstance();

    await prefs.remove('cachedUser');

    await FirebaseAnalytics().logEvent(name: 'sign_out');

    print('signed out ');
  }

  _userCreate({
    String? name,
    String? email,
    String? uid,
    String? year,
  }) async {
    User? currentUser = firebaseAuth!.currentUser;

    await FirebaseAnalytics().setUserId(uid ?? currentUser!.uid);

    var user = FirestoreUser(
      name: name ?? currentUser!.displayName ?? '',
      email: email ?? currentUser!.email ?? '',
      uid: uid ?? currentUser!.uid,
      year: year ?? '',
    );

    checkAndAddUser(user);
  }

  @visibleForTesting
  checkAndAddUser(FirestoreUser user) async {
    var snapshot = await firestore!.collection('users').doc(user.uid).get();

    print("snapshot from auth " + snapshot.toString());

    print('snapshot exists ' + snapshot.exists.toString());

    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('cachedUser', JsonEncoder().convert(user.toJson()));

    if (!snapshot.exists) {
      await firestore!.collection('users').doc(user.uid).set(user.toJson());
    }
  }
}
