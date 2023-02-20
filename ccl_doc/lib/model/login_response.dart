class LoginResponse {
  String username = '';
  var roles = [];
  String tokenType = '';
  String accessToken = '';
  int expiresIn = 0;
  String refreshToken = '';

  LoginResponse({
    required this.username,
    required this.roles,
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });

  LoginResponse.fromJson(dynamic json) {
    username = json['username'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['roles'] = roles;
    map['token_type'] = tokenType;
    map['access_token'] = accessToken;
    map['expires_in'] = expiresIn;
    map['refresh_token'] = refreshToken;
    return map;
  }

  @override
  String toString() {
    return 'LoginResponse{username: $username, roles: $roles, tokenType: $tokenType, accessToken: $accessToken, expiresIn: $expiresIn, refreshToken: $refreshToken}';
  }
}
