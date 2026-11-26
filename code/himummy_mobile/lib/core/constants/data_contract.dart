/// Canonical Firestore collection, field, role, and enum values.
abstract final class DataContract {
  /// Mother role value stored in `users/{uid}.role`.
  static const motherRole = 'mother';

  /// Clinician role value stored in `users/{uid}.role`.
  static const clinicianRole = 'clinician';

  /// Accepted heart-rate signal quality values.
  static const signalQualities = <String>{'good', 'fair', 'poor', 'invalid'};

  /// Accepted clinician-note review states.
  static const reviewStatuses = <String>{'pending', 'reviewed', 'follow_up'};

  /// Heart rate is an estimate, measured in beats per minute.
  static const heartRateBpm = 'heart_rate_bpm';

  /// Heart-rate capture timestamp.
  static const recordedAt = 'recorded_at';

  /// Heart-rate signal quality.
  static const signalQuality = 'signal_quality';

  /// Origin descriptor for a saved reading.
  static const source = 'source';

  /// Room temperature in degrees Celsius.
  static const roomTempC = 'room_temp_c';

  /// Relative humidity percentage.
  static const humidityPercent = 'humidity_percent';

  /// Latest room reading timestamp.
  static const updatedAt = 'updated_at';

  /// Check-in answers map.
  static const answers = 'answers';

  /// Check-in submission timestamp.
  static const submittedAt = 'submitted_at';

  /// Check-in consent value.
  static const consentGiven = 'consent_given';

  /// Clinician note content.
  static const noteText = 'note_text';

  /// UID of the note author.
  static const authorUid = 'author_uid';

  /// Display name of the note author.
  static const authorName = 'author_name';

  /// Note creation timestamp.
  static const createdAt = 'created_at';

  /// Clinician note review status.
  static const reviewStatus = 'review_status';

  /// Audit actor UID.
  static const actorUid = 'actor_uid';

  /// Audit actor role.
  static const actorRole = 'actor_role';

  /// Audit operation name.
  static const action = 'action';

  /// Audit target document path.
  static const targetPath = 'target_path';

  /// Audit event timestamp.
  static const timestamp = 'timestamp';
}
