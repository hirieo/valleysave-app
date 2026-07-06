import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameLaunchService {
  GameLaunchService._();
  static final instance = GameLaunchService._();

  static const _native = MethodChannel('valleysave/game');
  static const _prefKey = 'stardew_exe_path';

  static const _knownPaths = [
    r'C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.exe',
    r'C:\Program Files\Steam\steamapps\common\Stardew Valley\Stardew Valley.exe',
    r'C:\XboxGames\Stardew Valley\Content\Stardew Valley.exe',
    r'C:\Program Files (x86)\GOG Galaxy\Games\Stardew Valley\Stardew Valley.exe',
  ];

  bool _androidInstalled = false;
  String? _windowsExePath;

  bool get canLaunch =>
      Platform.isAndroid ? _androidInstalled : _windowsExePath != null;

  String? get resolvedExePath => _windowsExePath;

  Future<void> init() async {
    if (Platform.isAndroid) {
      try {
        _androidInstalled = (await _native.invokeMethod<bool>('isInstalled')) ?? false;
      } catch (_) {
        _androidInstalled = false;
      }
    } else if (Platform.isWindows) {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved != null && await File(saved).exists()) {
        _windowsExePath = saved;
        return;
      }
      for (final path in _knownPaths) {
        if (await File(path).exists()) {
          _windowsExePath = path;
          return;
        }
      }
      _windowsExePath = null;
    }
  }

  Future<void> launch() async {
    if (Platform.isAndroid) {
      final ok = (await _native.invokeMethod<bool>('launch')) ?? false;
      if (!ok) throw StateError('No se pudo lanzar Stardew Valley');
    } else if (Platform.isWindows) {
      final path = _windowsExePath;
      if (path == null) throw StateError('No exe path configured');
      await Process.start(path, [], mode: ProcessStartMode.detached);
    }
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

  Future<void> setCustomExePath(String path) async {
    _windowsExePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, path);
  }

  Future<void> clearCustomExePath() async {
    _windowsExePath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }
}
