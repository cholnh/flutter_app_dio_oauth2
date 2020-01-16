import 'package:flutter/cupertino.dart';

enum TokenMode { GUEST, LOGIN }

class Token {
  String accessToken;
  String tokenType;
  int expiresIn;
  String scope;
  String refreshToken;
  TokenMode tokenMode;

  Token({
    @required this.accessToken,
    @required this.tokenType,
    @required this.expiresIn,
    @required this.scope,
    @required this.refreshToken,
    tokenMode = TokenMode.GUEST});

  Token.fromJson(Map<String, dynamic> json) :
      tokenMode = TokenMode.GUEST,
      accessToken = json['access_token'],
      tokenType = json['token_type'],
      expiresIn = json['expires_in'],
      scope = json['scope'],
      refreshToken = json['refresh_token'];

  @override
  String toString() {
    return 'Token{accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn, scope: $scope, refreshToken: $refreshToken, tokenMode: $tokenMode}';
  }
}