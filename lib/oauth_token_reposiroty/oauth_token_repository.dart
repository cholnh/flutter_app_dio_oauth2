import 'package:dio/dio.dart';
import 'package:flutter_app_dio_1/model/guest_token.dart';
import 'package:flutter_app_dio_1/model/login_token.dart';
import 'package:flutter_app_dio_1/model/token.dart';
import '../dio/dio_core.dart';
import 'oauth_token_info.dart';

class OauthTokenRepository {
  Future<Token> getToken() {
    return getGuestToken();
  }

  getGuestToken() async {
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
        return GuestToken.fromJson(res.data);
      }
    } catch(e) {}
    return null;
  }

  getLoginToken({String username, String password}) async {
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
        return LoginToken.fromJson(res.data);
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
        return LoginToken.fromJson(res.data);
      }
    } catch(e) {}
    return null;
  }
}