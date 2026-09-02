import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'data/mock/mock_pen_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the bundled Chinese font before the first frame. Flutter Web would
  // otherwise fetch a fallback font lazily, causing temporary tofu/mojibake.
  final fontLoader = FontLoader('NotoSansSC')
    ..addFont(rootBundle.load('assets/fonts/NotoSansSC-AppSubset.ttf'));
  await fontLoader.load();

  runApp(AntiShakeApp(repository: MockPenRepository()));
}
