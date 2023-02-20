import 'package:flutter/material.dart';

import '../com_constants/styles_constant.dart';
import '../service/login_service.dart';
import '../utils/common_functions.dart';
import '../utils/common_ui.dart';
import 'home_screen.dart';
import 'loading_indicator_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

enum DeviceOwnership { company, own }

class _LoginScreen extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DeviceOwnership? _deviceOwnership = DeviceOwnership.own;

  @override
  void initState() {
    CommonFunctions().getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/cclogo.png"),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: kTextFieldBorderStyle,
              child: TextFormField(
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: kTextFieldBorderStyle,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.remove_red_eye),
                  labelText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Text("Ownership : "),
                  Radio(
                      value: DeviceOwnership.company,
                      groupValue: _deviceOwnership,
                      onChanged: (DeviceOwnership? value) {
                        setState(() {
                          _deviceOwnership = value;
                        });
                      }),
                  const Text("Company"),
                  Radio(
                      value: DeviceOwnership.own,
                      groupValue: _deviceOwnership,
                      onChanged: (DeviceOwnership? value) {
                        setState(() {
                          _deviceOwnership = value;
                        });
                      }),
                  const Text("Own"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                fixedSize: const Size(300, 25),
                side: const BorderSide(
                  width: 6,
                  color: Colors.red,
                  style: BorderStyle.solid,
                ),
              ),
              // onPressed: () => {
              //   createLogin(
              //       userNameController.text, passwordController.text, context)
              // },
              onPressed: () => {createLogin('samithase', 'SAMI@123', context)},
              child: const Text(
                'LOGIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createLogin(String userName, password, BuildContext buildContext) async {
    LoadingIndicatorDialog().show(buildContext);
    print('Login response calling11111.....');

    if (userName.trim().isNotEmpty || password.trim().isNotEmpty) {
      int serverResponse =
          await LoginService().login(userName, password, buildContext);
      print('login response ==$serverResponse');

      _loginResponseCreate(serverResponse, buildContext);
    } else {
      CommonUI().showFailureAlert(
          buildContext, "Please enter correct username or password");
    }
  }

  _loginResponseCreate(int statusCode, BuildContext buildContext) {
    if (statusCode == 200) {
      print('Login response===============' + statusCode.toString());
      Navigator.of(buildContext)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (statusCode == 401) {
      CommonUI().showFailureAlert(
          buildContext, "User Name Or Password Invalid. \n Please Try Again..");
      Navigator.of(buildContext)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (statusCode == 515) {
      CommonUI()
          .showFailureAlert(buildContext, "Please Register Your Mobile..");
    } else if (statusCode == 404) {
      CommonUI().showFailureAlert(
          buildContext, "Server Error. \n Please Try Again..");
    } else if (statusCode == 500) {
      CommonUI().showFailureAlert(
          buildContext, "Network Failure, Please Try Again..");
    } else {
      CommonUI().showFailureAlert(
          buildContext, "Network Failure, Please Try Again..");
    }
  }
}
