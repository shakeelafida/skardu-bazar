import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skardubazar/auth/login_screen.dart';
import 'package:skardubazar/services/session_manager.dart';
import 'package:skardubazar/views/home_page.dart';

import '../../utils/cus_navigator.dart';
import '../views/New/home.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      SessionController().userId = user!.uid.toString();
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }
}
