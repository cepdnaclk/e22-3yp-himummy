import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/constants/firestore_paths.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/audit_log.dart';
import 'package:himummy/data/models/checkin.dart';
import 'package:himummy/data/models/clinician_note.dart';
import 'package:himummy/data/models/hr_reading.dart';
import 'package:himummy/data/models/patient_summary.dart';
import 'package:himummy/data/models/room_reading.dart';
import 'package:himummy/data/models/user_profile.dart';
import 'package:himummy/data/repositories/repository_utils.dart';
import 'package:himummy/data/services/firebase_error_mapper.dart';
import 'package:himummy/domain/role_guard.dart';

/// Clinician access to assigned patients and their follow-up notes.
class ClinicianRepository {
  /// Creates a repository with injectable Firebase dependencies.
  ClinicianRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  /// Firestore instance.
  final FirebaseFirestore firestore;

  /// Authentication instance.
  final FirebaseAuth auth;

  /// Watches mothers assigned to the signed-in clinician.
  Stream<List<UserProfile>> watchAssignedPatients() {
    final uid = requireUid(auth);
    final snapshots = firestore
        .collection(FirestorePaths.users)
        .where('role', isEqualTo: DataContract.motherRole)
        .where('assigned_clinician_uid', isEqualTo: uid)
        .snapshots();
    return mapFirebaseStream(snapshots).map((snapshot) =>
        snapshot.docs.map((doc) => UserProfile.fromMap(doc.id, doc.data())).toList());
  }

  /// Loads a patient's profile and latest available saved data.
  Future<PatientSummary> getPatientSummary(String motherUid) async {
    await _requireAssignment(motherUid);
    try {
      final hrSnapshot = await firestore
          .collection(FirestorePaths.heartRateReadings(motherUid))
          .orderBy(DataContract.recordedAt, descending: true)
          .limit(1)
          .get();
      final roomSnapshot = await firestore
          .collection(FirestorePaths.roomReadings(motherUid))
          .orderBy(DataContract.updatedAt, descending: true)
          .limit(1)
          .get();
      final checkinSnapshot = await firestore
          .collection(FirestorePaths.checkins(motherUid))
          .orderBy(DataContract.submittedAt, descending: true)
          .limit(1)
          .get();
      return PatientSummary(
        profile: await loadProfile(firestore, motherUid),
        latestHrReading: hrSnapshot.docs.isEmpty
            ? null
            : HrReading.fromMap(hrSnapshot.docs.first.data()),
        latestRoomReading: roomSnapshot.docs.isEmpty
            ? null
            : RoomReading.fromMap(roomSnapshot.docs.first.data()),
        latestCheckin: checkinSnapshot.docs.isEmpty
            ? null
            : Checkin.fromMap(checkinSnapshot.docs.first.data()),
      );
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Watches newest-first heart-rate estimates for an assigned mother.
  Stream<List<HrReading>> watchPatientHrReadings(
    String motherUid, {
    int limit = 50,
  }) async* {
    if (limit < 1 || limit > 500) {
      throw const AppException(
        AppErrorCode.validation,
        'Reading limit must be between 1 and 500.',
      );
    }
    await _requireAssignment(motherUid);
    final snapshots = firestore
        .collection(FirestorePaths.heartRateReadings(motherUid))
        .orderBy(DataContract.recordedAt, descending: true)
        .limit(limit)
        .snapshots();
    yield* mapFirebaseStream(snapshots).map((snapshot) =>
        snapshot.docs.map((doc) => HrReading.fromMap(doc.data())).toList());
  }

  /// Loads newest-first check-ins for an assigned mother.
  Future<List<Checkin>> getPatientCheckins(String motherUid) async {
    await _requireAssignment(motherUid);
    try {
      final snapshot = await firestore
          .collection(FirestorePaths.checkins(motherUid))
          .orderBy(DataContract.submittedAt, descending: true)
          .get();
      return snapshot.docs.map((doc) => Checkin.fromMap(doc.data())).toList();
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Adds a pending note and a corresponding audit record atomically.
  Future<ClinicianNote> addFollowUpNote(
    String motherUid,
    String text,
  ) async {
    final author = await _requireAssignment(motherUid);
    final note = ClinicianNote(
      noteText: text.trim(),
      authorUid: author.uid,
      authorName: author.displayName,
      createdAt: DateTime.now(),
      reviewStatus: 'pending',
    );
    final notes = firestore.collection(FirestorePaths.clinicianNotes(motherUid));
    final noteRef = notes.doc();
    final auditRef = firestore.collection(FirestorePaths.auditLogs).doc();
    final audit = AuditLog(
      actorUid: author.uid,
      actorRole: author.role,
      action: 'clinician_note_created',
      targetPath: noteRef.path,
      timestamp: DateTime.now(),
    );
    try {
      final batch = firestore.batch();
      batch.set(noteRef, note.toMap());
      batch.set(auditRef, audit.toMap());
      await batch.commit();
      return note;
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  /// Watches clinician notes for an assigned mother, newest first.
  Stream<List<ClinicianNote>> watchPatientNotes(String motherUid) async* {
    await _requireAssignment(motherUid);
    final snapshots = firestore
        .collection(FirestorePaths.clinicianNotes(motherUid))
        .orderBy(DataContract.createdAt, descending: true)
        .snapshots();
    yield* mapFirebaseStream(snapshots).map((snapshot) => snapshot.docs
        .map((doc) => ClinicianNote.fromMap(doc.data()))
        .toList());
  }

  /// Updates the review status of a note authored by the signed-in clinician.
  Future<void> updateReviewStatus(
    String motherUid,
    String noteId,
    String reviewStatus,
  ) async {
    final clinician = await _requireAssignment(motherUid);
    final noteRef = firestore
        .collection(FirestorePaths.clinicianNotes(motherUid))
        .doc(noteId);
    try {
      final noteSnapshot = await noteRef.get();
      final noteData = noteSnapshot.data();
      if (!noteSnapshot.exists || noteData == null) {
        throw const AppException(
          AppErrorCode.notFound,
          'The clinician note could not be found.',
        );
      }
      final note = ClinicianNote.fromMap(noteData);
      if (note.authorUid != clinician.uid) {
        throw const AppException(
          AppErrorCode.permissionDenied,
          'Only the note author can update its review status.',
        );
      }
      note.copyWith(reviewStatus: reviewStatus);
      final auditRef = firestore.collection(FirestorePaths.auditLogs).doc();
      final audit = AuditLog(
        actorUid: clinician.uid,
        actorRole: clinician.role,
        action: 'clinician_note_review_status_updated',
        targetPath: noteRef.path,
        timestamp: DateTime.now(),
      );
      final batch = firestore.batch();
      batch.update(noteRef, {DataContract.reviewStatus: reviewStatus});
      batch.set(auditRef, audit.toMap());
      await batch.commit();
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    }
  }

  Future<UserProfile> _requireAssignment(String motherUid) async {
    final clinicianUid = requireUid(auth);
    final clinician = await loadProfile(firestore, clinicianUid);
    final mother = await loadProfile(firestore, motherUid);
    if (!RoleGuard.canViewPatient(clinician, mother)) {
      throw const AppException(
        AppErrorCode.permissionDenied,
        'This patient is not assigned to the signed-in clinician.',
      );
    }
    return clinician;
  }
}
