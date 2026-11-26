import 'package:flutter_test/flutter_test.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';
import 'package:himummy_mobile/domain/data_freshness.dart';
import 'package:himummy_mobile/domain/role_guard.dart';

void main() {
  final now = DateTime.now();
  final clinician = UserProfile(
    uid: 'clinician-a',
    displayName: 'Demo Clinician A',
    email: 'demo.clinician.a@himummy.test',
    role: 'clinician',
    createdAt: now,
  );
  final assignedMother = UserProfile(
    uid: 'mother-a',
    displayName: 'Demo Mother A',
    email: 'demo.mother.a@himummy.test',
    role: 'mother',
    assignedClinicianUid: 'clinician-a',
    createdAt: now,
  );
  final unassignedMother = assignedMother.copyWith(
    assignedClinicianUid: 'clinician-b',
  );

  test('checks roles and assigned-patient access', () {
    expect(RoleGuard.isClinician(clinician), isTrue);
    expect(RoleGuard.isMother(assignedMother), isTrue);
    expect(RoleGuard.canViewPatient(clinician, assignedMother), isTrue);
    expect(RoleGuard.canViewPatient(clinician, unassignedMother), isFalse);
    expect(RoleGuard.canViewPatient(null, assignedMother), isFalse);
  });

  test('reports stale and fresh timestamps at the requested threshold', () {
    expect(
      isStale(
        now.subtract(const Duration(minutes: 11)),
        const Duration(minutes: 10),
        now: now,
      ),
      isTrue,
    );
    expect(
      isStale(
        now.subtract(const Duration(minutes: 9)),
        const Duration(minutes: 10),
        now: now,
      ),
      isFalse,
    );
  });
}
