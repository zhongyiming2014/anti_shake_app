import 'package:flutter/material.dart';

import 'app.dart';
import 'data/mock/mock_pen_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AntiShakeApp(repository: MockPenRepository()));
}
