import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataSession {
  final storage = FlutterSecureStorage();

  //Save LoginDetails
  Future saveUserData(String epfNo, String department, String branch) async {
    try {
      await storage.write(key: "epfNo", value: epfNo);
      await storage.write(key: "department", value: department);
      await storage.write(key: "branch", value: branch);
    } catch (e) {
      print('login session details savin error==$e');
    }
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
