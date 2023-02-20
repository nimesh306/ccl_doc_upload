import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonFunctions {
  Future<int> deleteFile(String path) async {
    try {
      final file = await File(path);
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future deleteEmptyImageFolder(String folderPath) async {
    try {
      var listSync = Directory(folderPath).listSync();
      for (var item in listSync) {
        bool isEmptyFolder = await Directory(item.path).list().isEmpty;
        if (isEmptyFolder) {
          await Directory(item.path).delete();
        }
        print('Folder=${item.path}=====isEmpty==$isEmptyFolder');
      }
    } on Exception catch (e) {
      print('folder_creattion_error===$e');
    }
  }

  getPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
  }
}
