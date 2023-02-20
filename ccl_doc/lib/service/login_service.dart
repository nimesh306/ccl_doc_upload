import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/login_response.dart';
import '../model/login_session.dart';
import '../ui/loading_indicator_dialog.dart';
import 'uder_data_service.dart';

class LoginService {
  final String loginURL = 'http://116.12.90.20/cc-switch/api/login';

  Future<int> login(
      String userName, password, BuildContext buildContext) async {
    try {
      http.Response res = await http.post(
        Uri.parse(loginURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'app_version': '16',
          'mac_address': 'AE4706E5C718',
        },
        body: jsonEncode({
          'username': userName,
          'password': password,
          'timestamp': '',
          'app_version': '16'
        }),
      );

      print(res.statusCode);

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        print(body);
        var loginResponse = LoginResponse(
            username: body['username'],
            roles: body['roles'],
            tokenType: body['token_type'],
            accessToken: body['access_token'],
            expiresIn: body['expires_in'],
            refreshToken: body['refresh_token']);

        LoginSession().saveLoginDetails(loginResponse);
        print('login service call is done.');

        UserDataService().getUserData(body['username'], buildContext);

        LoadingIndicatorDialog().dismiss();

        // int statusCode = res.statusCode;
        //
        // if (statusCode == 200) {
        //   LoadingIndicatorDialog().dismiss();
        //   print('Login response===============' + statusCode.toString());
        //   Navigator.of(buildContext)
        //       .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        // } else if (statusCode == 401) {
        //   LoadingIndicatorDialog().dismiss();
        //   CommonUI().showFailureAlert(buildContext,
        //       "User Name Or Password Invalid. \n Please Try Again..");
        // } else if (statusCode == 515) {
        //   LoadingIndicatorDialog().dismiss();
        //   CommonUI()
        //       .showFailureAlert(buildContext, "Please Register Your Mobile..");
        // } else if (statusCode == 404) {
        //   LoadingIndicatorDialog().dismiss();
        //   CommonUI().showFailureAlert(
        //       buildContext, "Server Error. \n Please Try Again..");
        // } else if (statusCode == 500) {
        //   LoadingIndicatorDialog().dismiss();
        //   CommonUI().showFailureAlert(
        //       buildContext, "Network Failure, Please Try Again..");
        // } else {
        //   LoadingIndicatorDialog().dismiss();
        //   CommonUI().showFailureAlert(
        //       buildContext, "Network Failure, Please Try Again..");
        // }
        return res.statusCode;
      } else {
        LoadingIndicatorDialog().dismiss();

        return res.statusCode;
      }
    } catch (e) {
      LoadingIndicatorDialog().dismiss();

      print('login api call Error====$e');
      return 500;
    }
  }
}
