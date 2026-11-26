import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/constants/firestore_paths.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/audit_log.dart';
import 'package:himummy/data/repositories/repository_utils.dart';
import 'package:himummy/data/services/firebase_error_mapper.dart';

/// Client-facing operations for append-only audit entries.
class AuditRepository {
  /// Creates a repository with injectable Firebase dependencies.
  AuditRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  /// Firestore instance.
  final FirebaseFirestore firestore;

  /// Authentication instance.
  final FirebaseAuth auth;

  /// Creates an audit entry for the current actor.
  Future<void> create(AuditLog entry) async {
    final uid = requireUid(auth);
    if (entry.actorUid != uid) {
      throw const AppException(
        AppErrorCode.permissionDenied,
        'Audit actor must match the signed-in user.',
      );
    }
    entry.validate();
    try {
      await firestore.collection(FirestorePaths.auditLogs).add(entry.toMap());
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Watches audit entries created by the signed-in clinician.
  Stream<List<AuditLog>> watchMyEntries({int limit = 100}) {
    if (limit < 1 || limit > 500) {
      throw const AppException(
        AppErrorCode.validation,
        'Audit limit must be between 1 and 500.',
      );
    }
    final uid = requireUid(auth);
    final snapshots = firestore
        .collection(FirestorePaths.auditLogs)
        .where(DataContract.actorUid, isEqualTo: uid)
        .where(DataContract.actorRole, isEqualTo: DataContract.clinicianRole)
        .orderBy(DataContract.timestamp, descending: true)
        .limit(limit)
        .snapshots();
    return mapFirebaseStream(snapshots).map((snapshot) => snapshot.docs
        .map((doc) => AuditLog.fromMap(doc.data()))
        .toList());
  }
}
