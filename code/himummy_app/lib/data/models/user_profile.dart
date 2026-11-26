import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/model_utils.dart';

/// Persisted user identity and role profile.
class UserProfile {
  /// Creates and validates a profile.
  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.role,
    required this.createdAt,
    this.assignedClinicianUid,
  }) {
    validate();
  }

  /// Firebase Authentication UID.
  final String uid;

  /// User-facing display name.
  final String displayName;

  /// Account email.
  final String email;

  /// `mother` or `clinician`.
  final String role;

  /// Assigned clinician UID; present only for mother profiles.
  final String? assignedClinicianUid;

  /// Profile creation time.
  final DateTime createdAt;

  /// Validates profile data.
  void validate() {
    requireNonEmpty(uid, 'uid');
    requireNonEmpty(displayName, 'display_name');
    requireNonEmpty(email, 'email');
    if (role != DataContract.motherRole &&
        role != DataContract.clinicianRole) {
      throw const AppException(
        AppErrorCode.validation,
        'Role must be mother or clinician.',
      );
    }
    if (role == DataContract.motherRole &&
        (assignedClinicianUid == null || assignedClinicianUid!.isEmpty)) {
      throw const AppException(
        AppErrorCode.validation,
        'Mother profiles require an assigned clinician.',
      );
    }
    if (role == DataContract.clinicianRole && assignedClinicianUid != null) {
      throw const AppException(
        AppErrorCode.validation,
        'Clinician profiles cannot have an assigned clinician.',
      );
    }
    requireFutureSafe(createdAt, 'created_at');
  }

  /// Serializes this profile using the Firestore contract field names.
  Map<String, Object?> toMap() {
    validate();
    return {
      'display_name': displayName,
      'email': email,
      'role': role,
      if (assignedClinicianUid != null)
        'assigned_clinician_uid': assignedClinicianUid,
      'created_at': createdAt,
    };
  }

  /// Parses and validates a Firestore profile map.
  factory UserProfile.fromMap(String uid, Map<String, Object?> map) =>
      UserProfile(
        uid: uid,
        displayName: parseString(map['display_name'], 'display_name'),
        email: parseString(map['email'], 'email'),
        role: parseString(map['role'], 'role'),
        assignedClinicianUid: parseOptionalString(
          map['assigned_clinician_uid'],
          'assigned_clinician_uid',
        ),
        createdAt: parseDateTime(map['created_at'], 'created_at'),
      );

  /// Creates a validated copy with selected values replaced.
  UserProfile copyWith({
    String? displayName,
    String? email,
    String? role,
    String? assignedClinicianUid,
    DateTime? createdAt,
  }) =>
      UserProfile(
        uid: uid,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        role: role ?? this.role,
        assignedClinicianUid:
            assignedClinicianUid ?? this.assignedClinicianUid,
        createdAt: createdAt ?? this.createdAt,
      );
}
