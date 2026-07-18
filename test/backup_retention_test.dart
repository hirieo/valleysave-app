import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/models/backup_entry.dart';
import 'package:valleysave/core/services/backup_service.dart';

import 'fixtures/zip_fixtures.dart';

void main() {
  late Directory tempDir;
  final service = BackupService();

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vs_retention_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<Directory> makeBackupsDir() async {
    final dir = Directory('${tempDir.path}${Platform.pathSeparator}Backups');
    await dir.create(recursive: true);
    return dir;
  }

  /// Escribe un archivo de respaldo directamente con el nombre exacto que
  /// produciría `createBackup` — evita depender de reloj real para construir
  /// varios timestamps distintos y controlables.
  Future<void> writeBackupFile(
    Directory backupsDir,
    String folderName,
    DateTime timestamp, {
    required bool auto,
  }) async {
    String p(int n) => n.toString().padLeft(2, '0');
    final ts =
        '${timestamp.year}${p(timestamp.month)}${p(timestamp.day)}-'
        '${p(timestamp.hour)}${p(timestamp.minute)}${p(timestamp.second)}';
    final tag = auto ? 'autobackup' : 'backup';
    final file = File(
      '${backupsDir.path}${Platform.pathSeparator}${folderName}_${tag}_$ts.zip',
    );
    final zipFile = await ZipFixtures.writeZip(
      ZipFixtures.validArchive(folderName: folderName),
      tempDir,
      '${folderName}_$tag$ts.zip',
    );
    await zipFile.copy(file.path);
  }

  group('parseo de nombres (T021, T024)', () {
    test('listLocalBackups reconoce _backup_, _pre-swap_ y _autobackup_', () async {
      final backupsDir = await makeBackupsDir();
      final now = DateTime(2026, 7, 1, 10);
      await writeBackupFile(backupsDir, 'Granja', now, auto: false);
      await File(
        '${backupsDir.path}${Platform.pathSeparator}Granja_pre-swap_20260701-090000.zip',
      ).writeAsString('legacy pre-swap zip content');
      await writeBackupFile(
        backupsDir,
        'Granja',
        now.add(const Duration(minutes: 5)),
        auto: true,
      );

      final all = await service.listLocalBackups(backupsDir.path);

      expect(all, hasLength(3));
      expect(
        all.where((e) => e.origin == BackupOrigin.manual),
        hasLength(2),
        reason: '_backup_ y _pre-swap_ son ambos origen manual',
      );
      expect(
        all.where((e) => e.origin == BackupOrigin.auto),
        hasLength(1),
      );
    });
  });

  group('enforceAutoRetention (FR-005)', () {
    test('conserva solo los 5 auto-backups más recientes, manuales intactos', () async {
      final backupsDir = await makeBackupsDir();
      final base = DateTime(2026, 7, 1, 10);

      // 7 auto-backups (más de kMaxAutoBackups=5) y 3 manuales.
      for (var i = 0; i < 7; i++) {
        await writeBackupFile(
          backupsDir,
          'Granja',
          base.add(Duration(minutes: i)),
          auto: true,
        );
      }
      for (var i = 0; i < 3; i++) {
        await writeBackupFile(
          backupsDir,
          'Granja',
          base.add(Duration(hours: 1, minutes: i)),
          auto: false,
        );
      }

      await service.enforceAutoRetention(backupsDir.path, 'Granja');

      final remaining = await service.listLocalBackups(backupsDir.path);
      final remainingAutos = remaining.where(
        (e) => e.origin == BackupOrigin.auto,
      );
      final remainingManual = remaining.where(
        (e) => e.origin == BackupOrigin.manual,
      );

      expect(
        remainingAutos,
        hasLength(kMaxAutoBackups),
        reason: 'solo se conservan los 5 auto-backups más recientes',
      );
      expect(
        remainingManual,
        hasLength(3),
        reason: 'los manuales nunca se tocan, aunque haya muchos',
      );
      // Los que sobreviven son los 5 MÁS RECIENTES (i=2..6), no los primeros.
      final survivingMinutes =
          remainingAutos.map((e) => e.timestamp.minute).toSet();
      expect(survivingMinutes, {2, 3, 4, 5, 6});
    });

    test('con 5 o menos auto-backups no borra nada', () async {
      final backupsDir = await makeBackupsDir();
      final base = DateTime(2026, 7, 1, 10);
      for (var i = 0; i < 3; i++) {
        await writeBackupFile(
          backupsDir,
          'Granja',
          base.add(Duration(minutes: i)),
          auto: true,
        );
      }

      await service.enforceAutoRetention(backupsDir.path, 'Granja');

      final remaining = await service.listLocalBackups(backupsDir.path);
      expect(remaining, hasLength(3));
    });
  });

  group('restoreBackup delega en el flujo transaccional (T022, T023)', () {
    test(
      'restaurar sobre un save existente genera un auto-backup nuevo y aplica retención',
      () async {
        final savesDir = Directory(
          '${tempDir.path}${Platform.pathSeparator}Saves',
        );
        await savesDir.create(recursive: true);
        final backupsDir = await makeBackupsDir();
        const folderName = ZipFixtures.validFolderName;

        // El save "existente" tiene que parecer un save real: el respaldo
        // automático que dispara `SaveReplaceService` antes de sustituirlo
        // se VERIFICA (contenido parseable), no solo se crea a ciegas.
        final existing = Directory(
          '${savesDir.path}${Platform.pathSeparator}$folderName',
        );
        await existing.create(recursive: true);
        for (final f in ZipFixtures.validArchive().files) {
          final relative = f.name.substring(folderName.length + 1);
          await File(
            '${existing.path}${Platform.pathSeparator}$relative',
          ).writeAsBytes(f.content);
        }

        // Ya hay 5 auto-backups previos de este mismo save — la retención
        // debe entrar en juego cuando se cree el sexto.
        final base = DateTime(2026, 7, 1, 10);
        for (var i = 0; i < kMaxAutoBackups; i++) {
          await writeBackupFile(
            backupsDir,
            folderName,
            base.add(Duration(minutes: i)),
            auto: true,
          );
        }

        final zipFile = await ZipFixtures.writeZip(
          ZipFixtures.validArchive(),
          tempDir,
          'restore_source.zip',
        );
        final entry = BackupEntry(
          fileName: 'restore_source.zip',
          folderName: folderName,
          timestamp: DateTime.now(),
          localPath: zipFile.path,
          sizeBytes: await zipFile.length(),
        );

        final result = await service.restoreBackup(
          entry,
          savesDir: savesDir.path,
          backupsDir: backupsDir.path,
        );

        expect(result.ok, isTrue);

        final afterRestore = await service.listLocalBackups(
          backupsDir.path,
          folderName: folderName,
        );
        final autosAfter = afterRestore.where(
          (e) => e.origin == BackupOrigin.auto,
        );
        expect(
          autosAfter,
          hasLength(kMaxAutoBackups),
          reason:
              'SaveReplaceService creó un auto-backup del save previo a '
              'restaurar Y aplicó la retención — nunca más de '
              'kMaxAutoBackups',
        );
      },
    );

    test(
      'restaurar sobre un destino que NO existe no crea respaldo (nada que respaldar)',
      () async {
        final savesDir = Directory(
          '${tempDir.path}${Platform.pathSeparator}Saves',
        );
        await savesDir.create(recursive: true);
        final backupsDir = await makeBackupsDir();
        const folderName = ZipFixtures.validFolderName;

        final zipFile = await ZipFixtures.writeZip(
          ZipFixtures.validArchive(),
          tempDir,
          'restore_source.zip',
        );
        final entry = BackupEntry(
          fileName: 'restore_source.zip',
          folderName: folderName,
          timestamp: DateTime.now(),
          localPath: zipFile.path,
          sizeBytes: await zipFile.length(),
        );

        final result = await service.restoreBackup(
          entry,
          savesDir: savesDir.path,
          backupsDir: backupsDir.path,
        );

        expect(result.ok, isTrue);
        final afterRestore = await service.listLocalBackups(backupsDir.path);
        expect(afterRestore, isEmpty);
      },
    );
  });
}
