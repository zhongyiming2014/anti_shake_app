import '../../shared/models/connection_status.dart';
import '../../shared/models/device_status.dart';
import '../../shared/models/sensor_sample.dart';

abstract interface class PenRepository {
  Stream<PenConnectionStatus> watchConnection();
  Stream<SensorSample> watchSensorData();
  Stream<DeviceStatus> watchDeviceStatus();

  Future<List<PenDevice>> scan();
  Future<void> connect(String deviceId);
  Future<void> disconnect();
  Future<CommandResult> setDamping(int value);
  Future<CommandResult> calibrate();
  Future<CommandResult> startSampling();
  Future<CommandResult> stopSampling();
  void dispose();
}

class PenDevice {
  const PenDevice({required this.id, required this.name, required this.rssi});

  final String id;
  final String name;
  final int rssi;
}

class CommandResult {
  const CommandResult({
    required this.success,
    required this.message,
    this.appliedValue,
  });

  final bool success;
  final String message;
  final int? appliedValue;
}
