import 'package:flutter/material.dart';

import '../../shared/widgets/metric_card.dart';
import '../app/app_controller.dart';
import 'sensor_chart.dart';

class MonitorPage extends StatelessWidget {
  const MonitorPage({required this.controller, super.key});

  final AppController controller;

  String _tremorLabel(double value) {
    if (value < 0.3) return '轻微';
    if (value < 0.65) return '中等';
    return '明显';
  }

  @override
  Widget build(BuildContext context) {
    final sample = controller.latestSample;
    final intensity = sample?.tremorIntensity ?? 0;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('实时监测', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: '震颤状态',
                value: sample == null ? '--' : _tremorLabel(intensity),
                icon: Icons.waves,
                color: intensity > 0.65 ? Colors.orange.shade800 : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: '当前阻尼',
                value: '${controller.deviceStatus.dampingLevel}',
                icon: Icons.tune,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '三轴加速度（模拟）',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Text('— X', style: TextStyle(color: Colors.red)),
                    SizedBox(width: 16),
                    Text('— Y', style: TextStyle(color: Colors.green)),
                    SizedBox(width: 16),
                    Text('— Z', style: TextStyle(color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 8),
                SensorChart(samples: controller.samples),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: controller.connection.isConnected
              ? (controller.isRecording
                  ? controller.stopSession
                  : controller.startSession)
              : null,
          icon: Icon(controller.isRecording ? Icons.stop : Icons.play_arrow),
          label: Text(controller.isRecording ? '结束本次书写' : '开始记录书写'),
          style: FilledButton.styleFrom(
            backgroundColor:
                controller.isRecording ? Colors.red.shade700 : null,
          ),
        ),
        if (controller.notice != null) ...[
          const SizedBox(height: 12),
          Text(controller.notice!, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}
