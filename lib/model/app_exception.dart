class AppException implements Exception {
  const AppException({
    required this.code,
    required this.overview,
    required this.detail,
  });

  final int code;
  final String overview;
  final String detail;

  @override
  String toString() {
    return 'Error Code [$code] \n overview: $overview \n Message: $detail';
  }
}
