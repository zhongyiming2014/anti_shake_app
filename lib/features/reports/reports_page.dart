import 'package:flutter/material.dart';

import '../app/app_controller.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({required this.controller, super.key});

  final AppController controller;

  String _time(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${value.month}/${value.day} ${two(value.hour)}:${two(value.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('书写报告', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (controller.sessions.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.description_outlined, size: 52),
                  SizedBox(height: 12),
                  Text('暂无记录'),
                  SizedBox(height: 6),
                  Text('连接设备后，在“监测”页完成一次书写记录。'),
                ],
              ),
            ),
          )
        else
          for (final session in controller.sessions) ...[
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(child: Icon(Icons.edit_note)),
                title: Text('${_time(session.startedAt)} 的书写记录'),
                subtitle: Text(
                  '时长 ${session.duration.inSeconds} 秒 · '
                  '平均震颤 ${(session.averageTremor * 100).toStringAsFixed(1)}% · '
                  '最大震颤 ${(session.maximumTremor * 100).toStringAsFixed(1)}%\n'
                  '平均阻尼 ${session.averageDamping.toStringAsFixed(0)} · '
                  '${session.sampleCount} 个样本',
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 8),
        const Text(
          '提示：报告仅反映设备采集的运动数据，不构成医疗诊断或治疗建议。',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
