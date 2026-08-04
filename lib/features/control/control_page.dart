import 'package:flutter/material.dart';

import '../app/app_controller.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final status = controller.deviceStatus;
    final enabled = controller.connection.isConnected &&
        !controller.isCommandPending;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('阻尼控制', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('ESP32 始终负责最终限幅和安全保护。'),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('当前阻尼等级'),
                const SizedBox(height: 8),
                Text(
                  '${status.dampingLevel}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    for (final preset in const [
                      ('弱', 25),
                      ('中', 50),
                      ('强', 75),
                    ]) ...[
                      Expanded(
                        child: FilledButton(
                          onPressed: enabled
                              ? () => controller.setDamping(preset.$2)
                              : null,
                          child: Text(preset.$1),
                        ),
                      ),
                      if (preset.$2 != 75) const SizedBox(width: 10),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: enabled
                              ? () => controller.setDamping(
                                    (status.dampingLevel - 5)
                                        .clamp(
                                          status.minDamping,
                                          status.maxDamping,
                                        )
                                        .toInt(),
                                  )
                            : null,
                        icon: const Icon(Icons.remove),
                        label: const Text('降低 5'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: enabled
                              ? () => controller.setDamping(
                                    (status.dampingLevel + 5)
                                        .clamp(
                                          status.minDamping,
                                          status.maxDamping,
                                        )
                                        .toInt(),
                                  )
                            : null,
                        icon: const Icon(Icons.add),
                        label: const Text('提高 5'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: enabled ? controller.calibrate : null,
          icon: const Icon(Icons.center_focus_strong),
          label: const Text('静止校准'),
        ),
        if (controller.notice != null) ...[
          const SizedBox(height: 12),
          Text(controller.notice!, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}
