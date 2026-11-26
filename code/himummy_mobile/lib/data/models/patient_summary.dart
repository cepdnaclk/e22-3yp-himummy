import 'package:himummy_mobile/data/models/checkin.dart';
import 'package:himummy_mobile/data/models/hr_reading.dart';
import 'package:himummy_mobile/data/models/room_reading.dart';
import 'package:himummy_mobile/data/models/user_profile.dart';

/// Latest available data for an assigned mother.
class PatientSummary {
  /// Creates a patient summary.
  const PatientSummary({
    required this.profile,
    this.latestHrReading,
    this.latestRoomReading,
    this.latestCheckin,
  });

  /// Mother's profile.
  final UserProfile profile;

  /// Newest saved heart-rate estimate, when available.
  final HrReading? latestHrReading;

  /// Newest saved room reading, when available.
  final RoomReading? latestRoomReading;

  /// Newest check-in, when available.
  final Checkin? latestCheckin;
}
