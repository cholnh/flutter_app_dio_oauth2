class Token {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String scope;

  const Token({this.accessToken, this.tokenType, this.expiresIn, this.scope});

  Token.fromJson(Map<String, dynamic> json) :
      accessToken = json['access_token'],
      tokenType = json['token_type'],
      expiresIn = json['expires_in'],
      scope = json['scope'];

  @override
  String toString() {
    return 'Token{accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn, scope: $scope}';
  }
}