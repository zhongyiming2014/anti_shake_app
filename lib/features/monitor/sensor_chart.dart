import 'dart:math';

import 'package:flutter/material.dart';

import '../../shared/models/sensor_sample.dart';

class SensorChart extends StatelessWidget {
  const SensorChart({required this.samples, super.key});

  final List<SensorSample> samples;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: CustomPaint(
        painter: _SensorChartPainter(samples),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SensorChartPainter extends CustomPainter {
  _SensorChartPainter(this.samples);

  final List<SensorSample> samples;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFDDE6F0)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (samples.length < 2) return;
    final visible = samples.length > 150
        ? samples.sublist(samples.length - 150)
        : samples;
    final maxValue = visible.fold<double>(
      1,
      (current, sample) => max(
        current,
        max(sample.ax.abs(), max(sample.ay.abs(), sample.az.abs())),
      ),
    );

    void drawAxis(double Function(SensorSample) read, Color color) {
      final path = Path();
      for (var i = 0; i < visible.length; i++) {
        final x = size.width * i / (visible.length - 1);
        final normalized = read(visible[i]) / maxValue;
        final y = size.height / 2 - normalized * size.height * 0.42;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }

    drawAxis((sample) => sample.ax, Colors.red);
    drawAxis((sample) => sample.ay, Colors.green);
    drawAxis((sample) => sample.az - 1, Colors.blue);
  }

  @override
  bool shouldRepaint(covariant _SensorChartPainter oldDelegate) => true;
}
