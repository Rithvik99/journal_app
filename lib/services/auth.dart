import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _journals =
      FirebaseFirestore.instance.collection('journals');
  
  getCurrentUser()async{
    return await auth.currentUser;
  }

  //User Specific
  Map<String, dynamic>? userData;
  Map<String, dynamic>? userJournals;

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

      // await DatabaseMethods().addUserInfoToDB(userDetails.uid, userInfoMap).then((value) => {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>NavBar()))
      // });
    }
  }

  // Similar to above signin with google now perform singup with email and password
  // Firstly you need to validate if the user is already registered or not
  Future<bool> signUpWithEmailAndPassword(String email, String password, String username, BuildContext context)async{
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? userDeatils = result.user;

      print("user Created");
      await _users.doc(userDeatils?.uid).set({
        'username': username,
        'email': email,
        'journals': [],
        'google': '',
        'facebook': '',
        'date': convertDate(DateTime.now())
      });

      print('User Added to Db');

      DocumentSnapshot userDoc = await _users.doc(userDeatils?.uid).get();
      print("User Doc Fetched");

      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
        print("User Data Stored");
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print("Fetch Error : ${e.code}");
      return false;
    }
  }

  Future<bool> logInWithEmailPassword(String email, String password) async {
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      print("user Logged In");

      User? userDeatils = result.user;
      DocumentSnapshot userDoc = await _users.doc(userDeatils?.uid).get();
      print("User Doc Fetched");

      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
        print("User Data Stored");
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print("Fetch Error : ${e.code}");
      return false;
    }
  }

  String? fetchField(String field){
    if(userData?.containsKey(field) == true){
      var value = userData?[field];
      if(value is String){
        return value;
      }
    }
    return null;
  }

  Future<Map<String,dynamic>?> fetchJournals() async {
    try{
      userJournals = userJournals ?? {};

      if(userJournals!.length < userData!['journals'].length){
        print("New Journals Added : Returning New List");
        
        for(int i = userJournals!.length; i < userData!["journals"].length; i++){

          DocumentSnapshot journalDoc = await _journals.doc(userData!["journals"][i]).get();
          Map<String, dynamic> journalData = journalDoc.data() as Map<String, dynamic>;

          userJournals!.addAll({
            journalDoc.id: {
              'title': journalData['title'],
              'content': journalData['content'],
              'date': journalData['date'],
            }
          });
        }

        return userJournals;
      }
      else{
        print("No New Journals Added : Returning Old List");
        return userJournals;
      }
    } catch(e){
      print("Fetching Journals Error");
      print(e);
      return userJournals;
    }
  }

  Future<void> addJournalEntry(String date, String title, String content)async{
    try{
      DocumentReference journalDoc = await _journals.add({
        'title': title,
        'content': content,
        'date': date
      });

      String journalId = journalDoc.id;
      userData!['journals'].add(journalId);

      String? userId = auth.currentUser?.uid;
      await _users.doc(userId).update({
        'journals': userData!['journals']
      });

      print("Journal Entry Added Successfully");

    }catch(e){
      print("Adding Journal Entry Error");
      print(e);
    }
  }

  String convertDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day-$month-$year';
  }
}

