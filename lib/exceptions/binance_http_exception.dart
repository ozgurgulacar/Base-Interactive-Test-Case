class BinanceHttpException implements Exception {
  final String message;
  final int? statusCode;

  BinanceHttpException(this.message, {this.statusCode});

  @override
  String toString() =>
      statusCode != null ? 'ApiException($statusCode): $message' : message;
}
