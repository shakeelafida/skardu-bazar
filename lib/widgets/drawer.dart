
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skardubazar/auth/login_screen.dart';
import 'package:skardubazar/services/session_manager.dart';
import 'package:skardubazar/utils/flutter_toast.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final SessionController sessionController = SessionController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _handleLogout(BuildContext context) {
    _auth.signOut().then((value) {
      SessionController().userId = '';
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }).catchError((error) {
      Utils().toastMessage(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Add your navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _handleLogout(context);
                // Add your logout logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}