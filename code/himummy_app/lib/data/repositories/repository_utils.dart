import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/user_profile.dart';
import 'package:himummy/data/services/firebase_error_mapper.dart';

/// Creates the typed error used when no Firebase user is signed in.
AppException requireSignedIn() => const AppException(
      AppErrorCode.unauthenticated,
      'Sign in is required to access this data.',
    );

/// Returns the current Firebase UID or throws when no user is signed in.
String requireUid(FirebaseAuth auth) {
  final uid = auth.currentUser?.uid;
  if (uid == null) throw requireSignedIn();
  return uid;
}

/// Loads a profile and converts malformed/missing records to typed errors.
Future<UserProfile> loadProfile(
  FirebaseFirestore firestore,
  String uid,
) async {
  try {
    final snapshot = await firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      throw const AppException(
        AppErrorCode.notFound,
        'The account profile could not be found.',
      );
    }
    return UserProfile.fromMap(uid, data);
  } on FirebaseException catch (error) {
    throw mapFirestoreError(error);
  } on TypeError catch (error) {
    throw AppException(
      AppErrorCode.validation,
      'The account profile contains invalid data.',
      cause: error,
    );
  }
}

/// Maps profile snapshots to validated user profiles.
Stream<UserProfile> mapProfileSnapshots(
  Stream<DocumentSnapshot<Map<String, dynamic>>> stream,
  String uid,
) =>
    mapFirebaseStream(stream).map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) {
        throw const AppException(
          AppErrorCode.notFound,
          'The account profile could not be found.',
        );
      }
      return UserProfile.fromMap(uid, data);
    });
