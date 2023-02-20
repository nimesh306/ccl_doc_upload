import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class FolderSession {
  final storage = FlutterSecureStorage();

  Future saveFolderName(String key, String value) async {
    try {
      print('key=$key    , values=$value');
      await storage.write(key: key, value: value);
    } catch (e) {
      print('FlutterSecureStorage saving error==$e');
    }
  }

  //Get Saved LoginDetails
  Future<String> getFolderName(String key) async {
    var result = await storage.read(key: key);
    if (result?.length == 0) return '';
    return  result.toString();
  }


}
