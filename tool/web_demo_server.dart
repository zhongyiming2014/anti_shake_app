import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.writeln('Missing build/web directory.');
    exitCode = 1;
    return;
  }

  final webRoot = Directory(arguments.first).absolute;
  final indexFile = File(
    '${webRoot.path}${Platform.pathSeparator}index.html',
  );
  if (!indexFile.existsSync()) {
    stderr.writeln('Web build not found: ${webRoot.path}');
    exitCode = 1;
    return;
  }

  final server = await _bindAvailablePort();
  final url = 'http://127.0.0.1:${server.port}';

  stdout.writeln('Anti-shake Pen Web Demo: $url');
  stdout.writeln('Close this window or press Q then Enter to stop.');
  stdout.writeln('No temporary drive letter is being used.');

  if (Platform.environment['WEB_DEMO_NO_BROWSER'] != '1') {
    unawaited(_openBrowser(url));
  }

  var closing = false;
  StreamSubscription<String>? inputSubscription;
  Future<void> closeServer() async {
    if (closing) return;
    closing = true;
    await inputSubscription?.cancel();
    await server.close(force: true);
  }

  ProcessSignal.sigint.watch().listen((_) => unawaited(closeServer()));
  inputSubscription = stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    if (line.trim().toLowerCase() == 'q') {
      unawaited(closeServer());
    }
  });

  await for (final request in server) {
    unawaited(_serveRequest(request, webRoot, indexFile));
  }
}

Future<HttpServer> _bindAvailablePort() async {
  for (var port = 8123; port <= 8133; port++) {
    try {
      return await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    } on SocketException {
      // Try the next local port.
    }
  }
  throw const SocketException('No available demo port from 8123 to 8133.');
}

Future<void> _openBrowser(String url) async {
  if (Platform.isWindows) {
    await Process.run('cmd.exe', ['/c', 'start', '', url]);
  } else if (Platform.isMacOS) {
    await Process.run('open', [url]);
  } else {
    await Process.run('xdg-open', [url]);
  }
}

Future<void> _serveRequest(
  HttpRequest request,
  Directory webRoot,
  File indexFile,
) async {
  try {
    if (request.uri.pathSegments.any((segment) => segment == '..')) {
      request.response.statusCode = HttpStatus.forbidden;
      await request.response.close();
      return;
    }

    final relativePath = request.uri.pathSegments.isEmpty
        ? 'index.html'
        : request.uri.pathSegments.join(Platform.pathSeparator);
    var file = File(
      '${webRoot.path}${Platform.pathSeparator}$relativePath',
    );

    if (!file.existsSync()) {
      file = indexFile;
    }

    request.response.headers
      ..contentType = _contentType(file.path)
      ..set(HttpHeaders.cacheControlHeader, 'no-cache');
    await request.response.addStream(file.openRead());
  } catch (error) {
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..write('Web demo server error: $error');
  } finally {
    await request.response.close();
  }
}

ContentType _contentType(String path) {
  final extension = path.split('.').last.toLowerCase();
  return switch (extension) {
    'html' => ContentType.html,
    'js' || 'mjs' => ContentType('text', 'javascript', charset: 'utf-8'),
    'css' => ContentType('text', 'css', charset: 'utf-8'),
    'json' => ContentType.json,
    'wasm' => ContentType('application', 'wasm'),
    'png' => ContentType('image', 'png'),
    'jpg' || 'jpeg' => ContentType('image', 'jpeg'),
    'svg' => ContentType('image', 'svg+xml'),
    'ico' => ContentType('image', 'x-icon'),
    'ttf' => ContentType('font', 'ttf'),
    'otf' => ContentType('font', 'otf'),
    _ => ContentType.binary,
  };
}
