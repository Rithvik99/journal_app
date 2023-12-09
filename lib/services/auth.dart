import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
        'profilePic': '',
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

  Future<void> addJournalEntry(String title, String content, String date)async{
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

  Future<bool> signInWithGoogle() async {
    try{
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(forceCodeForRefreshToken: true).signIn();

      if(googleUser == null){
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      UserCredential result = await auth.signInWithCredential(credential);
      User? userDeatils = result.user;

      DocumentSnapshot userDoc = await _users.doc(userDeatils?.uid).get();

      String gmail = userDeatils?.email ?? '';
      String? username = userDeatils?.displayName ?? '';

      if (userDoc.exists) {
        print('User Already Exists');
        await _users.doc(userDeatils?.uid).update({
          'google': gmail,
          'profilePic': userDeatils?.photoURL,
        });
      } else {
        await _users.doc(userDeatils?.uid).set({
          'username': username,
          'email': gmail,
          'journals': [],
          'google': gmail,
          'facebook': '',
          'profilePic': userDeatils?.photoURL,
          'date': convertDate(DateTime.now())
        });
        print('User Added to Db');
      }

      userDoc = await _users.doc(userDeatils?.uid).get();
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

  // Linking Google Account to Already Existing Account
  Future<void> linkAccountWithGoogle() async{
    try{
      await GoogleSignIn().signOut();
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn(forceCodeForRefreshToken: true).signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      print("Google Credential Created");

      User? user = auth.currentUser;
      await user!.linkWithCredential(googleCredential);

      print("Google Account Linked");

      await _users.doc(user.uid).update({
        'google': googleSignInAccount.email
      });

      userData!['google'] = googleSignInAccount.email;
      print("Account Linked to Db");
    } catch(e){
      print("Linking Google Account Error");
      print(e);
    }
  }

  Future<void> linkAccountWithFacebook() async {
    try{await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.cancelled) {
        print('Facebook sign-in canceled.');
        return;
      }

      final AccessToken accessToken = result.accessToken!;
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(accessToken.token);

      print("Fetched Credentials");

      // Get the current user
      User? user = auth.currentUser;
      await user?.linkWithCredential(facebookCredential);

      //Get The Gmail
       final graphResponse = await http.get(
          Uri.parse('https://graph.facebook.com/v14.0/me?fields=id,name,email'),
          headers: {'Authorization': 'Bearer ${accessToken.token}'},
        );
        final Map<String, dynamic> facebookUserData = json.decode(graphResponse.body);
        String facebookEmail = facebookUserData['email'] ?? '';


      // Modify fields
      await _users.doc(user?.uid).update({
        'facebook': facebookEmail,
      });

      userData!["facebook"] = facebookEmail;

      print('Account linked with Facebook successfully!');
    } catch (e) {
      print('Error linking account with Facebook: $e');
    }
  }

  Future<bool> oauth_facebook() async {
    try {
      print("called facebook auth");
      await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final graphResponse = await http.get(
          // Uri.parse('https://graph.facebook.com/v14.0/me?fields=id,name,email,picture'),
          Uri.parse('https://graph.facebook.com/v2.12/me?fields=id,name,email,picture.width(800).height(800)'),
          headers: {'Authorization': 'Bearer ${accessToken.token}'},
        );
        final Map<String, dynamic> userData2 = json.decode(graphResponse.body);
        print("hii there");
        print(userData2);
        String facebookName = userData2['name'] ?? '';
        String facebookEmail = userData2['email'] ?? '';
        // Extract profile picture URL
        String profilePicUrl = '';
        if (userData2.containsKey('picture') &&
            userData2['picture'] != null &&
            userData2['picture'].containsKey('data') &&
            userData2['picture']['data'] != null &&
            userData2['picture']['data'].containsKey('url')) {
          profilePicUrl = userData2['picture']['data']['url'];
        }
        print("Pic URL");
        print(profilePicUrl);
        final AuthCredential creds =
        FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential auth2 = await auth.signInWithCredential(creds);
        DocumentSnapshot userDoc =
            await _users.doc(auth2.user?.uid).get();

        if (userDoc.exists) {
          print('User Already Exist: Updating Only Facebook');
          await _users.doc(auth2.user?.uid).update({
            'facebook': facebookEmail,
          });
        } else {
          await _users.doc(auth2.user?.uid).set({
            "username": facebookName,
            'email': '',
            'journals': [],
            'google': '',
            'facebook': facebookEmail,
            'profilePic': '',
            'date': convertDate(DateTime.now())
          });
        }

        userDoc = await _users.doc(auth2.user?.uid).get();
        print("User Doc Fetched");

        if (userDoc.exists) {
          userData = userDoc.data() as Map<String, dynamic>;
          print("User Data Stored");
        }

        return true;
      } else if (result.status == LoginStatus.cancelled) {
        print("Facebook login cancelled");
        return false;
      } else {
        print("Facebook login failed: ${result.message}");
        return false;
      }
    } catch (e) {
      print("Facebook login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    userData = null;
    userJournals = null;
  }

  String convertDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day-$month-$year';
  }
}

