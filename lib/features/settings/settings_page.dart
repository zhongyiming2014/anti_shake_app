import 'package:flutter/material.dart';

import '../../core/constants/pen_protocol_config.dart';
import '../app/app_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('设置与调试', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.science),
            title: Text('数据源'),
            subtitle: Text('Mock 防抖笔模拟器'),
            trailing: Chip(label: Text('开发模式')),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.speed),
                title: const Text('模拟采样率'),
                trailing: Text('${PenProtocolConfig.sampleRateHz} Hz'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.memory),
                title: const Text('固件版本'),
                trailing: Text(controller.deviceStatus.firmwareVersion),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '真机接入前待确认',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text('• BLE Service 与 Characteristic UUID'),
                Text('• 六轴数据单位、比例和字节序'),
                Text('• 采样率和数据帧长度'),
                Text('• 阻尼范围与命令 ACK 格式'),
                Text('• 电量、温度与故障状态字段'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
