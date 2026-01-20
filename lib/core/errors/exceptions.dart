// Exception thrown when network requests or API calls fail
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// Exception thrown for authentication failures (e.g., invalid credentials)
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

// Exception thrown when local storage or cache operations fail
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}