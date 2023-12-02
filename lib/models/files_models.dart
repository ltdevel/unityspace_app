class InitialUploadResponse {
  final String uploadId;
  final String key;

  const InitialUploadResponse({
    required this.uploadId,
    required this.key,
  });

  factory InitialUploadResponse.fromJson(Map<String, dynamic> map) {
    return InitialUploadResponse(
      uploadId: map['uploadId'] as String,
      key: map['key'] as String,
    );
  }
}
