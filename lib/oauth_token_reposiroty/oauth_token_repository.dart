import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app_dio_1/model/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dio/dio_core.dart';
import 'oauth_token_info.dart';

class OauthTokenRepository {

  Future<Token> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Token _token = prefs.get('__oauth_token__') ?? await issueGuestToken();
      // TODO: _token = innerDB.getObject('token');

      _token = await isValid(accessToken: _token.accessToken)
          ? _token
          : _token.tokenMode == TokenMode.GUEST
            ? await issueGuestToken()
            : await refreshLoginToken(refreshToken: _token.refreshToken);

      // prefs.setString('__oauth_token__', _token.accessToken);
      // TODO: innerDB.setObject('token', _token);
      return _token;
    } catch(e) {
      return await issueGuestToken();
    }
  }


  Future<bool> isValid({String accessToken}) async {
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

  Future<Token> issueGuestToken() async {
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
    return null;
  }

  Future<Token> issueLoginToken({String username, String password}) async {
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
    return null;
  }

  Future<Token> refreshLoginToken({String refreshToken}) async {
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
    return null;
  }

  Future<String> serverHealthCheck() async {
    var res = await dio.get('/application/healthCheck');
    if(res != null && res.statusCode == 200) {
      return jsonDecode(res.data)['status'];
    }
    return null;
  }
}