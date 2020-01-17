import 'package:flutter_app_dio_1/model/token.dart';
import 'package:flutter_app_dio_1/oauth_token_reposiroty/oauth_token_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  OauthTokenRepository oauthTokenRepository = OauthTokenRepository();

  test('Oauth Token Repository Test - issueGuestToken()', () async {
    // Given
    Token guestToken;
    bool isValidToken;

    // When
    guestToken = await oauthTokenRepository.issueGuestToken();
    isValidToken = await oauthTokenRepository.isValid(accessToken: guestToken.accessToken);

    // Then
    expect(guestToken.accessToken != null, true);
    expect(guestToken.refreshToken == null, true);
    expect(guestToken.tokenMode, TokenMode.GUEST);
    expect(isValidToken, true);
  });

  test('Oauth Token Repository Test - issueLoginToken()', () async {
    // Given
    Token loginToken;
    bool isValidToken;

    // When
    loginToken = await oauthTokenRepository.issueLoginToken(username: 'admin', password: '1234');
    isValidToken = await oauthTokenRepository.isValid(accessToken: loginToken.accessToken);

    // Then
    expect(loginToken.accessToken != null, true);
    expect(loginToken.refreshToken != null, true);
    expect(loginToken.tokenMode, TokenMode.LOGIN);
    expect(isValidToken, true);
  });

  test('Oauth Token Repository Test - issueLoginToken()', () async {
    // Given
    Token loginToken;
    Token refreshedToken;

    // When
    loginToken = await oauthTokenRepository.issueLoginToken(username: 'admin', password: '1234');
    refreshedToken = await oauthTokenRepository.refreshLoginToken(refreshToken: loginToken.refreshToken);

    // Then
    expect(refreshedToken.accessToken != null, true);
    expect(refreshedToken.refreshToken != null, true);
    expect(refreshedToken.accessToken != loginToken.accessToken, true);
    expect(refreshedToken.refreshToken == loginToken.refreshToken, true);
    expect(refreshedToken.tokenMode, TokenMode.LOGIN);
    expect(await oauthTokenRepository.isValid(accessToken: refreshedToken.accessToken), true);
    expect(await oauthTokenRepository.isValid(accessToken: refreshedToken.refreshToken), false);
  });

  test('Oauth Token Repository Test - isValid()', () async {
    // Given
    Token normalToken;
    bool isValidToken, isInValidToken;

    // When
    normalToken = await oauthTokenRepository.issueLoginToken(username: 'admin', password: '1234');
    isValidToken = await oauthTokenRepository.isValid(accessToken: normalToken.accessToken);
    isInValidToken = await oauthTokenRepository.isValid(accessToken: 'this-is-abnormal-token');

    // Then
    expect(isValidToken, true);
    expect(isInValidToken, false);
  });

  test('Oauth Token Repository Test - getToken()', () async {
    // Given
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token token;
    bool isValidToken;

    // When
    token = await oauthTokenRepository.getToken()
        .catchError((err) async {
          await oauthTokenRepository.serverHealthCheck() == 'UP'
            ? print('server up')    // 사용자 네트워크 문제일 가능성 높음
            : print('server down'); // 서버 점검 중 공지 띄우기
    });
    isValidToken = await oauthTokenRepository.isValid(accessToken: token.accessToken);

    // Then
    expect(token.accessToken != null, true);
    expect(isValidToken, true);
    expect(token.tokenMode == TokenMode.GUEST ? 'guest' : 'login', prefs.get('__oauth_tokenMode__'));
    expect(token.accessToken, prefs.get('__oauth_accessToken__'));
    expect(token.tokenType, prefs.get('__oauth_tokenType__'));
    expect(token.expiresIn, prefs.get('__oauth_expiresIn__'));
    expect(token.scope, prefs.get('__oauth_scope__'));
    expect(token.refreshToken, prefs.get('__oauth_refreshToken__'));
  });

  test('Oauth Token Repository Test - serverHealthCheck()', () async {
    // Given
    String serverHealth;

    // When
    serverHealth = await oauthTokenRepository.serverHealthCheck();

    // Then
    expect(serverHealth, 'UP');
  });
}