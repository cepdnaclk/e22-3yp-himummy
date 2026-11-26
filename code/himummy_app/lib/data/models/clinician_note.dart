import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/model_utils.dart';

/// Clinician-authored follow-up note.
class ClinicianNote {
  /// Creates and validates a clinician note.
  ClinicianNote({
    required this.noteText,
    required this.authorUid,
    required this.authorName,
    required this.createdAt,
    required this.reviewStatus,
  }) {
    validate();
  }

  /// Note content.
  final String noteText;

  /// UID of the clinician author.
  final String authorUid;

  /// Display name of the clinician author.
  final String authorName;

  /// Creation timestamp.
  final DateTime createdAt;

  /// pending, reviewed, or follow_up.
  final String reviewStatus;

  /// Validates required fields and review status.
  void validate({DateTime? now}) {
    requireNonEmpty(noteText, 'note_text');
    requireNonEmpty(authorUid, 'author_uid');
    requireNonEmpty(authorName, 'author_name');
    if (!DataContract.reviewStatuses.contains(reviewStatus)) {
      throw const AppException(
        AppErrorCode.validation,
        'Review status is not recognized.',
      );
    }
    requireFutureSafe(createdAt, 'created_at', now: now);
  }

  /// Serializes using the Firestore contract field names.
  Map<String, Object?> toMap() {
    validate();
    return {
      DataContract.noteText: noteText,
      DataContract.authorUid: authorUid,
      DataContract.authorName: authorName,
      DataContract.createdAt: createdAt,
      DataContract.reviewStatus: reviewStatus,
    };
  }

  /// Parses and validates a Firestore clinician note map.
  factory ClinicianNote.fromMap(Map<String, Object?> map) => ClinicianNote(
    noteText: parseString(map[DataContract.noteText], 'note_text'),
    authorUid: parseString(map[DataContract.authorUid], 'author_uid'),
    authorName: parseString(map[DataContract.authorName], 'author_name'),
        createdAt: parseDateTime(map[DataContract.createdAt], 'created_at'),
    reviewStatus:
        parseString(map[DataContract.reviewStatus], 'review_status'),
      );

  /// Creates a validated copy with selected values replaced.
  ClinicianNote copyWith({
    String? noteText,
    String? authorUid,
    String? authorName,
    DateTime? createdAt,
    String? reviewStatus,
  }) =>
      ClinicianNote(
        noteText: noteText ?? this.noteText,
        authorUid: authorUid ?? this.authorUid,
        authorName: authorName ?? this.authorName,
        createdAt: createdAt ?? this.createdAt,
        reviewStatus: reviewStatus ?? this.reviewStatus,
      );
}
