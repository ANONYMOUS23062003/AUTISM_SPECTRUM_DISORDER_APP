import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}


// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class AuthService {
//   final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<firebase_auth.User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return null;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final firebase_auth.AuthCredential credential =
//           firebase_auth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final firebase_auth.UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }

// //   // Future<firebase_auth.User?> signInWithFacebook() async {
// //   //   try {
// //   //     final LoginResult result = await FacebookAuth.instance.login();
// //   //     if (result.status == LoginStatus.success) {
// //   //       final facebookAuthCredential = firebase_auth.FacebookAuthProvider.credential(result.accessToken!.token);
// //   //       final firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
// //   //       return userCredential.user;
// //   //     }
// //   //     return null;
// //   //   } catch (e) {
// //   //     print(e);
// //   //     return null;
// //   //   }
// //   // }
// //
// //   // Future<firebase_auth.User?> signInWithApple() async {
// //   //   try {
// //   //     final appleCredential = await SignInWithApple.getAppleIDCredential(
// //   //       scopes: [
// //   //         AppleIDAuthorizationScopes.email,
// //   //         AppleIDAuthorizationScopes.fullName,
// //   //       ],
// //   //     );
// //
// //   //     final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
// //   //       idToken: appleCredential.identityToken,
// //   //       accessToken: appleCredential.authorizationCode,
// //   //     );
// //
// //   //     final firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
// //   //     return userCredential.user;
// //   //   } catch (e) {
// //   //     print(e);
// //   //     return null;
// //   //   }
// //   // }
// //
// //   Future<void> signOut() async {
// //     await _auth.signOut();
// //     await _googleSignIn.signOut();
// //     // await FacebookAuth.instance.logOut();
// //     // Apple sign-out logic if needed
// //   }
// // }
