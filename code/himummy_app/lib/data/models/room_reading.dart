import 'package:himummy/core/constants/data_contract.dart';
import 'package:himummy/core/errors/app_exception.dart';
import 'package:himummy/data/models/model_utils.dart';

/// Room temperature and humidity reading from the baby monitor.
class RoomReading {
  /// Creates and validates a room reading.
  RoomReading({
    required this.roomTempC,
    required this.humidityPercent,
    required this.updatedAt,
    required this.source,
  }) {
    validate();
  }

  /// Room temperature in degrees Celsius.
  final double roomTempC;

  /// Relative humidity percentage.
  final double humidityPercent;

  /// Reading update time.
  final DateTime updatedAt;

  /// Reading origin.
  final String source;

  /// Validates room ranges and timestamp.
  void validate({DateTime? now}) {
    if (!roomTempC.isFinite || roomTempC < -10 || roomTempC > 60) {
      throw const AppException(
        AppErrorCode.validation,
        'Room temperature must be between -10 and 60 C.',
      );
    }
    if (!humidityPercent.isFinite ||
        humidityPercent < 0 ||
        humidityPercent > 100) {
      throw const AppException(
        AppErrorCode.validation,
        'Humidity must be between 0 and 100 percent.',
      );
    }
    requireNonEmpty(source, 'source');
    requireFutureSafe(updatedAt, 'updated_at', now: now);
  }

  /// Serializes using the Firestore contract field names.
  Map<String, Object?> toMap() {
    validate();
    return {
      DataContract.roomTempC: roomTempC,
      DataContract.humidityPercent: humidityPercent,
      DataContract.updatedAt: updatedAt,
      DataContract.source: source,
    };
  }

  /// Parses and validates a Firestore room reading map.
  factory RoomReading.fromMap(Map<String, Object?> map) => RoomReading(
    roomTempC: parseDouble(map[DataContract.roomTempC], 'room_temp_c'),
    humidityPercent:
        parseDouble(map[DataContract.humidityPercent], 'humidity_percent'),
        updatedAt: parseDateTime(map[DataContract.updatedAt], 'updated_at'),
    source: parseString(map[DataContract.source], 'source'),
      );

  /// Creates a validated copy with selected values replaced.
  RoomReading copyWith({
    double? roomTempC,
    double? humidityPercent,
    DateTime? updatedAt,
    String? source,
  }) =>
      RoomReading(
        roomTempC: roomTempC ?? this.roomTempC,
        humidityPercent: humidityPercent ?? this.humidityPercent,
        updatedAt: updatedAt ?? this.updatedAt,
        source: source ?? this.source,
      );
}
