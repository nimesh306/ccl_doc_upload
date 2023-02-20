import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'login_screen.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: const LoginScreen(),
      // title: new Text('Ccl',textScaleFactor: 2,),
      image: Image.asset("images/cclogo.png"),
      photoSize: 100.0,
      loaderColor: Colors.redAccent,
    );
  }
}
