import 'package:flutter/material.dart';

import 'core/repositories/pen_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/app/app_controller.dart';
import 'features/shell/main_shell.dart';

class AntiShakeApp extends StatefulWidget {
  const AntiShakeApp({required this.repository, super.key});

  final PenRepository repository;

  @override
  State<AntiShakeApp> createState() => _AntiShakeAppState();
}

class _AntiShakeAppState extends State<AntiShakeApp> {
  late final AppController controller;

  @override
  void initState() {
    super.initState();
    controller = AppController(widget.repository);
  }

  @override
  void dispose() {
    controller.dispose();
    widget.repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能防抖笔',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: MainShell(controller: controller),
    );
  }
}
