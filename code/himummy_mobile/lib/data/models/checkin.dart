import 'package:himummy_mobile/core/errors/app_exception.dart';
import 'package:himummy_mobile/data/models/model_utils.dart';

/// Questionnaire submission and consent state.
class Checkin {
  /// Creates and validates a check-in.
  Checkin({
    required this.answers,
    required this.submittedAt,
    required this.consentGiven,
  }) {
    validate();
  }

  /// Answer values keyed by question identifier.
  final Map<String, Object?> answers;

  /// Submission time.
  final DateTime submittedAt;

  /// Whether the user consented to save the questionnaire.
  final bool consentGiven;

  /// Validates consent, answer content, and timestamp.
  void validate({DateTime? now}) {
    if (!consentGiven) {
      throw const AppException(
        AppErrorCode.validation,
        'Consent is required to submit a check-in.',
      );
    }
    if (answers.isEmpty || answers.keys.any((key) => key.trim().isEmpty)) {
      throw const AppException(
        AppErrorCode.validation,
        'Check-in answers must contain at least one named answer.',
      );
    }
    requireFutureSafe(submittedAt, 'submitted_at', now: now);
  }

  /// Serializes using the Firestore contract field names.
  Map<String, Object?> toMap() {
    validate();
    return {
      'answers': Map<String, Object?>.from(answers),
      'submitted_at': submittedAt,
      'consent_given': consentGiven,
    };
  }

  /// Parses and validates a Firestore check-in map.
  factory Checkin.fromMap(Map<String, Object?> map) => Checkin(
    answers: parseMap(map['answers'], 'answers'),
        submittedAt: parseDateTime(map['submitted_at'], 'submitted_at'),
    consentGiven: parseBool(map['consent_given'], 'consent_given'),
      );

  /// Creates a validated copy with selected values replaced.
  Checkin copyWith({
    Map<String, Object?>? answers,
    DateTime? submittedAt,
    bool? consentGiven,
  }) =>
      Checkin(
        answers: answers ?? this.answers,
        submittedAt: submittedAt ?? this.submittedAt,
        consentGiven: consentGiven ?? this.consentGiven,
      );
}
