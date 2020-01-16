import 'package:flutter_app_dio_1/model/guest_token.dart';
import 'package:flutter_app_dio_1/model/login_token.dart';
import 'package:flutter_app_dio_1/oauth_token_reposiroty/oauth_token_repository.dart';
import 'package:flutter_app_dio_1/model/token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  OauthTokenRepository oauthTokenRepository = OauthTokenRepository();

  test('Oauth Token Repository Test - guest token', () async {
    // Given
    GuestToken guestToken;

    // When
    guestToken = await oauthTokenRepository.getGuestToken();

    // Then
    expect(guestToken.accessToken, 'f03be1dd-37c4-4412-9090-1b4bd7224a6a',
        reason: '토큰 기간 만료에 따른 토큰 변경');
  });

  test('Oauth Token Repository Test - login token', () async {
    // Given
    LoginToken loginToken;

    // When
    loginToken = await oauthTokenRepository.getLoginToken(username: 'admin', password: '1234');

    // Then
    expect(loginToken.accessToken, 'd8b84ee6-470b-4a40-83c9-bf5c742c178d',
        reason: '토큰 기간 만료에 따른 토큰 변경');
  });
}