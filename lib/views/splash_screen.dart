import 'package:flutter/material.dart';

import '../services/splash_service.dart';

class SplaschScreen extends StatefulWidget {
  const SplaschScreen({super.key});

  @override
  State<SplaschScreen> createState() => _SplaschScreenState();
}

class _SplaschScreenState extends State<SplaschScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    splashScreen.isLogin(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset('assets/images/log.jpg'),
      ),
    );
  }
}
