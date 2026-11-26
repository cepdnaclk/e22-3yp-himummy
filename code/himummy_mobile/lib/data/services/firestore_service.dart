import 'package:cloud_firestore/cloud_firestore.dart';

/// Thin, injectable wrapper around Firestore operations used by repositories.
class FirestoreService {
  /// Creates a wrapper, defaulting to the initialized Firebase instance.
  FirestoreService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Firestore instance used by this service.
  final FirebaseFirestore firestore;

  /// Reads a document at [path].
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String path) =>
      firestore.doc(path).get();

  /// Adds a document to a collection and returns its generated reference.
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collectionPath,
    Map<String, Object?> data,
  ) =>
      firestore.collection(collectionPath).add(data);

  /// Sets a document at [path].
  Future<void> setDocument(String path, Map<String, Object?> data) =>
      firestore.doc(path).set(data);

  /// Updates a document at [path].
  Future<void> updateDocument(String path, Map<String, Object?> data) =>
      firestore.doc(path).update(data);

  /// Creates a Firestore write batch.
  WriteBatch batch() => firestore.batch();
}
