import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../com_constants/value_constant.dart';
import '../model/folder_crete.dart';

class GoogleDrive {
  var _scopes = [
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.appdata',
    'https://www.googleapis.com/auth/drive.metadata'
  ];

  //Branch ->  date -> department -> epf -> timestamp

  Future<http.Client> getNewHttpClient() async {
    // Use service account credentials to obtain oauth credentials.
    var accountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "my-project1-376907",
      "private_key_id": "6b3cc362b83991dcfd6fcb4dc83d8364dcea97a8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2v+mCmhEW1aSW\nGUjknA+Hjdxw9AHa4KthlV2pRMnPBzfShDMc/EuJn191pAflpBI8rxR68995HmLi\nr13nMXuyi02qHL0T+q6EPXNoQbuNaHGjC/r1U7m9Kdmes3IFRqgpctUKbq67MbJt\nxd6oIaIqKjzGouaF5qrIuiyqWtQrHuWl5pfJXGBaACBbO12lLxQmCOlHvoC7/B6k\ndKlV7h5ad+0edBUKnFAbuLQNoxSfyghje9Q5fGtIYGIsdvJmHR9V3nYS4Yssf+Z0\nqfJ5+Mhni47Ed5S/PldB91M2wsvDK2tObhud/Fq9EhODm1zhlWGljhoO1xEqP/c8\n/8bByVCxAgMBAAECggEAOAPrF1USF+W0ZS2q4ifTusEI6LZiOyzSWz7lTpT/Jq4X\ntjc/U4shvDVVlUGKCiGYVXF03ZsSzJU7yi/moI7SU4/PZm0Yp58XDwGm9jXvvxBc\nhJWPftMDA7BoO/TU5jkaIlpIYsI6XLaG8o7MCM0GX9ZCesBD2JczkgM+3Zipn+17\nw26nU8AZVBGDtqYQs7MjOyzHSKCF5/eDFofAG5cFxmQ6306KsEUYJ+bJtzI2atZQ\nOi5uZL9SE1CbuBaHzxh0agfgEtAwiohVmROsJoFv/Fd2kUOCyOq1KZaOIYBGkKlw\nGFMnenYhECKX99uJXP4LEknS+IaUXZMPVAWc3PbY4QKBgQDjX2fRszBmm9gbliwJ\nf7lQdyw/LvWXOLgb3HmTDzuYXpVhKXYkf7QguzWfv7IZDdEcKOYeUYkoORr5vylr\nECUfWvn/3vAdJ1hcezAvLCPeC+zFDfcNFJ/rmGrIY4JaNyCitbX4K81DSlD9U+mD\n1qOy6NcxsvDqb/w3otA0gtkBdwKBgQDNwjvBrAw0NbWHrF1uh30EPWPSGEcLdNJL\nzadm+qcWYU0R4EcdhLDR7QO4rQMO+oOjvC6hX5GBa5rbAvBYrB1E+C/hA4NHjL0Z\nmyeGAOOdneVNHndNf2xjCyvLQf3EN7pvrCaN6efIWygogZ52JKS1XBqmrB1y1RXO\nzgQg8esJFwKBgB8FDBfq12aYSmJxGW7uUuzsZUf1cyH/Zfa/HIL4qAvAk6aeznRq\nS7vPbqBtubF7VhT+a26ldw3axJhgARmPKVFeyw6ibqW7kW2EjO1Sm04W2GWF4zeQ\nocS1lZPjJ4yBSt2H5tyFtUpB4Ey/XvNSnCCzbXBlVkLVplY8yyTu2QY/AoGBALe6\ncNGHZ35XVzlG2EcSBLf8eV3o/8djEUVO5eQ2fWymhcMomVfqXFmXYnNNSiXd3B4g\nsyK1y5/dDfHytdr4FUq4s0ghcuA488IhoTEvKhBcJZyvT6iL16S5HOnqi0bi3D9L\nYUHnU2i8vScuVuj333tyOvoJRmJ7k3WO0HD6k/0RAoGBAJExx8wVnf50Ci5cC1u7\ngJEzCqYY4BrwQsfkTMefIcog/UAhqy+I4uUZuyGWF4qs8qV4dBfpJXJAcvImX8Ww\n95iEB5wxwpoEAxgZv7qkdNiOBx0JNK5iw9u7djMIYXfQUY/W5AFPmuhhlNTFhro6\nu78kbzUpONdRYm9YgBXKjRwH\n-----END PRIVATE KEY-----\n",
      "client_email":
          "ccl-nimz-tewst@my-project1-376907.iam.gserviceaccount.com",
      "client_id": "102315461176034089724",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/ccl-nimz-tewst%40my-project1-376907.iam.gserviceaccount.com"
    });

    var client = http.Client();
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(
            accountCredentials, _scopes, client);

    AuthClient authClient = authenticatedClient(
        client,
        AccessCredentials(
            AccessToken(credentials.accessToken.type,
                credentials.accessToken.data, credentials.accessToken.expiry),
            credentials.refreshToken,
            _scopes));

    // client.close();
    return authClient;
  }

  Future<String?> _createNewFolder(
      drive.DriveApi driveApi, String newFolderName) async {
    try {
      String baseFolderId = '';
      baseFolderId = (await _getBaseGoogleFolder(driveApi))!;

      final mimeType = "application/vnd.google-apps.folder";

      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$newFolderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        print("file null");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        print('folder id=====${files.first.id}');
        return files.first.id;
      }

      // Create a folder
      drive.File folder = drive.File();
      folder.parents = [baseFolderId];
      folder.name = newFolderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _getBaseGoogleFolder(drive.DriveApi driveApi) async {
    // final mimeType = "application/vnd.google-apps.folder";
    // String folderName = "ccl_images";
    //
    // try {
    //   final found = await driveApi.files.list(
    //     q: "mimeType = '$mimeType' and name = '$folderName'",
    //     $fields: "files(id, name)",
    //   );
    //   final files = found.files;
    //   if (files == null) {
    //     print("file null");
    //     return null;
    //   }
    //
    //   // The folder already exists
    //   if (files.isNotEmpty) {
    //     print('folder id=====${files.length}');
    //     print('folder id=====${files.first.name}');
    //     print('folder id=====${files.first.id}');
    //     return files.first.id;
    //   }
    //
    //   // Create a folder
    //   drive.File folder = drive.File();
    //   folder.name = folderName;
    //   folder.mimeType = mimeType;
    //   final folderCreation = await driveApi.files.create(folder);
    //   print("base folder--Folder ID: ${folderCreation.id}");
    //
    //   return folderCreation.id;
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
    return '1pBLdLK20Ygg6E0vZHtLLY664xBHJtq4Q';
  }

  Future<String?> getFolderIdByName(
      drive.DriveApi driveApi, String folderName) async {
    final mimeType = "application/vnd.google-apps.folder";
    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        print("file null");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        // print('folder id=====${files.length}');
        // print('folder id=====${files.first.name}');
        // print('folder id=====${files.first.id}');
        return files.first.id;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Upload File
  Future allImagesUpload(String folderBasePath) async {
    try {
      print('folderBasePath===$folderBasePath');
      print('folderBasePath===${folderBasePath.split('/').last}');
      var folderName = await FolderSession().getFolderName(kBaseFolderName);
      print('folderName===$folderName');

      String newFolderName = folderBasePath.split('/').last;
      print('newFolderName======$newFolderName');

      var client = await getNewHttpClient();
      var driveApi = drive.DriveApi(client);
      String? folderId = await _createNewFolder(driveApi, newFolderName);

      var listSync = Directory(folderBasePath).listSync();
      for (var item in listSync) {
        googleDriveUpload(item as File, folderId!, driveApi);
      }
    } catch (e) {
      print('getting files... error===$e');
    }
  }

  Future googleDriveUpload(
      File file, String folderId, drive.DriveApi driveApi) async {
    try {
      Map<String, String> fileProperties = Map();
      fileProperties.putIfAbsent("createdUser", () => 'NimeshDu22');

      drive.File fileToUpload = drive.File();
      fileToUpload.parents = [folderId];
      fileToUpload.name = p.basename(file.absolute.path);
      fileToUpload.createdTime = DateTime.now();
      fileToUpload.properties = fileProperties;
      var response = await driveApi.files.create(
        fileToUpload,
        uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
      );
      print('google drive response====${response}');

      String fileName = file.absolute.path;
      const mimeType = "application/vnd.google-apps.folder";

      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$fileName'",
        $fields: "files(id, name)",
      );
      final uploadedFile = found.files;

      if (uploadedFile!.isNotEmpty) {
        await file.delete();
        // CommonFunctions().deleteFile(uploadedFile.first.name.toString());
      }
    } catch (e) {
      print('error========s$e');
    }
  }

  Future<List<drive.File>?> googleDriveImgesNamesList(
      drive.DriveApi driveApi, String folderName) async {
    try {
      String folderId = '1';
      folderId = (await getFolderIdByName(driveApi, folderName))!;

      String query = "parents in '$folderId'";
      // String query = "parents in 'ccl_images'";
      final found = await driveApi.files.list(
        q: query,
        $fields: "files(id, name, createdTime)",
      );
      return found.files;
    } catch (e) {
      print(e);
    }
  }

// void _uploadFile() async {
//   File file = File(
//       '/data/user/0/com.example.gtest.nimz.h_test/cache/file_picker/IMG_20230208_115104.jpg');
//
//   var client = await getNewHttpClient();
//
//   var driveApi = drive.DriveApi(client);
//
//   drive.File fileToUpload = drive.File();
//   fileToUpload.parents = ['1pBLdLK20Ygg6E0vZHtLLY664xBHJtq4Q'];
//   fileToUpload.name = p.basename(file.absolute.path);
//   var response = driveApi.files.create(
//     fileToUpload,
//     uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
//   );
//   final result = await response.then((value) => value.id);
//   print(result);
// }
}
