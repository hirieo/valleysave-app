import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameLaunchService {
  GameLaunchService._();
  static final instance = GameLaunchService._();

  static const _native = MethodChannel('valleysave/game');
  static const _prefKey = 'stardew_exe_path';

  static const _knownPathsWindows = [
    r'C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.exe',
    r'C:\Program Files\Steam\steamapps\common\Stardew Valley\Stardew Valley.exe',
    r'C:\XboxGames\Stardew Valley\Content\Stardew Valley.exe',
    r'C:\Program Files (x86)\GOG Galaxy\Games\Stardew Valley\Stardew Valley.exe',
  ];

  static List<String> _knownPathsLinux(String home) => [
    '$home/.steam/steam/steamapps/common/Stardew Valley/StardewValley',
    '$home/.local/share/Steam/steamapps/common/Stardew Valley/StardewValley',
    '$home/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Stardew Valley/StardewValley',
    // Steam vía snap: corre confinado con su propio $HOME (~/snap/steam/common).
    '$home/snap/steam/common/.local/share/Steam/steamapps/common/Stardew Valley/StardewValley',
  ];

  // macOS: Steam instala el juego como carpeta "Stardew Valley" SIN
  // extensión .app — dentro, "StardewValley" (sin espacio) es solo un
  // script que relanza "Stardew Valley" (con espacio), el binario nativo
  // real. Apuntar directo a este último evita la indirección del script.
  static List<String> _knownPathsMacOS(String home) => [
    '$home/Library/Application Support/Steam/steamapps/common/Stardew Valley/Contents/MacOS/Stardew Valley',
    '/Applications/Stardew Valley.app/Contents/MacOS/Stardew Valley',
  ];

  bool _androidInstalled = false;
  String? _desktopExePath;

  bool get canLaunch =>
      Platform.isAndroid ? _androidInstalled : _desktopExePath != null;

  String? get resolvedExePath => _desktopExePath;

  Future<void> init() async {
    if (Platform.isAndroid) {
      try {
        _androidInstalled = (await _native.invokeMethod<bool>('isInstalled')) ?? false;
      } catch (_) {
        _androidInstalled = false;
      }
      return;
    }
    if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null && await File(saved).exists()) {
      _desktopExePath = saved;
      return;
    }
    final candidates = Platform.isWindows
        ? _knownPathsWindows
        : Platform.isMacOS
        ? _knownPathsMacOS(Platform.environment['HOME'] ?? '')
        : _knownPathsLinux(Platform.environment['HOME'] ?? '');
    for (final path in candidates) {
      if (await File(path).exists()) {
        _desktopExePath = path;
        return;
      }
    }
    _desktopExePath = null;
  }

  Future<void> launch() async {
    if (Platform.isAndroid) {
      final ok = (await _native.invokeMethod<bool>('launch')) ?? false;
      if (!ok) throw StateError('No se pudo lanzar Stardew Valley');
      return;
    }
    final path = _desktopExePath;
    if (path == null) throw StateError('No exe path configured');
    await Process.start(path, [], mode: ProcessStartMode.detached);
  }

  Future<String?> pickExePathWindows() async {
    if (!Platform.isWindows) return null;
    final result = await Process.run('powershell', [
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      r'''
Add-Type -AssemblyName System.Windows.Forms
$d = New-Object System.Windows.Forms.OpenFileDialog
$d.Title = "Stardew Valley"
$d.Filter = "Stardew Valley|Stardew Valley.exe|Executables|*.exe"
$d.InitialDirectory = "C:\Program Files (x86)\Steam\steamapps\common"
if ($d.ShowDialog() -eq "OK") { Write-Output $d.FileName }
''',
    ]);
    final path = result.stdout.toString().trim();
    return path.isEmpty ? null : path;
  }

  Future<String?> pickExePathLinux() async {
    if (!Platform.isLinux) return null;
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Stardew Valley',
    );
    if (result == null || result.files.isEmpty) return null;
    return result.files.single.path;
  }

  Future<String?> pickExePathMacOS() async {
    if (!Platform.isMacOS) return null;
    final home = Platform.environment['HOME'] ?? '';
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Stardew Valley',
      initialDirectory:
          '$home/Library/Application Support/Steam/steamapps/common/Stardew Valley/Contents/MacOS',
    );
    if (result == null || result.files.isEmpty) return null;
    return result.files.single.path;
  }

  Future<void> setCustomExePath(String path) async {
    _desktopExePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, path);
  }

  Future<void> clearCustomExePath() async {
    _desktopExePath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }
}
