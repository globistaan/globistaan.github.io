import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginService {
  Future<void> signOut(BuildContext context) async {
    final googleSignIn = GoogleSignIn(
      clientId: '113652859308-4m7akrecnfk4bdrom1i86jor7dnlaj1s.apps.googleusercontent.com',
    );

    try {

      await googleSignIn.signOut();
      await googleSignIn.disconnect();
      // Handle successful signout (e.g., navigate to login screen)
      print('Signed out successfully');

      Navigator.pushNamed(context, "/");
    } on Exception catch (e) {
      // Handle signout errors
      print('Sign out failed: ${e}');
    }
  }
}