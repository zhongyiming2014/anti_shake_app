class SensorSample {
  const SensorSample({
    required this.sequence,
    required this.timestamp,
    required this.ax,
    required this.ay,
    required this.az,
    required this.gx,
    required this.gy,
    required this.gz,
    required this.tremorIntensity,
    required this.dampingLevel,
  });

  final int sequence;
  final DateTime timestamp;
  final double ax;
  final double ay;
  final double az;
  final double gx;
  final double gy;
  final double gz;
  final double tremorIntensity;
  final int dampingLevel;
}
