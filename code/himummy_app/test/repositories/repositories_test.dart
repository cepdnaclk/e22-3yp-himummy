import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/audit_log.dart';
import 'package:himummy/data/models/checkin.dart';
import 'package:himummy/data/models/hr_reading.dart';
import 'package:himummy/data/models/room_reading.dart';
import 'package:himummy/data/repositories/audit_repository.dart';
import 'package:himummy/data/repositories/checkin_repository.dart';
import 'package:himummy/data/repositories/clinician_repository.dart';
import 'package:himummy/data/repositories/hr_reading_repository.dart';
import 'package:himummy/data/repositories/room_reading_repository.dart';
import 'package:himummy/data/repositories/user_repository.dart';

void main() {
  final now = DateTime.now();

  group('mother repositories', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'mother-a'),
      );
    });

    test('user repository loads and watches a profile', () async {
      await firestore.collection('users').doc('mother-a').set({
        'display_name': 'Demo Mother A',
        'email': 'demo.mother.a@himummy.test',
        'role': 'mother',
        'assigned_clinician_uid': 'clinician-a',
        'created_at': now,
      });
      final repository = UserRepository(firestore: firestore, auth: auth);
      expect((await repository.getProfile('mother-a')).uid, 'mother-a');
      expect((await repository.watchProfile('mother-a').first).role, 'mother');
    });

    test('HR repository saves and watches low-quality readings', () async {
      final repository = HrReadingRepository(firestore: firestore, auth: auth);
      await repository.saveHrReading(
        HrReading(
          heartRateBpm: 75,
          recordedAt: now,
          signalQuality: 'poor',
          source: 'synthetic',
        ),
      );
      final readings = await repository.watchHrReadings().first;
      expect(readings, hasLength(1));
      expect(readings.single.signalQuality, 'poor');
    });

    test('room repository saves and watches the latest reading', () async {
      final repository =
          RoomReadingRepository(firestore: firestore, auth: auth);
      await repository.saveRoomReading(
        RoomReading(
          roomTempC: 22,
          humidityPercent: 44,
          updatedAt: now,
          source: 'synthetic',
        ),
      );
      expect(
        (await repository.watchLatestRoomReading().first)?.roomTempC,
        22,
      );
    });

    test('check-in repository submits and retrieves consented history',
        () async {
      final repository = CheckinRepository(firestore: firestore, auth: auth);
      await repository.submitCheckin(
        Checkin(
          answers: const {'mood': 'okay'},
          submittedAt: now,
          consentGiven: true,
        ),
      );
      expect(await repository.getCheckinHistory(), hasLength(1));
    });

    test('rejects unauthenticated writes with a typed error', () async {
      final repository = HrReadingRepository(
        firestore: firestore,
        auth: MockFirebaseAuth(signedIn: false),
      );
      expect(
        repository.saveHrReading(
          HrReading(
            heartRateBpm: 75,
            recordedAt: now,
            signalQuality: 'good',
            source: 'synthetic',
          ),
        ),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('clinician repository', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late ClinicianRepository repository;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'clinician-a'),
      );
      await firestore.collection('users').doc('clinician-a').set({
        'display_name': 'Demo Clinician A',
        'email': 'demo.clinician.a@himummy.test',
        'role': 'clinician',
        'created_at': now,
      });
      await firestore.collection('users').doc('mother-a').set({
        'display_name': 'Demo Mother A',
        'email': 'demo.mother.a@himummy.test',
        'role': 'mother',
        'assigned_clinician_uid': 'clinician-a',
        'created_at': now,
      });
      await firestore
          .collection('users/mother-a/hr_readings')
          .doc('hr-1')
          .set({
        'heart_rate_bpm': 80,
        'recorded_at': now,
        'signal_quality': 'fair',
        'source': 'synthetic',
      });
      await firestore
          .collection('users/mother-a/room_readings')
          .doc('room-1')
          .set({
        'room_temp_c': 21.0,
        'humidity_percent': 50.0,
        'updated_at': now,
        'source': 'synthetic',
      });
      await firestore.collection('users/mother-a/checkins').doc('checkin-1').set({
        'answers': {'mood': 'okay'},
        'submitted_at': now,
        'consent_given': true,
      });
      repository = ClinicianRepository(firestore: firestore, auth: auth);
    });

    test('lists patients and builds a latest-data summary', () async {
      expect(await repository.watchAssignedPatients().first, hasLength(1));
      final summary = await repository.getPatientSummary('mother-a');
      expect(summary.profile.uid, 'mother-a');
      expect(summary.latestHrReading?.heartRateBpm, 80);
      expect(summary.latestRoomReading?.roomTempC, 21);
      expect(summary.latestCheckin?.answers['mood'], 'okay');
    });

    test('watches assigned HR, check-ins, and clinician notes', () async {
      expect(
        (await repository.watchPatientHrReadings('mother-a').first).single
            .heartRateBpm,
        80,
      );
      expect(await repository.getPatientCheckins('mother-a'), hasLength(1));
      expect(await repository.watchPatientNotes('mother-a').first, isEmpty);
    });

    test('creates a note and audit entry, then updates review status', () async {
      final note = await repository.addFollowUpNote(
        'mother-a',
        'Synthetic follow-up',
      );
      expect(note.authorUid, 'clinician-a');
      expect(
        (await firestore.collection('audit_logs').get()).docs,
        hasLength(1),
      );
      expect(
        (await repository.watchPatientNotes('mother-a').first).single.noteText,
        'Synthetic follow-up',
      );

      final noteId = (await firestore
              .collection('users/mother-a/clinician_notes')
              .get())
          .docs
          .single
          .id;
      await repository.updateReviewStatus('mother-a', noteId, 'reviewed');
      final updated = await firestore
          .collection('users/mother-a/clinician_notes')
          .doc(noteId)
          .get();
      expect(updated.data()?['review_status'], 'reviewed');
      expect((await firestore.collection('audit_logs').get()).docs, hasLength(2));
    });

    test('denies a clinician who is not assigned to a mother', () async {
      await firestore.collection('users').doc('mother-b').set({
        'display_name': 'Demo Mother B',
        'email': 'demo.mother.b@himummy.test',
        'role': 'mother',
        'assigned_clinician_uid': 'clinician-b',
        'created_at': now,
      });
      expect(
        repository.getPatientSummary('mother-b'),
        throwsA(isA<AppException>()),
      );
    });
  });

  test('audit repository rejects actor spoofing and lists own entries', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'clinician-a'),
    );
    final repository = AuditRepository(firestore: firestore, auth: auth);
    expect(
      repository.create(
        AuditLog(
          actorUid: 'someone-else',
          actorRole: 'clinician',
          action: 'test',
          targetPath: 'users/mother-a',
          timestamp: now,
        ),
      ),
      throwsA(isA<AppException>()),
    );
    await repository.create(
      AuditLog(
        actorUid: 'clinician-a',
        actorRole: 'clinician',
        action: 'test',
        targetPath: 'users/mother-a',
        timestamp: now,
      ),
    );
    expect(await repository.watchMyEntries().first, hasLength(1));
  });
}
