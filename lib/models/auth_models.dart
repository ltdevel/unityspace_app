class ResetPasswordResponse {
  final String status;
  final String message;

  ResetPasswordResponse({
    required this.status,
    required this.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> jsonData) {
    return ResetPasswordResponse(
      status: jsonData['status'] as String,
      message: jsonData['message'] as String,
    );
  }
}

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

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens(this.accessToken, this.refreshToken);
}
