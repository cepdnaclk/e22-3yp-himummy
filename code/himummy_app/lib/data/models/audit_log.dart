import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/model_utils.dart';

/// Immutable record of a data-layer action.
class AuditLog {
  /// Creates and validates an audit record.
  AuditLog({
    required this.actorUid,
    required this.actorRole,
    required this.action,
    required this.targetPath,
    required this.timestamp,
  }) {
    validate();
  }

  /// UID of the acting user.
  final String actorUid;

  /// Role of the acting user.
  final String actorRole;

  /// Stable action name.
  final String action;

  /// Firestore path affected by the action.
  final String targetPath;

  /// Event time.
  final DateTime timestamp;

  /// Validates required values and actor role.
  void validate({DateTime? now}) {
    requireNonEmpty(actorUid, 'actor_uid');
    requireNonEmpty(action, 'action');
    requireNonEmpty(targetPath, 'target_path');
    if (actorRole != DataContract.motherRole &&
        actorRole != DataContract.clinicianRole) {
      throw const AppException(
        AppErrorCode.validation,
        'Audit actor role is not recognized.',
      );
    }
    requireFutureSafe(timestamp, 'timestamp', now: now);
  }

  /// Serializes using the Firestore contract field names.
  Map<String, Object?> toMap() {
    validate();
    return {
      DataContract.actorUid: actorUid,
      DataContract.actorRole: actorRole,
      DataContract.action: action,
      DataContract.targetPath: targetPath,
      DataContract.timestamp: timestamp,
    };
  }

  /// Parses and validates an audit map.
  factory AuditLog.fromMap(Map<String, Object?> map) => AuditLog(
    actorUid: parseString(map[DataContract.actorUid], 'actor_uid'),
    actorRole: parseString(map[DataContract.actorRole], 'actor_role'),
    action: parseString(map[DataContract.action], 'action'),
    targetPath: parseString(map[DataContract.targetPath], 'target_path'),
        timestamp: parseDateTime(map[DataContract.timestamp], 'timestamp'),
      );

  /// Creates a validated copy with selected values replaced.
  AuditLog copyWith({
    String? actorUid,
    String? actorRole,
    String? action,
    String? targetPath,
    DateTime? timestamp,
  }) =>
      AuditLog(
        actorUid: actorUid ?? this.actorUid,
        actorRole: actorRole ?? this.actorRole,
        action: action ?? this.action,
        targetPath: targetPath ?? this.targetPath,
        timestamp: timestamp ?? this.timestamp,
      );
}
