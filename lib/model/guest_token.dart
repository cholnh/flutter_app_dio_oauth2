import 'package:flutter_app_dio_1/model/token.dart';

@deprecated
class GuestToken extends Token {
  GuestToken({accessToken, tokenType, expiresIn, scope}) : super(
      accessToken: accessToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      scope: scope);

  GuestToken.fromJson(Map<String, dynamic> json) : super(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      scope: json['scope']);
}