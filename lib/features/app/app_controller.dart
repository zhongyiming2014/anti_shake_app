import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/repositories/pen_repository.dart';
import '../../shared/models/connection_status.dart';
import '../../shared/models/device_status.dart';
import '../../shared/models/sensor_sample.dart';
import '../../shared/models/session_summary.dart';

class AppController extends ChangeNotifier {
  AppController(this._repository) {
    _subscriptions.add(
      _repository.watchConnection().listen((value) {
        connection = value;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _repository.watchDeviceStatus().listen((value) {
        deviceStatus = value;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _repository.watchSensorData().listen(_onSample),
    );
  }

  final PenRepository _repository;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final List<SensorSample> _samples = [];
  final List<SessionSummary> sessions = [];

  PenConnectionStatus connection = const PenConnectionStatus.disconnected();
  DeviceStatus deviceStatus = const DeviceStatus.initial();
  bool isRecording = false;
  bool isCommandPending = false;
  String? notice;
  DateTime? _sessionStart;
  double _tremorTotal = 0;
  double _tremorMaximum = 0;
  double _dampingTotal = 0;
  int _sessionSampleCount = 0;

  List<SensorSample> get samples => List.unmodifiable(_samples);
  SensorSample? get latestSample => _samples.isEmpty ? null : _samples.last;

  void _onSample(SensorSample sample) {
    _samples.add(sample);
    if (_samples.length > 250) _samples.removeAt(0);

    if (isRecording) {
      _sessionSampleCount++;
      _tremorTotal += sample.tremorIntensity;
      _dampingTotal += sample.dampingLevel;
      if (sample.tremorIntensity > _tremorMaximum) {
        _tremorMaximum = sample.tremorIntensity;
      }
    }
    notifyListeners();
  }

  Future<void> connectDemo() async {
    notice = null;
    notifyListeners();
    final devices = await _repository.scan();
    if (devices.isEmpty) {
      notice = '未发现设备';
      notifyListeners();
      return;
    }
    await _repository.connect(devices.first.id);
  }

  Future<void> disconnect() => _repository.disconnect();

  Future<void> setDamping(int value) async {
    isCommandPending = true;
    notice = '等待设备确认…';
    notifyListeners();
    final result = await _repository.setDamping(value);
    isCommandPending = false;
    notice = result.message;
    notifyListeners();
  }

  Future<void> calibrate() async {
    isCommandPending = true;
    notice = '请保持笔体静止…';
    notifyListeners();
    final result = await _repository.calibrate();
    isCommandPending = false;
    notice = result.message;
    notifyListeners();
  }

  Future<void> startSession() async {
    final result = await _repository.startSampling();
    notice = result.message;
    if (!result.success) {
      notifyListeners();
      return;
    }
    isRecording = true;
    _sessionStart = DateTime.now();
    _tremorTotal = 0;
    _tremorMaximum = 0;
    _dampingTotal = 0;
    _sessionSampleCount = 0;
    notifyListeners();
  }

  Future<void> stopSession() async {
    final result = await _repository.stopSampling();
    final startedAt = _sessionStart;
    if (isRecording && startedAt != null && _sessionSampleCount > 0) {
      sessions.insert(
        0,
        SessionSummary(
          startedAt: startedAt,
          endedAt: DateTime.now(),
          sampleCount: _sessionSampleCount,
          averageTremor: _tremorTotal / _sessionSampleCount,
          maximumTremor: _tremorMaximum,
          averageDamping: _dampingTotal / _sessionSampleCount,
        ),
      );
    }
    isRecording = false;
    _sessionStart = null;
    notice = result.message;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
