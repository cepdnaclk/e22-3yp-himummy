/// Categories of expected application and backend failures.
enum AppErrorCode {
  permissionDenied,
  notFound,
  validation,
  network,
  unauthenticated,
  alreadyExists,
  unknown,
}

/// Typed error surfaced by the HiMummy data layer.
class AppException implements Exception {
  /// Creates a typed application error.
  const AppException(this.code, this.message, {this.cause});

  /// Stable error category for callers.
  final AppErrorCode code;

  /// Friendly, non-diagnostic message suitable for caller handling.
  final String message;

  /// Original exception, when available.
  final Object? cause;

  @override
  String toString() => 'AppException(${code.name}): $message';
}
