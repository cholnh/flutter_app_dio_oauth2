import 'package:flutter_app_dio_1/model/token.dart';

@deprecated
class LoginToken extends Token {
  final String refreshToken;

  LoginToken({accessToken, tokenType, expiresIn, scope, this.refreshToken}) : super(
      accessToken: accessToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      scope: scope);

  LoginToken.fromJson(Map<String, dynamic> json) :
        refreshToken = json['refresh_token'],
      super(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        scope: json['scope']);
}