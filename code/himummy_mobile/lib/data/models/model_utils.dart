import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:himummy_mobile/core/errors/app_exception.dart';

/// Reads a Firestore timestamp represented as a Dart date or Timestamp.
DateTime parseDateTime(Object? value, String field) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  throw AppException(
    AppErrorCode.validation,
    'Invalid $field timestamp.',
  );
}

/// Reads a required string field or throws a typed validation error.
String parseString(Object? value, String field) {
  if (value is String) return value;
  throw AppException(AppErrorCode.validation, 'Invalid $field value.');
}

/// Reads an optional string field or throws when a non-string value is present.
String? parseOptionalString(Object? value, String field) {
  if (value == null) return null;
  return parseString(value, field);
}

/// Reads an integer field without silently truncating decimal values.
int parseInt(Object? value, String field) {
  if (value is int) return value;
  throw AppException(AppErrorCode.validation, 'Invalid $field value.');
}

/// Reads a numeric field as a double.
double parseDouble(Object? value, String field) {
  if (value is num) return value.toDouble();
  throw AppException(AppErrorCode.validation, 'Invalid $field value.');
}

/// Reads a boolean field or throws a typed validation error.
bool parseBool(Object? value, String field) {
  if (value is bool) return value;
  throw AppException(AppErrorCode.validation, 'Invalid $field value.');
}

/// Reads a string-keyed map or throws a typed validation error.
Map<String, Object?> parseMap(Object? value, String field) {
  if (value is! Map) {
    throw AppException(AppErrorCode.validation, 'Invalid $field value.');
  }
  try {
    return Map<String, Object?>.from(value);
  } on TypeError catch (error) {
    throw AppException(
      AppErrorCode.validation,
      'Invalid $field value.',
      cause: error,
    );
  }
}

/// Rejects a timestamp later than [now].
void requireFutureSafe(DateTime value, String field, {DateTime? now}) {
  if (value.isAfter(now ?? DateTime.now())) {
    throw AppException(
      AppErrorCode.validation,
      '$field cannot be in the future.',
    );
  }
}

/// Rejects empty or whitespace-only values.
void requireNonEmpty(String value, String field) {
  if (value.trim().isEmpty) {
    throw AppException(
      AppErrorCode.validation,
      '$field cannot be empty.',
    );
  }
}
