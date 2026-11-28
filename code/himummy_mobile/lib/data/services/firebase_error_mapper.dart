import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy_mobile/core/errors/app_exception.dart';

/// Converts Firebase stream failures to the same typed errors used by Futures.
Stream<T> mapFirebaseStream<T>(Stream<T> stream) =>
    stream.transform(StreamTransformer<T, T>.fromHandlers(
      handleError: (Object error, StackTrace stackTrace, EventSink<T> sink) {
        if (error is FirebaseException) {
          sink.addError(mapFirestoreError(error), stackTrace);
        } else {
          sink.addError(error, stackTrace);
        }
      },
    ));

/// Maps an authentication exception to a friendly application error.
AppException mapFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'permission-denied':
    case 'user-disabled':
      return AppException(
        AppErrorCode.permissionDenied,
        'This account cannot sign in.',
        cause: error,
      );
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return AppException(
        AppErrorCode.unauthenticated,
        'The email or password is not correct.',
        cause: error,
      );
    case 'network-request-failed':
      return AppException(
        AppErrorCode.network,
        'Unable to reach the sign-in service.',
        cause: error,
      );
    case 'email-already-in-use':
      return AppException(
        AppErrorCode.alreadyExists,
        'An account already uses this email.',
        cause: error,
      );
    default:
      return AppException(
        AppErrorCode.unknown,
        'Sign-in could not be completed.',
        cause: error,
      );
  }
}

/// Maps a Firestore exception to a friendly application error.
AppException mapFirestoreError(FirebaseException error) {
  switch (error.code) {
    case 'permission-denied':
      return AppException(
        AppErrorCode.permissionDenied,
        'You do not have permission to access this data.',
        cause: error,
      );
    case 'not-found':
      return AppException(
        AppErrorCode.notFound,
        'The requested data could not be found.',
        cause: error,
      );
    case 'unavailable':
    case 'deadline-exceeded':
      return AppException(
        AppErrorCode.network,
        'The data service is currently unavailable.',
        cause: error,
      );
    default:
      return AppException(
        AppErrorCode.unknown,
        'The data request could not be completed.',
        cause: error,
      );
  }
}
