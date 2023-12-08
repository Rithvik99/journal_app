import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journal_app/screens/navbar.dart';
import 'package:journal_app/services/database.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  getCurrentUser()async{
    return await auth.currentUser;
  }

  signWithGoogle(BuildContext context)async{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if(result != null){
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email,
        "username": userDetails.displayName,
        "profilePic": userDetails.photoURL,
        "id": userDetails.uid
      };

      await DatabaseMethods().addUserInfoToDB(userDetails.uid, userInfoMap).then((value) => {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NavBar()))
      });
    }
  }
}

