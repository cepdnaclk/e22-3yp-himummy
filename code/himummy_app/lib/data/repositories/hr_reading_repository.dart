import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/constants/firestore_paths.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/hr_reading.dart';
import 'package:himummy/data/repositories/repository_utils.dart';
import 'package:himummy/data/services/firebase_error_mapper.dart';

/// Mother-owned heart-rate estimate reads and writes.
class HrReadingRepository {
  /// Creates a repository with injectable Firebase dependencies.
  HrReadingRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  /// Firestore instance.
  final FirebaseFirestore firestore;

  /// Authentication instance.
  final FirebaseAuth auth;

  /// Saves a validated estimate, including poor or invalid signal readings.
  Future<void> saveHrReading(HrReading reading) async {
    final uid = requireUid(auth);
    reading.validate();
    try {
      await firestore
          .collection(FirestorePaths.heartRateReadings(uid))
          .add(reading.toMap());
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Watches newest-first heart-rate estimates, up to [limit].
  Stream<List<HrReading>> watchHrReadings({int limit = 50}) {
    if (limit < 1 || limit > 500) {
      throw const AppException(
        AppErrorCode.validation,
        'Reading limit must be between 1 and 500.',
      );
    }
    final uid = requireUid(auth);
    final snapshots = firestore
        .collection(FirestorePaths.heartRateReadings(uid))
        .orderBy(DataContract.recordedAt, descending: true)
        .limit(limit)
        .snapshots();
    return mapFirebaseStream(snapshots).map(
      (snapshot) =>
          snapshot.docs.map((doc) => HrReading.fromMap(doc.data())).toList(),
    );
  }
}
