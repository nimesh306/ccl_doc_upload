// import 'dart:io';
//
// import 'package:google_sign_in/google_sign_in.dart' as signIn;
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as ppath;
//
// import '../../com_constants/value_constant.dart';
// import '../../model/folder_crete.dart';
// import '../../utils/common_functions.dart';
// import 'google_auth_client.dart';
// import 'secure_storage.dart';
//
// const _api_key = 'AIzaSyAlVO540gJIMghh1aPbh4v3u_3C24A4RlM';
// const _clientId =
//     '30914395303-mh05nlvgd515b785hpf1r9apnfsh19kc.apps.googleusercontent.com';
// var _scopes = [
//   'https://www.googleapis.com/auth/drive.file',
// ];
//
// class GoogleDrive {
//   final storage = SecureStorage();
//
//   void testGoogleDrive() async {
//     final googleSignIn = signIn.GoogleSignIn.standard(
//         scopes: ['https://www.googleapis.com/auth/drive.file']);
//     var account = await googleSignIn.signIn();
//     // final signIn.GoogleSignInAccount account =
//     print("User account $account");
//
//     final authHeaders = await account!.authHeaders;
//     final authenticateClient = GoogleAuthClient(authHeaders);
//     final driveApi = drive.DriveApi(authenticateClient);
//
//     final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
//     var media = new drive.Media(mediaStream, 2);
//     var driveFile = new drive.File();
//     driveFile.name = "hello_world.txt";
//     final result = await driveApi.files.create(driveFile, uploadMedia: media);
//     print("Upload result: $result");
//   }
//
//   Future<http.Client> getNewHttpClient() async {
//     final googleSignIn = signIn.GoogleSignIn.standard(
//         scopes: ['https://www.googleapis.com/auth/drive.file']);
//     var account = await googleSignIn.signIn();
//     // final signIn.GoogleSignInAccount account =
//     print("User account $account");
//
//     final authHeaders = await account!.authHeaders;
//     return GoogleAuthClient(authHeaders);
//   }
//
//   // Future<http.Client> getNewHttpClient() async {
//   //   //Get Credentialsflut
//   //   var credentials = await storage.getCredentials();
//   //   print('http____client____111111${credentials.toString()}');
//   //   if (credentials == null) {
//   //     print('http____client____222');
//   //     //Needs user authentication
//   //     var authClient =
//   //         await clientViaUserConsent(ClientId(_clientId), _scopes, (uri) {
//   //       launch(uri);
//   //     });
//   //     print('http____client____3333');
//   //     //Save Credentials
//   //     await storage.saveCredentials(authClient.credentials.accessToken,
//   //         authClient.credentials.refreshToken!);
//   //     return authClient;
//   //   } else {
//   //     print(credentials["type"]);
//   //     print(credentials["data"]);
//   //     print(credentials["expiry"]);
//   //     print(credentials["refreshToken"]);
//   //     print('http____client____4444');
//   //     //Already authenticated
//   //     return authenticatedClient(
//   //         http.Client(),
//   //         AccessCredentials(
//   //             AccessToken(credentials["type"], credentials["data"],
//   //                 DateTime.tryParse(credentials["expiry"])!),
//   //             credentials["refreshToken"],
//   //             _scopes));
//   //   }
//   // }
//
//   Future<String?> _getFolderId(drive.DriveApi driveApi) async {
//     final mimeType = "application/vnd.google-apps.folder";
//     String folderName = "ccl_docs";
//
//     try {
//       final found = await driveApi.files.list(
//         q: "mimeType = '$mimeType' and name = '$folderName'",
//         $fields: "files(id, name)",
//       );
//       final files = found.files;
//       if (files == null) {
//         print("Sign-in first Error");
//         return null;
//       }
//
//       // The folder already exists
//       if (files.isNotEmpty) {
//         return files.first.id;
//       }
//
//       // Create a folder
//       drive.File folder = drive.File();
//       folder.name = folderName;
//       folder.mimeType = mimeType;
//       final folderCreation = await driveApi.files.create(folder);
//       print("Folder ID: ${folderCreation.id}");
//
//       return folderCreation.id;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
//   //Upload File
//   Future uploadx(String folderBasePath) async {
//     try {
//       var folderName = FolderSession().getFolderName(kBaseFolderName);
//
//       var listSync = Directory(folderName as String).listSync();
//       for (var item in listSync) {
//         upload(item as File);
//       }
//     } catch (e) {
//       print('getting files... error===$e');
//     }
//   }
//
//   Future upload(File file) async {
//     try {
//       var client = await getNewHttpClient();
//
//       var driveApi = drive.DriveApi(client);
//
//       String? folderId = await _getFolderId(driveApi);
//
//       drive.File fileToUpload = drive.File();
//       fileToUpload.parents = [folderId.toString()];
//       fileToUpload.name = ppath.basename(file.absolute.path);
//       var response = await driveApi.files.create(
//         fileToUpload,
//         uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
//       );
//       print('google drive response====${response}');
//
//       String fileName = file.absolute.path;
//       final mimeType = "application/vnd.google-apps.folder";
//
//       final found = await driveApi.files.list(
//         q: "mimeType = '$mimeType' and name = '$fileName'",
//         $fields: "files(id, name)",
//       );
//       final files = found.files;
//
//       // The folder already exists
//       if (files!.isNotEmpty) {
//         CommonFunctions().deleteFile(file.path);
//       }
//     } catch (e) {
//       print('error========s$e');
//     }
//   }
//
//   uploadFileToGoogleDrive() async {
//     print('call.... uploadFileToGoogleDrive');
//     try {
//       print('call.... uploadFileToGoogleDrive1111');
//       var client = await getNewHttpClient();
//
//       print('call.... uploadFileToGoogleDrive2222');
//       var driveApi = drive.DriveApi(client);
//
//       print('call.... uploadFileToGoogleDrive333');
//       print(driveApi.about.toString());
//
//       print('call.... uploadFileToGoogleDrive4444');
//       // print(client.credentials.accessToken.toString());
//
//       final mimeType = "application/vnd.google-apps.folder";
//       String folderName = "personalDiaryBackup";
//
//       // Create a folder
//       drive.File folder = drive.File();
//       folder.name = folderName;
//       folder.mimeType = mimeType;
//       print('call.... uploadFileToGoogleDrive5555');
//       final folderCreation = await driveApi.files.create(folder);
//       print("Folder ID: ${folderCreation.id}");
//
//       // await driveApi.files
//       //     .list(
//       //   q: "mimeType = application/vnd.google-apps.folder and name='JAVA' ",
//       //   $fields: "files(id, name)",
//       // )
//       //     .then((list) {
//       //   print('sssssssss${list.files}');
//       // });
//     } catch (e) {
//       print(e);
//     }
//
//     // final Stream<List<int>> mediaStream =
//     //     Future.value([104, 105]).asStream().asBroadcastStream();
//     // var media = ga.Media(mediaStream, 2);
//     // var driveFile = ga.File();
//     // driveFile.name = "hello_world.txt";
//     // final result = await driveApi.files.create(
//     //   driveFile,
//     //   uploadMedia: media,
//     // );
//     //
//     // print("Upload result: $result");
//     // print("Upload result22==: ${result.size}");
//
//     // ga.File fileToUpload = ga.File();
//     // fileToUpload.name = p.basename(file.absolute.path);
//     //
//     // var response = await drive.files.create(
//     //   fileToUpload,
//     //   uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//     // );
//     // print('response======${response.size}');
//
//     // }
//     // } on Exception catch (e) {
//     //   print(e);
//     // }
//   }
//
//   // //Get Authenticated Http Client
//   Future<http.Client> getHttpClientd() async {
//     return clientViaApiKey('AIzaSyANlYiqSOaK5rhSzovDKoP6bfjKbLXrPVM');
//   }
//   //
//   // Future<AccessCredentials> obtainCredentials() async {
//   //   var accountCredentials =
//   //   ServiceAccountCredentials.fromJson(serviceAccountJson);
//   //
//   //   var client = http.Client();
//   //   AccessCredentials credentials =
//   //   await obtainAccessCredentialsViaServiceAccount(
//   //       accountCredentials, _scopes, client);
//   //
//   //   client.close();
//   //   return credentials;
//   // }
//   //
//   // Future<http.Client> obtainAuthenticatedClient() async {
//   //   // final accountCredentialsx =
//   //   // ServiceAccountCredentials.fromJson(serviceAccountJson);
//   //   //
//   //   var clientx = http.Client();
//   //   // AccessCredentials credentials =
//   //   // await obtainAccessCredentialsViaServiceAccount(
//   //   //     accountCredentialsx, _scopes, clientx);
//   //   //
//   //   // ServiceAcc
//   //   //
//   //   // clientx.close();
//   //
//   //   obtainAccessCredentialsViaServiceAccount(
//   //       serviceAccountJson, _scopes, clientx)
//   //       .then((value) => {
//   //     print('new client access token===' + value.accessToken.toString())
//   //   });
//   //
//   //   //
//   //   // final accountCredentials =
//   //   //     ServiceAccountCredentials.fromJson(serviceAccountJson);
//   //   //
//   //   // AuthClient client =
//   //   //     await clientViaServiceAccount(accountCredentials, _scopes);
//   //
//   //   return clientx; // Remember to close the client when you are finished with it.
//   // }
//   //
//   // Future<String?> _getFolderId(ga.DriveApi driveApi) async {
//   //   final mimeType = "application/vnd.google-apps.folder";
//   //   String folderName = "ccl";
//   //
//   //   try {
//   //     final found = await driveApi.files.list(
//   //       q: "mimeType = '$mimeType' and name = '$folderName'",
//   //       $fields: "files(id, name)",
//   //     );
//   //     final files = found.files;
//   //     if (files == null) {
//   //       print("Sign-in first Error");
//   //       return null;
//   //     }
//   //
//   //     // The folder already exists
//   //     if (files.isNotEmpty) {
//   //       return files.first.id;
//   //     }
//   //
//   //     // Create a folder
//   //     ga.File folder = ga.File();
//   //     folder.name = folderName;
//   //     folder.mimeType = mimeType;
//   //     final folderCreation = await driveApi.files.create(folder);
//   //     print("Folder ID: ${folderCreation.id}");
//   //
//   //     return folderCreation.id;
//   //   } catch (e) {
//   //     print(e);
//   //     return null;
//   //   }
//   // }
//
//   //
// }
