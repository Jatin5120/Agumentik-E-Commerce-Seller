import 'dart:developer';

import 'package:constants/constants.dart';
import 'package:e_commerce_seller/controllers/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpers/helpers.dart';

abstract class AuthService {
  const AuthService._();

  static final AuthController _authController = Get.find();
  static final UserDataController _userDataController = Get.find();

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

  static Future<bool> logInWithGoogle() async {
    try {
      _authController.googleAccount = await _googleSignIn.signIn();

      if (_authController.googleAccount != null) {
        final GoogleSignInAuthentication googleAuth = await _authController.googleAccount!.authentication;

        final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(googleAuthCredential);

        log("Signed in with Google --> ${_firebaseAuth.currentUser?.displayName}");

        _userDataController.user = userCredential.user!;

        _authController.isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

        _authController.login();

        if (_authController.isNewUser) {
          log("New User Added");
          //TODO: implement add new user
          // FirebaseService.addNewUser();
        }
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e, st) {
      log("PlatformException --> ${e.message}\n$st");
      return false;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException --> ${e.message}");
      if (await _handleSignInError(e)) {
        return true;
      }

      return false;
    } catch (e, st) {
      log("No id selected -> $e\n$st");
      return false;
    }
  }

  static Future<bool> logInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

      final Map<String, dynamic> userData = await _facebookAuth.getUserData();

      log(userCredential.toString());
      log(userData.toString());

      _authController.isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

      _authController.login();

      if (_authController.isNewUser) {
        log("New User Added");
        //TODO: implement add new user
        // FirebaseService.addNewUser();
      }

      return true;
    } on PlatformException catch (e, st) {
      log("PlatformException --> ${e.message}\n$st");
      return false;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException --> ${e.message}");
      if (await _handleSignInError(e)) {
        return true;
      }

      return false;
    } catch (e, st) {
      log("No id selected -> $e\n$st");
      return false;
    }
  }

  static Future<bool> logInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      _userDataController.user = userCredential.user!;

      _authController.isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

      _authController.login();

      if (_authController.isNewUser) {
        log("New User Added");
        //TODO: implement add new user
        // FirebaseService.addNewUser();
      }

      return true;
    } on PlatformException catch (e, st) {
      log("PlatformException --> ${e.message}\n$st");
      return false;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException --> ${e.message}");
      if (await _handleSignInError(e)) {
        return true;
      }

      return false;
    } catch (e, st) {
      log("No id selected -> $e\n$st");
      return false;
    }
  }

  static Future<bool> logOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();

      _authController.logout();

      return true;
    } on PlatformException catch (e, st) {
      log("PlatformException --> ${e.message}\n$st");
      return false;
    } catch (e, st) {
      log("No id selected -> $e\n$st");
      return false;
    }
  }

  static Future<bool> _handleSignInError(FirebaseAuthException e) async {
    switch (e.code) {
      case FirebaseErrors.userDisabled:
        DialogHelper.showErrorDialog(
          title: "Error Login",
          message: "Your account has been disabled. Kindly contact admin",
        );
        break;
      case FirebaseErrors.userNotFound:
        DialogHelper.showErrorDialog(
          title: "Error Login",
          message: "No Account found. Register first if you haven't",
        );

        break;
      case FirebaseErrors.wrongPassword:
        DialogHelper.showErrorDialog(
          title: "Error Login",
          message: "Wrong password. Kindly check and try again",
        );
        break;

      case FirebaseErrors.accountExistDiffCreds:
        final String email = e.email!;
        final AuthCredential pendingCredential = e.credential!;

        List<String> userSignInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

        return await _handleMultipleSignInMethods(
          email: email,
          signInMethod: userSignInMethods.first,
          pendingCredential: pendingCredential,
        );

      default:
        log("Unknown Error --> ${e.code}");
        DialogHelper.showErrorDialog(
          title: "Error Login",
          message: "Something went wrong. Kindly try again later",
        );
        break;
    }

    return false;
  }

  /// This method is to handle `multiple sign in methods`
  /// Eg: If user has registered with both Google and Facebook account then
  /// this method will handle the sign in process and link the accounts
  static Future<bool> _handleMultipleSignInMethods({
    required String email,
    required String signInMethod,
    required AuthCredential pendingCredential,
  }) async {
    log("signInMethod --> $signInMethod");
    try {
      switch (signInMethod) {

        /// case to handle login using `Email and Password`
        case SignInMethod.password:
          final TextEditingController _passwordController = TextEditingController();

          final String? password = await DialogHelper.showInputDialog(
            controller: _passwordController,
            label: "Enter your password",
            message: "You have multiple sign in methods for email: $email. Please enter your password to continue",
          );
          if (password == null) {
            DialogHelper.showSnackBar(
              'Aborted',
              'Login processed cancelled from user end',
              dialogType: DialogType.warning,
            );
            return false;
          }

          UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          userCredential = await userCredential.user!.linkWithCredential(pendingCredential);
          log(userCredential.toString());
          return true;

        /// case to handle login using `Google`
        case SignInMethod.google:
          _authController.googleAccount = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth = await _authController.googleAccount!.authentication;

          final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          UserCredential userCredential = await _firebaseAuth.signInWithCredential(googleAuthCredential);

          userCredential = await userCredential.user!.linkWithCredential(pendingCredential);
          log(userCredential.toString());
          return true;

        /// case to handle login using `Facebook`
        case SignInMethod.facebook:
          final LoginResult result = await _facebookAuth.login();

          final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

          UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

          userCredential = await userCredential.user!.linkWithCredential(pendingCredential);

          final Map<String, dynamic> userData = await _facebookAuth.getUserData();

          log(userCredential.toString());
          log(userData.toString());

          return true;
      }
      return false;
    } catch (e, st) {
      log("SignInMethod --> $signInMethod\nError --> $e\n$st");
      return false;
    }
  }
}
