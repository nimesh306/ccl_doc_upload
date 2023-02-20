// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/camera_screen.dart';
import 'ui/splash_screen.dart';

void main() async {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: SplashView(),
      ),
    ),
  );
}

// void main() {
//   runApp(RequestsInspector(
//     enabled: true,
//     child: MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: TakePictureScreen(),
//       ),
//     ),
//   ));
// }

// void main() => runApp(SplashView());

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}
