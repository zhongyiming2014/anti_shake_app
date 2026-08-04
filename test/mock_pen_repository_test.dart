import 'package:anti_shake_app/data/mock/mock_pen_repository.dart';
import 'package:anti_shake_app/shared/models/connection_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock repository connects and produces sensor samples', () async {
    final repository = MockPenRepository();
    addTearDown(repository.dispose);

    final connected = repository
        .watchConnection()
        .firstWhere((state) => state.phase == PenConnectionPhase.connected);
    final devices = await repository.scan();
    expect(devices, isNotEmpty);

    await repository.connect(devices.first.id);
    expect((await connected).isConnected, isTrue);

    final sample = await repository.watchSensorData().first;
    expect(sample.sequence, greaterThanOrEqualTo(0));
    expect(sample.tremorIntensity, inInclusiveRange(0, 1));
  });

  test('mock damping command returns the applied value', () async {
    final repository = MockPenRepository();
    addTearDown(repository.dispose);
    final devices = await repository.scan();
    await repository.connect(devices.first.id);

    final result = await repository.setDamping(65);

    expect(result.success, isTrue);
    expect(result.appliedValue, 65);
  });
}
