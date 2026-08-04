enum PenConnectionPhase {
  disconnected,
  scanning,
  connecting,
  connected,
  error,
}

class PenConnectionStatus {
  const PenConnectionStatus({
    required this.phase,
    required this.message,
    this.deviceName,
  });

  const PenConnectionStatus.disconnected()
      : phase = PenConnectionPhase.disconnected,
        message = '尚未连接防抖笔',
        deviceName = null;

  final PenConnectionPhase phase;
  final String message;
  final String? deviceName;

  bool get isConnected => phase == PenConnectionPhase.connected;
}
