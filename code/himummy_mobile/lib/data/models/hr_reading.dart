import 'package:himummy_mobile/core/constants/data_contract.dart';
import 'package:himummy_mobile/core/errors/app_exception.dart';
import 'package:himummy_mobile/data/models/model_utils.dart';

/// A saved heart-rate estimate received from a wearable or synthetic source.
class HrReading {
  /// Creates and validates a reading.
  HrReading({
    required this.heartRateBpm,
    required this.recordedAt,
    required this.signalQuality,
    required this.source,
  }) {
    validate();
  }

  /// Estimated heart rate in beats per minute.
  final int heartRateBpm;

  /// Time the wearable reading was captured.
  final DateTime recordedAt;

  /// Signal quality: good, fair, poor, or invalid.
  final String signalQuality;

  /// Reading origin, such as wearable_ble or synthetic.
  final String source;

  /// Validates ranges while retaining poor and invalid signal readings.
  void validate({DateTime? now}) {
    if (heartRateBpm < 30 || heartRateBpm > 220) {
      throw const AppException(
        AppErrorCode.validation,
        'Heart-rate estimate must be between 30 and 220 bpm.',
      );
    }
    if (!DataContract.signalQualities.contains(signalQuality)) {
      throw const AppException(
        AppErrorCode.validation,
        'Signal quality is not recognized.',
      );
    }
    requireNonEmpty(source, 'source');
    requireFutureSafe(recordedAt, 'recorded_at', now: now);
  }

  /// Serializes using the Firestore contract field names.
  Map<String, Object?> toMap() {
    validate();
    return {
      DataContract.heartRateBpm: heartRateBpm,
      DataContract.recordedAt: recordedAt,
      DataContract.signalQuality: signalQuality,
      DataContract.source: source,
    };
  }

  /// Parses and validates a Firestore reading map.
  factory HrReading.fromMap(Map<String, Object?> map) => HrReading(
    heartRateBpm:
        parseInt(map[DataContract.heartRateBpm], DataContract.heartRateBpm),
        recordedAt: parseDateTime(map[DataContract.recordedAt], 'recorded_at'),
    signalQuality:
        parseString(map[DataContract.signalQuality], 'signal_quality'),
    source: parseString(map[DataContract.source], 'source'),
      );

  /// Creates a validated copy with selected values replaced.
  HrReading copyWith({
    int? heartRateBpm,
    DateTime? recordedAt,
    String? signalQuality,
    String? source,
  }) =>
      HrReading(
        heartRateBpm: heartRateBpm ?? this.heartRateBpm,
        recordedAt: recordedAt ?? this.recordedAt,
        signalQuality: signalQuality ?? this.signalQuality,
        source: source ?? this.source,
      );
}
