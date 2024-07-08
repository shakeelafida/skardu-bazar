import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skardubazar/utils/flutter_toast.dart';

import '../../auth/login_screen.dart';
import '../../services/session_manager.dart';

class ProfileScreen extends StatelessWidget {
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
    // Fetch user information when the screen is built
    sessionController.fetchUserInfo(sessionController.userId.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Profile'),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _handleLogout(context);
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(sessionController.userName ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(sessionController.userEmail ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Phone'),
            subtitle: Text(sessionController.phoneNumber ?? ''),
          ),
        ],
      ),
    );
  }
}
