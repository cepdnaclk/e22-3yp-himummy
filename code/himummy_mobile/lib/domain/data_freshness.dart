/// Returns whether [timestamp] is older than [threshold] relative to [now].
bool isStale(
  DateTime timestamp,
  Duration threshold, {
  DateTime? now,
}) {
  if (threshold.isNegative) {
    throw ArgumentError.value(threshold, 'threshold', 'Cannot be negative.');
  }
  final reference = now ?? DateTime.now();
  return reference.difference(timestamp) > threshold;
}
