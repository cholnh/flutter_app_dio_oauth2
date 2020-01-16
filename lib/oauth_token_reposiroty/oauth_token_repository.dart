import 'package:dio/dio.dart';
import 'package:flutter_app_dio_1/model/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dio/dio_core.dart';
import 'oauth_token_info.dart';

class OauthTokenRepository {
  Future<Token> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token _token = prefs.get('__oauth_token__') ?? await issueGuestToken();

    _token = isValid(accessToken: _token.accessToken)
      ? _token
      : _token.tokenMode == TokenMode.GUEST
        ? issueGuestToken()
        : refreshLoginToken(refreshToken: _token.refreshToken);

    return issueGuestToken();
  }


  isValid({String accessToken}) async {
    try {
      var res = await dio.post('/oauth/check_token',
          data: FormData.fromMap({
            'token': accessToken
          })
      );
      if(res != null && res.statusCode == 200) {
        return true;
      }
    } catch(e) {}
    return false;
  }

  issueGuestToken() async {
    try {
      var res = await dio.post('/oauth/token',
          options: Options(headers: {
            'Authorization': 'Basic ' + guestOauthTokenHeader
          }),
          data: FormData.fromMap({
            'grant_type': 'client_credentials'
          })
      );
      if(res != null && res.statusCode == 200) {
        return Token.fromJson(res.data);
      }
    } catch(e) {}
    return null;
  }

  issueLoginToken({String username, String password}) async {
    try {
      var res = await dio.post('/oauth/token',
          options: Options(headers: {
            'Authorization': 'Basic ' + loginOauthTokenHeader
          }),
          data: FormData.fromMap({
            'grant_type': 'password',
            'username': username,
            'password': password
          })
      );
      if(res != null && res.statusCode == 200) {
        return Token.fromJson(res.data)
          ..tokenMode = TokenMode.LOGIN;
      }
    } catch(e) {}
    return null;
  }

  refreshLoginToken({String refreshToken}) async {
    try {
      var res = await dio.post('/oauth/token',
          options: Options(headers: {
            'Authorization': 'Basic ' + loginOauthTokenHeader
          }),
          data: FormData.fromMap({
            'grant_type': 'refresh_token',
            'refresh_token': refreshToken
          })
      );
      if(res != null && res.statusCode == 200) {
        return Token.fromJson(res.data)
          ..tokenMode = TokenMode.LOGIN;
      }
    } catch(e) {}
    return null;
  }
}