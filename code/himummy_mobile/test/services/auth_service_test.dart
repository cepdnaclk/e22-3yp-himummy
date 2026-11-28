import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:himummy_mobile/core/errors/app_exception.dart';
import 'package:himummy_mobile/data/services/auth_service.dart';

void main() {
  test('signs in with email through Firebase Authentication', () async {
    final auth = MockFirebaseAuth(
      mockUser: MockUser(
        uid: 'mother-a',
        email: 'demo.mother.a@himummy.test',
      ),
    );
    final service = AuthService(auth: auth, firestore: FakeFirebaseFirestore());

    final ephemeralPassword = DateTime.now().microsecondsSinceEpoch.toString();
    await service.signInWithEmail(
      'demo.mother.a@himummy.test',
      ephemeralPassword,
    );
    expect(auth.currentUser?.uid, 'mother-a');
  });

  test('loads role from the Firestore user profile', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'clinician-a',
        email: 'demo.clinician.a@himummy.test',
      ),
    );
    await firestore.collection('users').doc('clinician-a').set({
      'display_name': 'Demo Clinician A',
      'email': 'demo.clinician.a@himummy.test',
      'role': 'clinician',
      'created_at': DateTime.now(),
    });

    final service = AuthService(auth: auth, firestore: firestore);
    expect((await service.currentUserProfile())?.role, 'clinician');
    expect(service.authStateChanges, emits(isA<MockUser>()));
  });

  test('surfaces a missing profile instead of assigning a client role', () async {
    final service = AuthService(
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'missing-user'),
      ),
      firestore: FakeFirebaseFirestore(),
    );

    expect(
      service.currentUserProfile(),
      throwsA(isA<AppException>()),
    );
  });

  test('signs out the authenticated account', () async {
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'mother-a'),
    );
    final service = AuthService(auth: auth, firestore: FakeFirebaseFirestore());
    await service.signOut();
    expect(auth.currentUser, isNull);
  });
}
