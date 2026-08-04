class SessionSummary {
  const SessionSummary({
    required this.startedAt,
    required this.endedAt,
    required this.sampleCount,
    required this.averageTremor,
    required this.maximumTremor,
    required this.averageDamping,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final int sampleCount;
  final double averageTremor;
  final double maximumTremor;
  final double averageDamping;

  Duration get duration => endedAt.difference(startedAt);
}
