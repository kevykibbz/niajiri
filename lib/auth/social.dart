// ignore_for_file: use_build_context_synchronously

import 'package:Niajiri/screens/id_number.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:Niajiri/config/config.dart';
import 'package:Niajiri/exceptions/exceptions.dart';
import 'package:Niajiri/snackbar/snakbar.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

//variables
final auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;

//twitter sign in
void twitterLogin(BuildContext context) async {
  final twitterLogin = TwitterLogin(
    apiKey:MyConfig.twitterApiKey,
    apiSecretKey: MyConfig.twitterApiSecret,
    redirectURI: MyConfig.twitterCallbackURI,
  );

  await twitterLogin.login().then((value) async {
    final twitterAuthCredentials = TwitterAuthProvider.credential(
        accessToken: value.authToken!, secret: value.authTokenSecret!);
    await auth
        .signInWithCredential(twitterAuthCredentials)
        .then((userCredential) async {
      await firestoreInstance
          .collection('/users')
          .doc(userCredential.user?.uid)
          .get()
          .then((value)  {
        if (!value.exists) {
          firestoreInstance
          .collection('/users')
          .doc(userCredential.user?.uid)
          .set({
          "FullName": userCredential.user?.displayName,
          "UserName": "",
          "Email": userCredential.user?.email,
          "Phone": "",
          "isEmailLinkSent" :true,
          "PhotoURI":userCredential.user?.photoURL,
          "Role": "",
          "IdNumber": "",
          "IsBusy":false,
          "Balance":0.0,
          "Bio":"Some description about you...",
          "Location": "",
          "isEmailVerified": true,
          "isPhoneVerified": false,
          "Rating": 0.0,
          "Password": "",
          }).then((value) async{
              CreateSnackBar.buildSuccessSnackbar(context:context, message:"Logged in with twitter successfully.",onPress: () {
                Get.to(() => const IdNumberScreen());
              });
          });
        } 
      });
    });
  }).catchError((e) {
    final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
    Get.snackbar("Error.", ex.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red);
    throw ex;
  });
}

//google sign in
class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((userCredential) async {
        await firestoreInstance
          .collection('/users')
          .doc(userCredential.user?.uid)
          .get()
          .then((value) async {
          if (!value.exists) {
            await firestoreInstance
            .collection('/users')
            .doc(userCredential.user?.uid)
            .set({
              "FullName": userCredential.user?.displayName,
              "UserName": "",
              "Email": userCredential.user?.email,
              "Phone": "",
              "isEmailLinkSent" :true,
              "PhotoURI":userCredential.user?.photoURL,
              "Bio":"Some description about you...",
              "Role": "",
              "Balance":0.0,
              "IdNumber": "",
              "Location": "",
              "IsBusy":false,
              "isEmailVerified": true,
              "isPhoneVerified": false,
              "Rating": 0.0,
              "Password": "",
            }).then((value) async{
                CreateSnackBar.buildSuccessSnackbar(context:context, message:"Logged in with google successfully.",onPress: () {
                  Get.to(() => const IdNumberScreen());
                });
            });
          } 
        });
      });
      notifyListeners();
    } on FirebaseException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Get.snackbar("Error.", ex.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar("Error.", ex.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      throw ex;
    }
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

//facebook sign in
void facebookLogin() async {
  try {
    final facebookLoginResult = await FacebookAuth.i.login(
      permissions: ['public_profile', 'email'],
    );
    if (facebookLoginResult.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name'],
      });
    }
  } on FirebaseAuthException catch (e) {
    var content = '';
    switch (e.code) {
      case 'account-exists-with-different-credential':
        content = 'This account exits with a different sign in provider';
        break;
      case 'invalid-credential':
        content = 'Unknown error ocurred';
        break;
      case 'operation-not-allowed':
        content = 'This operation is not allowed';
        break;
      case 'user-disabled':
        content = 'The user you tried to log into is disabled';
        break;
      case 'user-not-found':
        content = 'The user you tried to log into was not found';
        break;
      default:
        content = 'Unknown error ocurred';
      Get.snackbar("Error.", content,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    }
  } on PlatformException {
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar("Error.", ex.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      throw ex;
  }
}
