import 'package:flutter/material.dart';
import 'package:journal_app/screens/loginscreen.dart';
import 'package:journal_app/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  final AuthMethods auth;
  final String type;
  const ProfileScreen({super.key, required this.auth, required this.type});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    String name = widget.auth.fetchField("username") ?? "";
    String date = widget.auth.fetchField("date") ?? "";
    String uriI = widget.auth.fetchField("profilePic") ?? "";
    if (uriI == "") {
      uriI =
          "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png";
    }
    String gConnected = widget.auth.fetchField("google") ?? "Connect to Google";
    if (gConnected == "") {
      gConnected = "Connect to Google";
    }

    String fConnected = widget.auth.fetchField("facebook") ?? "Connect to Facebook";
    if (fConnected == "") {
      fConnected = "Connect to Facebook";
    }

    String eConnected = widget.auth.fetchField("email") ?? "Connect to Email";
    if (eConnected == "") {
      eConnected = "Connect to Email";
    }

    googleConnect() async {
      if(gConnected == "Connect to Google"){
        try{
          await widget.auth.linkAccountWithGoogle();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Connected Successfully"),
            ),
          );
          setState(() {
          });
        } catch(e){
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error Connecting"),
            ),
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account already connected"),
          ),
        );
      }
    }

    facebookConnect() async {
      if(fConnected == "Connect to Facebook"){
        try{
          await widget.auth.linkAccountWithFacebook();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Connected Successfully"),
            ),
          );
        } catch(e){
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error Connecting"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account already Connected"),
          ),
        );
      }
    }

    emailConnect() async {
      if(eConnected == "Connect to Email"){
        _showPopup(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account already Connected"),
          ),
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1st Half
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(uriI),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Joining Date: $date',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Add text inside a container with black background to show the type of login
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Center(
                      child: Text(
                        "Logged in via ${widget.type}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            // 2nd Half
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      emailConnect();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Use a different color for Sync Data
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    icon: Icon(Icons.email),
                    label: Text(eConnected),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      googleConnect();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Use a different color for Connect with Google
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    icon: const Icon(Icons.g_mobiledata),
                    label: Text(gConnected),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      facebookConnect();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Use a different color for Connect with Google
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    icon: Icon(Icons.facebook),
                    label: Text(fConnected),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () {
                      widget.auth.logout();
                      // Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Use a different color for Log Out
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Log Out'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    String email = "";
    String password = "";

    connectEmail() async {
      try{
        await widget.auth.linkAccountWithEmailPassword(email, password);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Connected Successfully"),
          ),
        );
      } catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error Connecting"),
          ),
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/logo.png", // Replace with the path to your app logo
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Add Email and Password',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    connectEmail();
                    print('Email: $email, Password: $password');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
