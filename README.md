# anti_shake_app
A companion app for a smart anti-tremor pen designed to assist people with Parkinson’s disease in writing more steadily and comfortably.

## Installed development environment

- Flutter 3.44.8 stable: `C:\dev\flutter`
- Dart 3.12.2
- Android Studio 2026.1.2: `C:\dev\android-studio`
- Android SDK 36: `C:\Android\Sdk`
- JDK 21, Build Tools 36.0.0, Platform Tools, NDK 28.2, and CMake 3.22.1

The user-level PATH and Android environment variables are configured. Terminals
opened before installation must be restarted before they can resolve `flutter`.

## Run and build

The workspace path contains non-ASCII and punctuation characters. Map it to a
short drive before running Flutter or Gradle:

```powershell
subst S: 'C:\XXXXX\XXXXXX'
Set-Location S:\anti_shake_app
flutter run
```

Quality checks and APK build:

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

The generated debug APK is at `build\app\outputs\flutter-apk\app-debug.apk`.

The app currently uses `MockPenRepository`, so it can demonstrate connection,
sensor charts, damping control, writing sessions, and reports without hardware.
The temporary protocol contract is in `docs/protocol_contract.md`.

## Computer demo

Double-click `run_web_demo.cmd` to launch the mock app in Chrome. The script
maps the project to temporary drive `P:` to avoid Flutter tooling issues with
the original Windows path.

Manual launch:

```powershell
subst S: 'C:\111111111111111111111111SHU\四个一——“防抖笔”'
Set-Location S:\anti_shake_app
& 'C:\dev\flutter\bin\flutter.bat' run -d chrome
```
