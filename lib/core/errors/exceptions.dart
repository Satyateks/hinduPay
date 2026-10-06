class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No internet connection'});
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({
    this.message = 'Session expired. Please login again.',
  });
}

class ValidationException implements Exception {
  final String message;

  const ValidationException({required this.message});
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Local data not available'});
}
