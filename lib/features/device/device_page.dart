import 'package:flutter/material.dart';

import '../../shared/models/connection_status.dart';
import '../../shared/widgets/metric_card.dart';
import '../app/app_controller.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final connection = controller.connection;
    final busy = connection.phase == PenConnectionPhase.scanning ||
        connection.phase == PenConnectionPhase.connecting;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('我的防抖笔', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  connection.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_searching,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  connection.deviceName ?? 'AntiShake Pen',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(connection.message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                if (connection.isConnected)
                  OutlinedButton.icon(
                    onPressed: controller.disconnect,
                    icon: const Icon(Icons.link_off),
                    label: const Text('断开连接'),
                  )
                else
                  FilledButton.icon(
                    onPressed: busy ? null : controller.connectDemo,
                    icon: busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.bluetooth_searching),
                    label: Text(busy ? '连接中…' : '连接模拟防抖笔'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: '电量',
                value: connection.isConnected
                    ? '${controller.deviceStatus.batteryPercent}%'
                    : '--',
                icon: Icons.battery_5_bar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: '温度',
                value: connection.isConnected
                    ? '${controller.deviceStatus.temperatureCelsius.toStringAsFixed(1)}℃'
                    : '--',
                icon: Icons.thermostat,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '当前为 Mock 模式，不需要真实 ESP32。以后只需替换 BLE Repository，页面与报告逻辑无需重写。',
            ),
          ),
        ),
      ],
    );
  }
}
