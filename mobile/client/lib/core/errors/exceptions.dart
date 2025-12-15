/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Server exception - for 4xx, 5xx errors
class ServerException extends AppException {
  const ServerException(super.message, [super.statusCode]);
}

/// Network exception - for connection issues
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Cache exception - for local storage issues
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException(super.message, [super.statusCode]);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException(super.message);
}

