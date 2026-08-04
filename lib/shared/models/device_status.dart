class DeviceStatus {
  const DeviceStatus({
    required this.batteryPercent,
    required this.temperatureCelsius,
    required this.firmwareVersion,
    required this.dampingLevel,
    required this.minDamping,
    required this.maxDamping,
    required this.isSampling,
  });

  const DeviceStatus.initial()
      : batteryPercent = 0,
        temperatureCelsius = 0,
        firmwareVersion = '--',
        dampingLevel = 0,
        minDamping = 0,
        maxDamping = 100,
        isSampling = false;

  final int batteryPercent;
  final double temperatureCelsius;
  final String firmwareVersion;
  final int dampingLevel;
  final int minDamping;
  final int maxDamping;
  final bool isSampling;

  DeviceStatus copyWith({
    int? batteryPercent,
    double? temperatureCelsius,
    String? firmwareVersion,
    int? dampingLevel,
    int? minDamping,
    int? maxDamping,
    bool? isSampling,
  }) {
    return DeviceStatus(
      batteryPercent: batteryPercent ?? this.batteryPercent,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      dampingLevel: dampingLevel ?? this.dampingLevel,
      minDamping: minDamping ?? this.minDamping,
      maxDamping: maxDamping ?? this.maxDamping,
      isSampling: isSampling ?? this.isSampling,
    );
  }
}
