class LoginRequest {
  String username;
  String password;
  String timestamp;
  String app_version;

  LoginRequest(
      {required this.username,
      required this.password,
      required this.timestamp,
      required this.app_version});

  // factory LoginRequest.fromJson(Map<String, dynamic> json) {
  //   return LoginRequest(
  //     username: json['username'],
  //     password: json['password'],
  //     timestamp: json['timestamp'],
  //     app_version: json['app_version'],
  //   );
  // }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'timestamp': timestamp,
        'app_version': app_version
      };
}
