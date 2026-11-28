import 'package:himummy_mobile/core/constants/data_contract.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';

/// Role and patient-assignment checks shared by repositories and callers.
abstract final class RoleGuard {
  /// Returns true when [profile] has the mother role.
  static bool isMother(UserProfile? profile) =>
      profile?.role == DataContract.motherRole;

  /// Returns true when [profile] has the clinician role.
  static bool isClinician(UserProfile? profile) =>
      profile?.role == DataContract.clinicianRole;

  /// Returns true when [clinician] is assigned to [mother].
  static bool canViewPatient(UserProfile? clinician, UserProfile? mother) =>
      isClinician(clinician) &&
      isMother(mother) &&
      mother!.assignedClinicianUid == clinician!.uid;
}
