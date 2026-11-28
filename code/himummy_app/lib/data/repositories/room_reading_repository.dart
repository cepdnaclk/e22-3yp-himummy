import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/constants/firestore_paths.dart';
import 'package:himummy/data/models/room_reading.dart';
import 'package:himummy/data/repositories/repository_utils.dart';
import 'package:himummy/data/services/firebase_error_mapper.dart';

/// Mother-owned room temperature and humidity reads and writes.
class RoomReadingRepository {
  /// Creates a repository with injectable Firebase dependencies.
  RoomReadingRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  /// Firestore instance.
  final FirebaseFirestore firestore;

  /// Authentication instance.
  final FirebaseAuth auth;

  /// Saves a validated room reading.
  Future<void> saveRoomReading(RoomReading reading) async {
    final uid = requireUid(auth);
    reading.validate();
    try {
      await firestore
          .collection(FirestorePaths.roomReadings(uid))
          .add(reading.toMap());
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Watches the newest room reading, or null when none has been saved.
  Stream<RoomReading?> watchLatestRoomReading() {
    final uid = requireUid(auth);
    final snapshots = firestore
        .collection(FirestorePaths.roomReadings(uid))
        .orderBy(DataContract.updatedAt, descending: true)
        .limit(1)
        .snapshots();
    return mapFirebaseStream(snapshots).map((snapshot) => snapshot.docs.isEmpty
        ? null
        : RoomReading.fromMap(snapshot.docs.first.data()));
  }
}
