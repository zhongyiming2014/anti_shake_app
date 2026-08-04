import 'dart:async';
import 'dart:math';

import '../../core/constants/pen_protocol_config.dart';
import '../../core/repositories/pen_repository.dart';
import '../../shared/models/connection_status.dart';
import '../../shared/models/device_status.dart';
import '../../shared/models/sensor_sample.dart';

class MockPenRepository implements PenRepository {
  final _connectionController =
      StreamController<PenConnectionStatus>.broadcast();
  final _sensorController = StreamController<SensorSample>.broadcast();
  final _statusController = StreamController<DeviceStatus>.broadcast();
  final _random = Random();

  Timer? _sampleTimer;
  var _connected = false;
  var _sequence = 0;
  var _damping = 40;
  var _sampling = false;
  var _elapsedSeconds = 0.0;

  DeviceStatus get _status => DeviceStatus(
        batteryPercent: 86,
        temperatureCelsius: 31.5,
        firmwareVersion: 'MOCK-0.1',
        dampingLevel: _damping,
        minDamping: PenProtocolConfig.minDamping,
        maxDamping: PenProtocolConfig.maxDamping,
        isSampling: _sampling,
      );

  @override
  Stream<PenConnectionStatus> watchConnection() => _connectionController.stream;

  @override
  Stream<SensorSample> watchSensorData() => _sensorController.stream;

  @override
  Stream<DeviceStatus> watchDeviceStatus() => _statusController.stream;

  @override
  Future<List<PenDevice>> scan() async {
    _connectionController.add(const PenConnectionStatus(
      phase: PenConnectionPhase.scanning,
      message: '正在扫描附近设备…',
    ));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return const [
      PenDevice(id: 'mock-pen-001', name: 'AntiShake Pen Demo', rssi: -48),
    ];
  }

  @override
  Future<void> connect(String deviceId) async {
    _connectionController.add(const PenConnectionStatus(
      phase: PenConnectionPhase.connecting,
      message: '正在连接模拟防抖笔…',
      deviceName: 'AntiShake Pen Demo',
    ));
    await Future<void>.delayed(const Duration(milliseconds: 650));
    _connected = true;
    _connectionController.add(const PenConnectionStatus(
      phase: PenConnectionPhase.connected,
      message: '模拟设备已连接',
      deviceName: 'AntiShake Pen Demo',
    ));
    _statusController.add(_status);
    _startSampleTimer();
  }

  void _startSampleTimer() {
    _sampleTimer?.cancel();
    final interval = Duration(
      milliseconds: (1000 / PenProtocolConfig.sampleRateHz).round(),
    );
    _sampleTimer = Timer.periodic(interval, (_) {
      if (!_connected) return;
      _elapsedSeconds += interval.inMilliseconds / 1000;
      final dampingFactor = 1 - (_damping / 140);
      final tremorWave = sin(_elapsedSeconds * pi * 9) * dampingFactor;
      final writingWave = sin(_elapsedSeconds * pi * 1.4) * 0.28;
      final noise = (_random.nextDouble() - 0.5) * 0.08;
      final intensity =
          (tremorWave.abs() * 0.78 + noise.abs()).clamp(0.0, 1.0).toDouble();

      _sensorController.add(SensorSample(
        sequence: _sequence++,
        timestamp: DateTime.now(),
        ax: writingWave + tremorWave * 0.65 + noise,
        ay: writingWave * 0.7 + tremorWave * 0.48 - noise,
        az: 1 + tremorWave * 0.25 + noise,
        gx: tremorWave * 90 + noise * 10,
        gy: tremorWave * 72 - noise * 8,
        gz: tremorWave * 54 + noise * 6,
        tremorIntensity: intensity,
        dampingLevel: _damping,
      ));
    });
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _sampling = false;
    _sampleTimer?.cancel();
    _connectionController.add(const PenConnectionStatus.disconnected());
    _statusController.add(const DeviceStatus.initial());
  }

  @override
  Future<CommandResult> setDamping(int value) async {
    if (!_connected) {
      return const CommandResult(success: false, message: '设备未连接');
    }
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _damping = value
        .clamp(
          PenProtocolConfig.minDamping,
          PenProtocolConfig.maxDamping,
        )
        .toInt();
    _statusController.add(_status);
    return CommandResult(
      success: true,
      message: '设备已确认阻尼设置',
      appliedValue: _damping,
    );
  }

  @override
  Future<CommandResult> calibrate() async {
    if (!_connected) {
      return const CommandResult(success: false, message: '设备未连接');
    }
    await Future<void>.delayed(const Duration(seconds: 1));
    return const CommandResult(success: true, message: '模拟校准完成');
  }

  @override
  Future<CommandResult> startSampling() async {
    if (!_connected) {
      return const CommandResult(success: false, message: '设备未连接');
    }
    _sampling = true;
    _statusController.add(_status);
    return const CommandResult(success: true, message: '已开始记录');
  }

  @override
  Future<CommandResult> stopSampling() async {
    _sampling = false;
    if (_connected) _statusController.add(_status);
    return const CommandResult(success: true, message: '记录已结束');
  }

  @override
  void dispose() {
    _sampleTimer?.cancel();
    _connectionController.close();
    _sensorController.close();
    _statusController.close();
  }
}
