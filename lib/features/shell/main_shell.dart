import 'package:flutter/material.dart';

import '../app/app_controller.dart';
import '../control/control_page.dart';
import '../device/device_page.dart';
import '../monitor/monitor_page.dart';
import '../reports/reports_page.dart';
import '../settings/settings_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({required this.controller, super.key});

  final AppController controller;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final pages = [
          DevicePage(controller: widget.controller),
          MonitorPage(controller: widget.controller),
          ControlPage(controller: widget.controller),
          ReportsPage(controller: widget.controller),
          SettingsPage(controller: widget.controller),
        ];
        return Scaffold(
          appBar: AppBar(
            title: const Text('智能防抖笔'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    widget.controller.connection.isConnected
                        ? '● 已连接'
                        : '○ 未连接',
                    style: TextStyle(
                      color: widget.controller.connection.isConnected
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(child: pages[_index]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.bluetooth), label: '设备'),
              NavigationDestination(
                  icon: Icon(Icons.monitor_heart), label: '监测'),
              NavigationDestination(icon: Icon(Icons.tune), label: '控制'),
              NavigationDestination(icon: Icon(Icons.description), label: '报告'),
              NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
            ],
          ),
        );
      },
    );
  }
}
