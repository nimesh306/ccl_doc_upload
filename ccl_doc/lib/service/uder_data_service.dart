import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/login_session.dart';
import '../model/user_data_session.dart';
import '../ui/loading_indicator_dialog.dart';

class UserDataService {
  final String loginURL = 'http://116.12.90.20/cc-switch/api/offline/user-info';

  Future<int> getUserData(String userName, BuildContext buildContext) async {
    try {
      var accessToken = LoginSession().getUserAccessToken();

      http.Response res = await http.post(
        Uri.parse(loginURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'app_version': '16',
          'mac_address': 'AE4706E5C718',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'processCode': '050165',
          'mti': '0300',
          'format': 'JSON',
          'userId': userName
        }),
      );

      print('userDataService===' + res.statusCode.toString());
      print('userDataService===' + res.request.toString());

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        print(body);

        UserDataSession()
            .saveUserData(body['epf_no'], body['department'], body['branch']);
        print('userDataService service call is done.');
        LoadingIndicatorDialog().dismiss();

        return res.statusCode;
      } else {
        return res.statusCode;
      }
    } catch (e) {
      print('userDataService api call Error====$e');
      return 500;
    }
  }
}
