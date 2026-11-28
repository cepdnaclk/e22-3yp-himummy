import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:himummy/core/constants/firestore_paths.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/user_profile.dart';
import 'package:himummy/data/services/firebase_error_mapper.dart';

/// Firebase Authentication operations and Firestore-backed role lookup.
class AuthService {
  /// Creates an injectable authentication service.
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance;

  /// Firebase Authentication instance.
  final FirebaseAuth auth;

  /// Firestore instance holding authoritative user roles.
  final FirebaseFirestore firestore;

  /// Authenticated Firebase user, if any.
  User? get currentUser => auth.currentUser;

  /// Emits the current authentication state whenever it changes.
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Signs in with email and password.
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw mapFirebaseAuthError(error);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw mapFirebaseAuthError(error);
    }
  }

  /// Loads the signed-in user's profile and authoritative Firestore role.
  Future<UserProfile?> currentUserProfile() async {
    final user = auth.currentUser;
    if (user == null) return null;
    try {
      final snapshot =
          await firestore.doc(FirestorePaths.user(user.uid)).get();
      if (!snapshot.exists || snapshot.data() == null) {
        throw const AppException(
          AppErrorCode.notFound,
          'The account profile could not be found.',
        );
      }
      return UserProfile.fromMap(user.uid, snapshot.data()!);
    } on FirebaseException catch (error) {
      throw mapFirestoreError(error);
    } on TypeError catch (error) {
      throw AppException(
        AppErrorCode.validation,
        'The account profile contains invalid data.',
        cause: error,
      );
    }
  }
}
