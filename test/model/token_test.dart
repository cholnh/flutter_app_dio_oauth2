import 'package:flutter_app_dio_1/model/token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('Token Test - loadFromDisk()', () async {
    // Given
    SharedPreferences.setMockInitialValues({});
    Token token1 = Token(
        accessToken: 'acctoken1234',
        tokenType: 'type',
        expiresIn: 123,
        scope: 'scope',
        refreshToken: 'retoken1234',
        tokenMode: TokenMode.LOGIN);
    Token token2;

    // When
    token1 = await token1.saveToDisk();
    token2 = await Token().loadFromDisk();

    // Then
    expect(token1.accessToken, token2.accessToken);
    expect(token1.tokenType, token2.tokenType);
    expect(token1.expiresIn, token2.expiresIn);
    expect(token1.scope, token2.scope);
    expect(token1.refreshToken, token2.refreshToken);
    expect(token1.tokenMode, token2.tokenMode);
  });
}