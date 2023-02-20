import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_response.dart';

class LoginSession {
  final storage = FlutterSecureStorage();

  //Save LoginDetails
  Future saveLoginDetails(LoginResponse loginResponse) async {
    try {
      print(loginResponse.toString());
      await storage.write(key: "username", value: loginResponse.username);
      await storage.write(key: "roles", value: loginResponse.roles.toString());
      await storage.write(key: "tokenType", value: loginResponse.tokenType);
      await storage.write(key: "accessToken", value: loginResponse.accessToken);
      await storage.write(
          key: "expiresIn", value: loginResponse.expiresIn.toString());
      await storage.write(
          key: "refreshToken", value: loginResponse.refreshToken);
    } catch (e) {
      print('login session details savin error==$e');
    }
  }

  Future<String?> getUserAccessToken() async {
    var result = await storage.read(key: 'accessToken');
    return result;
  }

  //Get Saved LoginDetails
  Future<Map<String, dynamic>?> getLoginDetails() async {
    var result = await storage.readAll();
    if (result.length == 0) return null;
    return result;
  }

  //Clear Saved LoginDetails
  Future clear() {
    return storage.deleteAll();
  }
}
