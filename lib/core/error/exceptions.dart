/// Custom exceptions for the data layer.
/// These are thrown by data sources and caught by repository implementations.

/// Thrown when a server/remote operation fails.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'An unexpected server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when a local cache operation fails.
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'A cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when an authentication operation fails.
class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException([this.message = 'Authentication failed', this.code]);

  @override
  String toString() => 'AuthException: $message (code: $code)';
}

/// Thrown when a network connectivity issue occurs.
class NetworkException implements Exception {
  final String message;
  const NetworkException(
      [this.message = 'No internet connection. Please check your network.']);

  @override
  String toString() => 'NetworkException: $message';
}
