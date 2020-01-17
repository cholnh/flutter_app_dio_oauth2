import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_dio_1/contatnt.dart' as g;
import 'package:flutter_app_dio_1/model/token.dart';

import '../dio/dio_core.dart';

class OauthTokenRepository {

  Future<Token> getToken() async {
    try {
      Token _token =
          await Token().loadFromDisk() // shared preference 로드
          ?? await issueGuestToken();

      _token = await isValid(accessToken: _token.accessToken)
          ? _token
          : _token.tokenMode == TokenMode.GUEST
            ? await issueGuestToken()
            : await refreshLoginToken(refreshToken: _token.refreshToken)
      ..saveToDisk(); // shared preference 저장

      DioCore().addResourceHeader({
        'Authorization':'Bearer '+_token.accessToken
      }); // interceptor header 추가

      return _token;
    } catch(e) {  // all error ->
      return await issueGuestToken(); // guest token 발급
    }
  }

  @visibleForTesting
  Future<bool> isValid({String accessToken}) async {
    try {
      var res = await DioCore().oauth.post('/oauth/check_token',
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
    var res = await DioCore().oauth.post('/oauth/token',
        options: Options(headers: {
          'Authorization': 'Basic ' + g.guestOauthTokenHeader
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
    var res = await DioCore().oauth.post('/oauth/token',
        options: Options(headers: {
          'Authorization': 'Basic ' + g.loginOauthTokenHeader
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
    var res = await DioCore().oauth.post('/oauth/token',
        options: Options(headers: {
          'Authorization': 'Basic ' + g.loginOauthTokenHeader
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
    var res = await DioCore().oauth.get('/application/healthCheck');
    if(res != null && res.statusCode == 200) {
      return jsonDecode(res.data)['status'];
    }
    return null;
  }
}