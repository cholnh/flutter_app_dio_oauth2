import 'package:flutter/cupertino.dart';
import 'package:flutter_app_dio_1/dio/dio_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    @required this.tokenMode});

  Token.fromJson(Map<String, dynamic> json) :
    tokenMode = TokenMode.GUEST,
    accessToken = json['access_token'],
    tokenType = json['token_type'],
    expiresIn = json['expires_in'],
    scope = json['scope'],
    refreshToken = json['refresh_token'];

  static Future<Token> loadFromDisk() async {
    try {
      String accessToken, tokenType, scope, refreshToken;
      int expiresIn;
      TokenMode tokenMode;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String strTokenMode = prefs.get('__oauth_tokenMode__');
      assert(strTokenMode != null);

      if(strTokenMode == 'guest') {
        tokenMode = TokenMode.GUEST;
      } else if(strTokenMode == 'login') {
        tokenMode = TokenMode.LOGIN;
        refreshToken = prefs.get('__oauth_refreshToken__');
        assert(refreshToken != null);
      } else {
        assert(false);
      }

      accessToken = prefs.get('__oauth_accessToken__');
      assert(accessToken != null);

      tokenType = prefs.get('__oauth_tokenType__');
      assert(tokenType != null);

      expiresIn = prefs.get('__oauth_expiresIn__');
      assert(expiresIn != null);

      scope = prefs.get('__oauth_scope__');
      assert(scope != null);

      return Token(
          accessToken: accessToken,
          tokenType: tokenType,
          expiresIn: expiresIn,
          scope: scope,
          refreshToken: refreshToken,
          tokenMode: tokenMode);
    } catch (e) {}
    return null;
  }

  saveToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(tokenMode == TokenMode.GUEST) {
      prefs.setString('__oauth_tokenMode__', 'guest');
    } else if(tokenMode == TokenMode.LOGIN) {
      prefs.setString('__oauth_tokenMode__', 'login');
      prefs.setString('__oauth_refreshToken__', refreshToken);
    }

    prefs.setString('__oauth_accessToken__', accessToken);
    prefs.setString('__oauth_tokenType__', tokenType);
    prefs.setInt('__oauth_expiresIn__', expiresIn);
    prefs.setString('__oauth_scope__', scope);
    return this;
  }

  saveToDioHeader() {
    DioCore().addResourceHeader({
      'Authorization':'Bearer ' + accessToken
    }); // interceptor header 추가
    return this;
  }

  @override
  String toString() {
    return 'Token{accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn, scope: $scope, refreshToken: $refreshToken, tokenMode: $tokenMode}';
  }
}