/// A small success/failure container for APIs that prefer values over throws.
sealed class Result<T> {
  /// Creates a result.
  const Result();

  /// Creates a successful result.
  const factory Result.success(T value) = Success<T>;

  /// Creates a failed result.
  const factory Result.failure(Object error) = Failure<T>;

  /// Returns true when this result contains a value.
  bool get isSuccess => this is Success<T>;
}

/// Successful [Result] value.
final class Success<T> extends Result<T> {
  /// Creates a successful result.
  const Success(this.value);

  /// Result value.
  final T value;
}

/// Failed [Result] value.
final class Failure<T> extends Result<T> {
  /// Creates a failed result.
  const Failure(this.error);

  /// Failure object.
  final Object error;
}
