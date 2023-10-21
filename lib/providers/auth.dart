import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';
import 'package:together_online/models/user.dart' as U;
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/server.dart';


import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

final GoogleSignIn googleSignIn = new GoogleSignIn();
// final FacebookLogin facebookLogin = new FacebookLogin();
final Server? server = Server.getInstance();
final LocalStorage localStorage = new LocalStorage('credentials');
final _binding = DataBindingBase.getInstance();

class Auth {
  static String? groupId;
  static String? groupPassword;
  static String? name;
  static bool? rememberMe = true;

  static Future<Map<String, dynamic>> changeUserEmail(String email) async {
    try {
      User user = await firebaseAuth.currentUser!;
      await user.updateEmail(email);
      await Database.changeUserEmail(email);
      return {'success': true};
    } catch (e) {
      print('Error on changing email $e');
      return {'success': false, 'error': e};
    }
  }

  static Future<Map<String, dynamic>> updatePassword(
      String oldPass, String newPass) async {
    try {
      User user = firebaseAuth.currentUser!;
      await user.updatePassword(newPass);
      return {'success': true};
    } catch (e) {
      print('Error on changing password $e');
      return {'success': false, 'error': e};
    }
  }

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<dynamic> signIn(String email, String password) async {
    try {
      final authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      bool success = await getSession();
      if (success == true) {
        return {'success': true, 'error': null};
      } else {
        print('Something went wrong... ');
        return {'success': false, 'error': ""};
      }
    } catch (e) {
      print('Something went wrong... ' + e.toString());
      return {'success': false, 'error': e.toString()};
    }
    return {'success': false, 'error': null};
  }

  static getSession() async {
    User? user = await Auth.getCurrentFirebaseUser();
    if (user == null) return;

    final idTokenResult = await user.getIdToken();
    await server!.login(idTokenResult??"",
        groupId: groupId,
        groupPassword: groupPassword,
        name: user.displayName ?? "");
    return true;
  }

  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) return null;
    
    GoogleSignInAuthentication googleAuth = await account.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    try {
      await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      return {'success': false, 'error': getExceptionText(e as Exception)};
    }
    bool success = await getSession();
    // ignore: unrelated_type_equality_checks
    if (success == true) {
      return {'success': true, 'error': null};
    } else {
      print('Something went wrong... ');

      googleSignIn.signOut();
      return {
        'success': false,
        'error': "I couldn't add your user to the database"
      };
    }
    } catch (e) {
        print(e);
    }
  }


  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // static Future<Map<String, dynamic>?> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //   try {
  //     await firebaseAuth.signInWithCredential(oauthCredential);
  //   } catch (e) {
  //     return {'success': false, 'error': getExceptionText(e as Exception)};
  //   }
  //   bool success = await getSession();
  //   // ignore: unrelated_type_equality_checks
  //   if (success == true) {      return {'success': true, 'error': null};
  //   } else {
  //     print('Something went wrong... ' );
  //
  //     googleSignIn.signOut();
  //     return {
  //       'success': false,
  //       'error': "I couldn't add your user to the database"
  //     };
  //   }
  // }
  static Future<dynamic> signInWithFacebook() async {
    // FacebookLoginResult result =
    //     await facebookLogin.logIn(['email', 'public_profile']);
    //
    // print(
    //     'Status ' + result.status.toString() ?? '' + result.errorMessage ?? '');
    //
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     AuthCredential credential = FacebookAuthProvider.getCredential(
    //         accessToken: result.accessToken.token);
    //
    //     try {
    //       await firebaseAuth.signInWithCredential(credential);
    //     } catch (e) {
    //       return {'success': false, 'error': getExceptionText(e)};
    //     }
    //
    //     bool success =  await getSession();
    //     // ignore: unrelated_type_equality_checks
    //     if (success == true) {
    //       return {'success': true, 'error': null};
    //     } else {
    //       print('Something went wrong... ');
    //
    //       facebookLogin.logOut();
    //       return {
    //         'success': false,
    //         'error': "I couldn't add your user to the database"
    //       };
    //     }
    //
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     return {'success': false, 'error': null};
    //     break;
    //   case FacebookLoginStatus.error:
    //     facebookLogin.logOut();
    //     print('Something went wrong... ' + result.errorMessage);
    //     return {
    //       'success': false,
    //       'error': "Something went wrong with Facebook login. Please try again."
    //     };
    //     break;
    // }
  }

  static Future<dynamic> signUp(
      String email, String password, String? name) async {
    User? user;
    try {
      user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      print('Something went wrong... ' + e.toString());
      return {'success': false, 'error': e.toString()};
    }
    Auth.name = name;
    bool success = await getSession();
    // ignore: unrelated_type_equality_checks
    if (success == true) {
      _binding.session!.auth!.name = name!;
      server!.editUser();
      sleep(Duration(seconds: 2));if (success) {
        return {'success': true, 'error': null};
      } else {
        print('Something went wrong... ');

        firebaseAuth.signOut();
        return {
          'success': false,
          'error': "Something went wrong while sign in."
        };
      }
    }
  }

  static Future<dynamic> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Something went wrong... ' + e.toString());
      return {'success': false, 'error': e.toString()};
    }

    return {'success': true, 'error': false};
  }

  static Future<void> signOut() async {
    final provider = (await getCredentials())['provider'];
    switch (provider) {
      case 'facebook':
        // await facebookLogin.logOut();
        break;
      case 'google':
        await googleSignIn.signOut();
        break;
      default:
        break;
    }

    await deleteCredentials();
    Auth.saveToken("");
    _binding.session!.auth = null;
    return firebaseAuth.signOut();
  }

  static Future<User?> getCurrentFirebaseUser() async {
    User? user = await firebaseAuth.currentUser;
    return user;
  }

  static Future<dynamic> addUser(U.User user) async {
    var userExists = false;

    try {
      userExists = await checkUserExist(user.uid);
    } catch (e) {
      return {'success': false, 'error': e};
    }

    if (!userExists) {
      try {
        await FirebaseFirestore.instance
            .doc("users/${user.uid}")
            .set(user.toJson());

        return {'success': true, 'error': null};
      } catch (e) {
        return {'success': false, 'error': e};
      }
    } else {
      return {'success': true, 'error': 'user-exists'};
    }
  }

  static Future<bool> checkUserExist(String? userID) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static deleteCredentials() async {
    await localStorage.ready;

    await localStorage.deleteItem('email');
    await localStorage.deleteItem('password');
    await localStorage.deleteItem('preferedProvider');
    await localStorage.deleteItem('token');

    return;
  }

  static saveCredentials(
      String? email, String? password, String preferedProvider) async {
    await localStorage.ready;

    await localStorage.setItem('email', email);
    await localStorage.setItem('password', password);
    await localStorage.setItem('preferedProvider', preferedProvider);

    return;
  }

  static saveToken(String? token) async {
    await localStorage.ready;
    await localStorage.setItem('token', token);
  }

//  static Future<String> getToken() =>
//      localStorage.ready.then((value) =>
//        localStorage.getItem('token')
//    );

  static Future<String?> getToken() async {
    await localStorage.ready;
    var token = await localStorage.getItem('token');
    return token;
  }

  static Future<dynamic> getCredentials() async {
    await localStorage.ready;

    String? preferedProvider = await localStorage.getItem("preferedProvider");
    String? email = await localStorage.getItem("email");
    String? password = await localStorage.getItem("password");

    return {
      'preferedProvider': preferedProvider,
      'email': email,
      'password': password,
    };
  }

  static String getExceptionText(Exception e) {
    print('Exception: $e');
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
