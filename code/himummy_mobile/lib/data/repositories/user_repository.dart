import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy_mobile/core/constants/firestore_paths.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';
import 'package:himummy_mobile/data/repositories/repository_utils.dart';
import 'package:himummy_mobile/data/services/firebase_error_mapper.dart';

/// Read-only access to user profiles; role provisioning is server-controlled.
class UserRepository {
  /// Creates a repository with injectable Firebase dependencies.
  UserRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  /// Firestore instance.
  final FirebaseFirestore firestore;

  /// Authentication instance.
  final FirebaseAuth auth;

  /// Loads a profile by UID; Firestore rules determine whether it is visible.
  Future<UserProfile> getProfile(String uid) =>
      loadProfile(firestore, uid);

  /// Watches a profile by UID; Firestore rules determine whether it is visible.
  Stream<UserProfile> watchProfile(String uid) => mapProfileSnapshots(
        mapFirebaseStream(
          firestore.doc(FirestorePaths.user(uid)).snapshots(),
        ),
        uid,
      );
}
