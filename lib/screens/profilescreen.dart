import 'package:flutter/material.dart';
import 'package:journal_app/services/auth.dart';

class ProfileScreen extends StatefulWidget {
  final AuthMethods auth;
  const ProfileScreen({super.key, required this.auth});

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
    String gConnected = widget.auth.fetchField("google") ?? "Connect with Google";
    if (gConnected == "") {
      gConnected = "Connect with Google";
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
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            // 2nd Half
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality for Sync Data button
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Use a different color for Sync Data
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    icon: Icon(Icons.sync),
                    label: Text('Sync Data'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add functionality for Connect with Google button
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Use a different color for Connect with Google
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    icon: Icon(Icons.g_mobiledata),
                    label: Text(gConnected),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.auth.logout();
                      Navigator.pop(context);
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
}
