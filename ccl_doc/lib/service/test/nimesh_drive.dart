// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
//
// class GoogleDrive {
//   final storage = SecureStorage();
//
//   const _api_key = 'AIzaSyAlVO540gJIMghh1aPbh4v3u_3C24A4RlM';
//   const _clientId =
//       '30914395303-mh05nlvgd515b785hpf1r9apnfsh19kc.apps.googleusercontent.com';
//   var _scopes = [
//     'https://www.googleapis.com/auth/drive.file',
//   ];
//
//   Future<http.Client> getHttpClient() async {
//     //Get Credentialsflut
//     var credentials = await storage.getCredentials();
//     if (credentials == null) {
//       //Needs user authentication
//       var authClient =
//           await clientViaUserConsent(ClientId(_clientId), _scopes, (url) {
//         //Open Url in Browser
//         launch(url);
//       });
//       //Save Credentials
//       await storage.saveCredentials(authClient.credentials.accessToken,
//           authClient.credentials.refreshToken!);
//       return authClient;
//     } else {
//       print(credentials["expiry"]);
//       //Already authenticated
//       return authenticatedClient(
//           http.Client(),
//           AccessCredentials(
//               AccessToken(credentials["type"], credentials["data"],
//                   DateTime.tryParse(credentials["expiry"])!),
//               credentials["refreshToken"],
//               _scopes));
//     }
//   }
// }
