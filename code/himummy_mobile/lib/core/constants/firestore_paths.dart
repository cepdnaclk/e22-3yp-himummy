/// Centralized builders for HiMummy Firestore document and collection paths.
abstract final class FirestorePaths {
  /// Root users collection.
  static const users = 'users';

  /// Root audit log collection.
  static const auditLogs = 'audit_logs';

  /// User profile document path.
  static String user(String uid) => '$users/$uid';

  /// Heart-rate readings collection path for a mother.
  static String heartRateReadings(String motherUid) =>
      '${user(motherUid)}/hr_readings';

  /// Room readings collection path for a mother.
  static String roomReadings(String motherUid) =>
      '${user(motherUid)}/room_readings';

  /// Check-ins collection path for a mother.
  static String checkins(String motherUid) => '${user(motherUid)}/checkins';

  /// Clinician notes collection path for a mother.
  static String clinicianNotes(String motherUid) =>
      '${user(motherUid)}/clinician_notes';
}
