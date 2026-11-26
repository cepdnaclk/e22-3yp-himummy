import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy_mobile/core/constants/data_contract.dart';
import 'package:himummy_mobile/core/constants/firestore_paths.dart';
import 'package:himummy_mobile/data/models/checkin.dart';
import 'package:himummy_mobile/data/repositories/repository_utils.dart';
import 'package:himummy_mobile/data/services/firebase_error_mapper.dart';

/// Mother-owned check-in submission and history.
class CheckinRepository {
  /// Creates a repository with injectable Firebase dependencies.
  CheckinRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  /// Firestore instance.
  final FirebaseFirestore firestore;

  /// Authentication instance.
  final FirebaseAuth auth;

  /// Saves a validated check-in with consent.
  Future<void> submitCheckin(Checkin checkin) async {
    final uid = requireUid(auth);
    checkin.validate();
    try {
      await firestore
          .collection(FirestorePaths.checkins(uid))
          .add(checkin.toMap());
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Loads newest-first check-ins for the signed-in user.
  Future<List<Checkin>> getCheckinHistory() async {
    final uid = requireUid(auth);
    try {
      final snapshot = await firestore
          .collection(FirestorePaths.checkins(uid))
          .orderBy(DataContract.submittedAt, descending: true)
          .get();
      return snapshot.docs.map((doc) => Checkin.fromMap(doc.data())).toList();
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }
}
