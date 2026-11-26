import 'package:flutter_test/flutter_test.dart';
import 'package:himummy_mobile/core/errors/app_exception.dart';
import 'package:himummy_mobile/data/models/audit_log.dart';
import 'package:himummy_mobile/data/models/checkin.dart';
import 'package:himummy_mobile/data/models/clinician_note.dart';
import 'package:himummy_mobile/data/models/hr_reading.dart';
import 'package:himummy_mobile/data/models/room_reading.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';

void main() {
  final now = DateTime.now();

  group('model serialization', () {
    test('round-trips an HR estimate and retains poor quality', () {
      final reading = HrReading(
        heartRateBpm: 75,
        recordedAt: now,
        signalQuality: 'poor',
        source: 'synthetic',
      );
      final restored = HrReading.fromMap(reading.toMap());
      expect(restored.heartRateBpm, 75);
      expect(restored.signalQuality, 'poor');
      expect(restored.source, 'synthetic');
    });

    test('round-trips room reading fields', () {
      final reading = RoomReading(
        roomTempC: 21.5,
        humidityPercent: 47.2,
        updatedAt: now,
        source: 'synthetic',
      );
      final restored = RoomReading.fromMap(reading.toMap());
      expect(restored.roomTempC, 21.5);
      expect(restored.humidityPercent, 47.2);
    });

    test('round-trips a consented check-in', () {
      final checkin = Checkin(
        answers: const {'mood': 'okay'},
        submittedAt: now,
        consentGiven: true,
      );
      expect(Checkin.fromMap(checkin.toMap()).answers, {'mood': 'okay'});
    });

    test('round-trips user, note, and audit models', () {
      final profile = UserProfile(
        uid: 'mother-a',
        displayName: 'Demo Mother A',
        email: 'demo.mother.a@himummy.test',
        role: 'mother',
        assignedClinicianUid: 'clinician-a',
        createdAt: now,
      );
      expect(UserProfile.fromMap(profile.uid, profile.toMap()).role, 'mother');

      final note = ClinicianNote(
        noteText: 'Synthetic follow-up',
        authorUid: 'clinician-a',
        authorName: 'Demo Clinician A',
        createdAt: now,
        reviewStatus: 'pending',
      );
      expect(ClinicianNote.fromMap(note.toMap()).authorUid, 'clinician-a');

      final audit = AuditLog(
        actorUid: 'clinician-a',
        actorRole: 'clinician',
        action: 'note_created',
        targetPath: 'users/mother-a/clinician_notes/note-a',
        timestamp: now,
      );
      expect(AuditLog.fromMap(audit.toMap()).action, 'note_created');
    });
  });

  group('model validation', () {
    test('rejects heart-rate estimates outside the supported range', () {
      expect(
        () => HrReading(
          heartRateBpm: 221,
          recordedAt: now,
          signalQuality: 'good',
          source: 'synthetic',
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('rejects invalid signal quality but accepts invalid as a quality', () {
      expect(
        () => HrReading(
          heartRateBpm: 70,
          recordedAt: now,
          signalQuality: 'unknown',
          source: 'synthetic',
        ),
        throwsA(isA<AppException>()),
      );
      expect(
        HrReading(
          heartRateBpm: 70,
          recordedAt: now,
          signalQuality: 'invalid',
          source: 'synthetic',
        ).signalQuality,
        'invalid',
      );
    });

    test('rejects out-of-range room readings and missing consent', () {
      expect(
        () => RoomReading(
          roomTempC: 61,
          humidityPercent: 50,
          updatedAt: now,
          source: 'synthetic',
        ),
        throwsA(isA<AppException>()),
      );
      expect(
        () => Checkin(
          answers: const {'mood': 'okay'},
          submittedAt: now,
          consentGiven: false,
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('rejects future reading timestamps', () {
      expect(
        () => HrReading(
          heartRateBpm: 70,
          recordedAt: now.add(const Duration(hours: 1)),
          signalQuality: 'good',
          source: 'synthetic',
        ),
        throwsA(isA<AppException>()),
      );
    });
  });
}
