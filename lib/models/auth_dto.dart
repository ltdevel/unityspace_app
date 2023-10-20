class OnlyTokensResponse {
  final String accessToken;
  final String refreshToken;

  const OnlyTokensResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory OnlyTokensResponse.fromJson(Map<String, dynamic> jsonData) {
    return OnlyTokensResponse(
      accessToken: jsonData['access_token'].toString(),
      refreshToken: jsonData['refresh_token'].toString(),
    );
  }
}
