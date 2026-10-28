import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Spec 012: los textos de «Backups claros» existen en los 14 idiomas y
/// llevan los mismos marcadores ({year}, {count}…) que la plantilla.
const _keys = [
  'backupsGameSummary',
  'backupsSectionManual',
  'backupsSectionAuto',
  'backupsSectionPreRestore',
  'backupsSectionLast',
  'backupsInUseShort',
  'backupsInUseTag',
  'backupsRuleManual',
  'backupsRuleKeep',
  'backupsKeep',
  'backupsKeepOk',
  'backupsKeepRemoteErr',
  'backupsKeepErr',
  'backupsExpandAll',
  'backupsCollapseAll',
  'backupsRestoreNoSafetyTitle',
  'backupsRestoreNoSafetyBody',
  'backupsRestoreNoSafetyConfirm',
];

Set<String> _placeholders(String text) => {
  for (final m in RegExp(r'\{(\w+)\}').allMatches(text)) m.group(1)!,
};

void main() {
  final files = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_[\w]+\.arb$').hasMatch(f.path))
      .toList();
  final template =
      jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;

  test('hay 14 archivos .arb', () {
    expect(files, hasLength(14));
  });

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    test('$name tiene todas las claves de backups claros', () {
      final arb =
          jsonDecode(file.readAsStringSync(encoding: utf8))
              as Map<String, dynamic>;
      for (final key in _keys) {
        expect(arb[key], isA<String>(), reason: '$name no tiene $key');
        expect(
          (arb[key] as String).trim(),
          isNotEmpty,
          reason: '$name: $key vacío',
        );
        expect(
          _placeholders(arb[key] as String),
          _placeholders(template[key] as String),
          reason: '$name: marcadores distintos en $key',
        );
      }
    });
  }
}
