import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Connects Firebase clients to local emulators in debug builds only.
Future<void> useFirebaseEmulator({
  FirebaseAuth? auth,
  FirebaseFirestore? firestore,
}) async {
  if (!kDebugMode) {
    throw StateError('Firebase emulators can only be enabled in debug mode.');
  }
  final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : 'localhost';
  await (auth ?? FirebaseAuth.instance).useAuthEmulator(host, 9099);
  (firestore ?? FirebaseFirestore.instance).useFirestoreEmulator(host, 8080);
}