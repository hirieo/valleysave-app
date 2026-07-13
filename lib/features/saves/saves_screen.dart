import 'dart:async';
import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:android_intent_plus/android_intent.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/app_localizations.dart';
import '../../core/models/backup_entry.dart';
import '../../core/models/player_stats.dart';
import '../../core/models/save_entry.dart';
import '../../core/models/save_file.dart';
import '../../core/models/season_state.dart';
import '../../core/models/shared_save_entry.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/drive_service.dart';
import '../../core/services/game_launch_service.dart';
import '../../core/services/host_swap_service.dart';
import '../../core/services/save_service.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/shizuku_service.dart';
import '../../core/services/transfer_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/utils/app_page_route.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../help/how_it_works_screen.dart';
import '../settings/settings_screen.dart';
import 'save_card.dart';
import 'widgets/latest_badge.dart';
import 'widgets/shared_folder_picker_screen.dart';
import 'widgets/saves_top_bar.dart';
import 'widgets/seasonal_loader.dart';
import 'widgets/shared_save_card.dart';
import 'widgets/stagger_item.dart';

/// Vía de acceso a los saves locales en Android.
/// `chooser` = aún sin elegir · `shizuku` = ADB (Shizuku) · `root` = su directo.
enum AndroidMode { chooser, shizuku, root }

/// Decisión del usuario en el diálogo de quitar la partida ORIGINAL tras el swap.
/// Spec 007: qué hacer con el zip de respaldo pre-swap (el usuario decide
/// SIEMPRE de forma explícita — nunca hay comportamiento implícito).
enum _SwapBackupChoice { upload, keepLocal, deleteNow }

/// Borrado unificado (feedback 2026-07-12): un solo punto de entrada para
/// borrar un save, sea cual sea la cara desde la que se abra.
enum _DeleteChoice { localOnly, driveOnly, both }

class SavesScreen extends StatefulWidget {
  const SavesScreen({super.key, this.drive});

  final DriveService? drive;

  @override
  State<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends State<SavesScreen> with WidgetsBindingObserver {
  List<SaveEntry> _entries = [];
  int _staggerVersion = 0;
  bool _loading = true;
  bool _refreshing = false;
  bool _gameCanLaunch = false;
  final _busy = <String>{}; // folderName en curso (subiendo/descargando)

  // ── US5 — Compartidas conmigo (independiente de _entries/_loading) ──
  List<SharedSaveEntry> _sharedEntries = [];
  bool _sharedLoading = true;

  // ── spec 007 — respaldos pre-swap: conteo LOCAL por folderName, para el
  // badge del botón "Backups" en la hoja de detalle (rápido, sin red).
  Map<String, int> _backupCounts = {};

  // ── Modo de acceso en Android ──
  static const _modePrefKey = 'android_access_mode';
  AndroidMode? _mode; // null = aún leyendo la preferencia
  // Estado de Shizuku (solo submodo shizuku). null = comprobando.
  bool? _shizukuRunning;
  bool _shizukuGranted = false;

  bool get _shizukuReady => _shizukuRunning == true && _shizukuGranted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !Platform.isAndroid) return;
    // Submodo Shizuku: el usuario pudo activarlo fuera de la app.
    if (_mode == AndroidMode.shizuku && !_shizukuReady) {
      _checkShizuku();
    }
  }

  Future<void> _init() async {
    await GameLaunchService.instance.init();
    if (mounted) setState(() => _gameCanLaunch = GameLaunchService.instance.canLaunch);

    if (!Platform.isAndroid) {
      await _load();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_modePrefKey);

    // Primera vez sin pref → chooser. El usuario elige Root/Shizuku/Manual.
    // Evita un popup de Magisk inesperado antes de que el usuario haya elegido nada.
    if (saved == null) {
      if (!mounted) return;
      setState(() { _mode = AndroidMode.chooser; _loading = false; });
      return;
    }

    // Root: confiar en el pref guardado, ir directo a cargar.
    // pullSavesAsRoot() es la ÚNICA llamada a su — Magisk la aprueba silenciosamente
    // si el grant es permanente. Si root fue revocado, la lista sale vacía y el
    // usuario puede cambiar modo desde Ajustes.
    if (saved == 'root') {
      if (!mounted) return;
      setState(() => _mode = AndroidMode.root);
      await _load();
      return;
    }

    final mode = switch (saved) {
      'shizuku' => AndroidMode.shizuku,
      _         => AndroidMode.shizuku,
    };
    if (!mounted) return;
    setState(() => _mode = mode);
    await _enterMode(mode);
  }

  Future<void> _chooseMode(AndroidMode mode) async {
    if (mode == AndroidMode.root) {
      final hasRoot = await ShizukuService.instance.checkRoot();
      if (!mounted) return;
      if (!hasRoot) {
        _snack(AppLocalizations.of(context)!.snackRootDenied);
        return;
      }
      // Guardar root en prefs igual que los demás modos.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_modePrefKey, 'root');
      if (!mounted) return;
      setState(() => _mode = AndroidMode.root);
      await _enterMode(AndroidMode.root);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modePrefKey, mode.name);
    if (!mounted) return;
    setState(() => _mode = mode);
    await _enterMode(mode);
  }

  /// Arranca la vía elegida (común a _init y _chooseMode).
  Future<void> _enterMode(AndroidMode mode) async {
    switch (mode) {
      case AndroidMode.shizuku:
        await _checkShizuku();
      case AndroidMode.chooser:
        if (mounted) setState(() => _loading = false);
      case AndroidMode.root:
        await _load();
    }
  }

  /// Vuelve al selector de vía (botón "cambiar método").
  Future<void> _resetMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_modePrefKey);
    if (!mounted) return;
    setState(() {
      _mode = AndroidMode.chooser;
      _shizukuRunning = null;
      _shizukuGranted = false;
      _loading = false;
    });
  }

  Future<void> _checkShizuku() async {
    final running = await ShizukuService.instance.isRunning();
    final granted = running ? await ShizukuService.instance.hasPermission() : false;
    if (!mounted) return;
    setState(() {
      _shizukuRunning = running;
      _shizukuGranted = granted;
      if (!(running && granted)) _loading = false;
    });
    if (running && granted) await _load(silent: _entries.isNotEmpty);
  }

  Future<void> _requestShizukuPermission() async {
    final granted = await ShizukuService.instance.requestPermission();
    if (!mounted) return;
    setState(() => _shizukuGranted = granted);
    if (granted) await _load();
  }

  Future<void> _openShizukuPlayStore() async {
    final uri = Uri.parse(
        'https://play.google.com/store/apps/details?id=moe.shizuku.privileged.api');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openShizukuGithub() async {
    await launchUrl(
      Uri.parse('https://github.com/RikkaApps/Shizuku/releases/latest'),
      mode: LaunchMode.externalApplication,
    );
  }

  /// Abre Opciones de desarrollador resaltando "Depuración inalámbrica".
  Future<void> _openWirelessDebug() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await ShizukuService.instance.openWirelessDebug();
    if (!ok) _snack(l10n.snackWirelessDebugHint);
  }

  /// Abre la app Shizuku directamente (sin diálogo de selección).
  Future<void> _openShizukuApp() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await ShizukuService.instance.openShizukuApp();
    if (!ok) _snack(l10n.snackOpenShizukuApp);
  }

  /// Abre la info de la app Shizuku para que el usuario ponga energía → No restringido.
  Future<void> _openShizukuAppInfo() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      const intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:moe.shizuku.privileged.api',
      );
      await intent.launch();
    } catch (_) {
      _snack(l10n.snackShizukuBattery);
    }
  }

  Future<List<SaveFile>> _scanLocal() async {
    if (!Platform.isAndroid) return SaveService().scan();
    switch (_mode) {
      case AndroidMode.root:
        final bridge = await ShizukuService.instance.pullSavesAsRoot();
        if (bridge == null) return [];
        return SaveService().scanDir(bridge);
      case AndroidMode.shizuku:
        if (!_shizukuReady) return [];
        final bridge = await ShizukuService.instance.pullSaves();
        if (bridge == null) return [];
        return SaveService().scanDir(bridge);
      default:
        return [];
    }
  }

  Future<void> _refresh() async {
    if (_refreshing || _loading) return;
    setState(() => _refreshing = true);
    await _load(silent: true);
    if (mounted) setState(() => _refreshing = false);
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);

    final local = await _scanLocal();
    var drive = <DriveSaveSummary>[];
    if (widget.drive != null) {
      try {
        drive = await widget.drive!.listSaveSummaries();
      } catch (e, st) {
        debugPrint('DRIVE_ERROR: $e\n$st');
        if (!mounted) return;
        final isAuthError = e.toString().contains('invalid_grant') ||
            e.toString().contains('access credentials');
        if (isAuthError) {
          await AuthService.instance.signOut();
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            _snack(l10n.snackSessionExpired);
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) _snack(AppLocalizations.of(context)!.snackDriveError(e.toString()));
        }
      }
    }

    final localByName = {for (final s in local) s.folderName: s};
    final driveByName = {for (final d in drive) d.folderName: d};
    final names = {...localByName.keys, ...driveByName.keys};

    final entries = <SaveEntry>[];
    for (final name in names) {
      final d = driveByName[name];
      entries.add(SaveEntry(
        local: localByName[name],
        drive: d?.save,
        driveFolderId: d?.folderId,
      ));
    }
    entries.sort(
        (a, b) => b.primary.lastModified.compareTo(a.primary.lastModified));

    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
        _staggerVersion++;
      });
      SeasonController.instance.setFromSaves(entries);
    }

    unawaited(_loadSharedSaves(local));
    unawaited(_loadBackupCounts());
  }

  /// spec 007 — conteo LOCAL de backups por save, para el badge del botón
  /// "Backups". Barato (un solo scan de directorio), sin red.
  Future<void> _loadBackupCounts() async {
    try {
      final backupsDir = await _backupsDirPath();
      final all = await BackupService().listLocalBackups(backupsDir);
      final counts = <String, int>{};
      for (final b in all) {
        counts[b.folderName] = (counts[b.folderName] ?? 0) + 1;
      }
      if (mounted) setState(() => _backupCounts = counts);
    } catch (_) {
      // best-effort — el badge simplemente no aparece si esto falla
    }
  }

  /// US5 — refresca "Compartidas conmigo" contra Drive en cada carga
  /// (rol/estado nunca se confían al registro local, ver G3/G4). [local]
  /// son los saves YA escaneados por [_load], para no repetir el scan.
  Future<void> _loadSharedSaves(List<SaveFile> local) async {
    if (widget.drive == null) {
      if (mounted) setState(() => _sharedLoading = false);
      return;
    }
    try {
      final shared = await widget.drive!.listSharedSaves();
      final localByName = {for (final s in local) s.folderName: s};
      // `_entries` ya está actualizado en este punto (lo fija `_load` con
      // setState de forma síncrona antes del `unawaited` que llega aquí) —
      // reutilizamos su emparejamiento local↔Drive PROPIO sin llamada extra
      // a la API (modelo de 3 sitios, ver `SharedSaveEntry.ownDriveStats`).
      final ownByName = {for (final e in _entries) e.folderName: e};
      final merged = [
        for (final s in shared)
          s.copyWith(
            localMatch: localByName[s.folderName],
            ownDriveStats: ownByName[s.folderName]?.drive,
            ownDriveFolderId: ownByName[s.folderName]?.driveFolderId,
          ),
      ];
      if (mounted) {
        setState(() {
          _sharedEntries = merged;
          _sharedLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _sharedLoading = false);
    }
  }

  /// US5 — botón "Añadir" de la sección: abre el selector de carpetas
  /// compartidas conmigo en Drive y, si se elige una, la valida y persiste.
  Future<void> _handleAddShared() async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null) return;
    final folderId = await showPickerScreen(
      context,
      drive: widget.drive!,
    );
    if (folderId == null || folderId.isEmpty) return;

    try {
      await widget.drive!.addSharedSave(folderId);
      await _load(silent: true);
    } catch (e) {
      if (mounted) _snack(l10n.importErrNotASave);
    }
  }

  Future<void> _handleDownloadShared(SharedSaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null) return;
    if (_busy.contains(entry.folderName)) return;

    setState(() => _busy.add(entry.folderName));
    try {
      final savesDir = SaveService.savesDirectory;
      if (savesDir == null) {
        if (mounted) _snack(l10n.snackPlatformNotSupported);
        return;
      }
      await Directory(savesDir).create(recursive: true);
      final target = '$savesDir${Platform.pathSeparator}${entry.folderName}';
      await widget.drive!.downloadSharedSave(entry.folderId, target);
      await _load(silent: true);
      if (mounted) _snack(l10n.snackDownloaded);
    } catch (e) {
      if (mounted) _snack(l10n.snackDownloadError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(entry.folderName));
    }
  }

  Future<void> _handleSyncShared(SharedSaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null || entry.localMatch == null) return;
    if (_busy.contains(entry.folderName)) return;

    final confirmed = await _confirmSyncShared(entry.ownerEmail);
    if (confirmed != true) return;

    setState(() => _busy.add(entry.folderName));
    try {
      await widget.drive!
          .uploadToSharedSave(entry.folderId, entry.localMatch!.folderPath);
      await _load(silent: true);
      if (mounted) _snack(l10n.exportSuccess);
    } catch (e) {
      if (mounted) _snack(l10n.exportError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(entry.folderName));
    }
  }

  Future<void> _handleRemoveShared(SharedSaveEntry entry) async {
    if (widget.drive == null) return;
    final confirmed = await _confirmRemoveShared(entry.ownerEmail);
    if (confirmed != true) return;
    await widget.drive!.removeSharedSave(entry.folderId);
    await _load(silent: true);
  }

  Future<bool?> _confirmSyncShared(String ownerEmail) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE0B850),
          child: _dialogBody(
            title: Text(l10n.sharedWithMeSync,
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: Text(
              l10n.sharedWithMeSyncConfirm(ownerEmail),
              style: GoogleFonts.firaCode(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.80)),
            ),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              ActionBtn(
                label: l10n.sharedWithMeSync,
                color: const Color(0xFFE0B850),
                icon: Icons.sync_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmRemoveShared(String ownerEmail) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: Colors.white.withValues(alpha: 0.3),
          child: _dialogBody(
            title: Text(l10n.sharedWithMeRemove,
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: Text(
              l10n.sharedWithMeRemoveConfirm(ownerEmail),
              style: GoogleFonts.firaCode(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.80)),
            ),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              ActionBtn(
                label: l10n.sharedWithMeRemove,
                color: Colors.white.withValues(alpha: 0.75),
                icon: Icons.close_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<String?>(
      context,
      AppPageRoute(builder: (_) => const SettingsScreen(showDisconnect: true)),
    );
    if (!mounted) return;
    if (result == 'disconnect') {
      _disconnectDrive();
    } else if (result == 'change_mode') {
      _showChangeModeDialog();
    } else {
      await GameLaunchService.instance.init();
      if (mounted) setState(() => _gameCanLaunch = GameLaunchService.instance.canLaunch);
    }
  }

  Future<void> _handleLaunchGame() async {
    try {
      await GameLaunchService.instance.launch();
    } catch (_) {
      if (mounted) _snack(AppLocalizations.of(context)!.snackLaunchError);
    }
  }

  void _showChangeModeDialog() {
    final l10n = AppLocalizations.of(context)!;
    final accent = _seasonAccent;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color.alphaBlend(
            accent.withValues(alpha: 0.06), const Color(0xFF0A0A0B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: accent.withValues(alpha: 0.22)),
        ),
        title: Text(l10n.bridgeChangeMode,
            style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _changeModeOption(ctx, l10n.chooserRootBadge, l10n.chooserRootTitle,
                AndroidMode.root, accent),
            const SizedBox(height: 8),
            _changeModeOption(ctx, l10n.hiwShizukuBadge, l10n.hiwShizukuTitle,
                AndroidMode.shizuku, accent),
          ],
        ),
        actions: [
          ActionBtn(
            label: l10n.cancel,
            color: Colors.white.withValues(alpha: 0.55),
            filled: false,
            onTap: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Widget _changeModeOption(
      BuildContext ctx, String badge, String title, AndroidMode mode, Color accent) {
    final isActive = _mode == mode;
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        if (!isActive) _chooseMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? accent.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? accent.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.10),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(badge,
                      style: GoogleFonts.firaCode(
                          fontSize: 8.5,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w700,
                          color: isActive ? accent : AppColors.textFaint)),
                  const SizedBox(height: 2),
                  Text(title,
                      style: GoogleFonts.firaCode(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isActive ? accent : AppColors.text)),
                ],
              ),
            ),
            if (isActive)
              Icon(Icons.check_circle_rounded, size: 18, color: accent),
          ],
        ),
      ),
    );
  }

  Future<void> _disconnectDrive() async {
    await AuthService.instance.signOut();
    if (mounted) Navigator.pop(context, true); // true = se desconectó
  }

  // ── Acciones ────────────────────────────────────────────────────────────

  Future<void> _handleUpload(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final local = entry.local;
    if (local == null || widget.drive == null) return;
    final name = local.folderName;
    if (_busy.contains(name)) return;

    // Sobrescribe una versión ya existente en Drive → preview + confirmar.
    if (entry.drive != null) {
      final confirmed = await _confirmUpload(entry);
      if (confirmed != true) return;
    }

    setState(() => _busy.add(name));
    try {
      await widget.drive!.uploadSave(local.folderPath, name, players: local.players);
      await _load(silent: true);
    } catch (e) {
      if (mounted) _snack(l10n.snackUploadError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  Future<void> _handleDownload(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final drive = entry.drive;
    final folderId = entry.driveFolderId;
    if (drive == null || folderId == null || widget.drive == null) return;

    final name = drive.folderName;
    final confirmed = await _confirmDownload(entry);
    if (confirmed != true) return;

    setState(() => _busy.add(name));
    try {
      if (Platform.isAndroid && _mode == AndroidMode.root) {
        final out = await ShizukuService.instance.prepareOut(name);
        await widget.drive!.downloadSave(folderId, out);
        final ok = await ShizukuService.instance.pushSaveAsRoot(out, name);
        if (!ok) {
          if (mounted) _snack(l10n.snackWriteError);
          return;
        }
        await _load(silent: true);
        if (mounted) _snack(l10n.snackDownloaded);
      } else if (Platform.isAndroid && _mode == AndroidMode.shizuku) {
        // Shizuku: descargar a carpeta propia → empujar al juego vía cp.
        if (!_shizukuReady) {
          if (mounted) _snack(l10n.activateShizuku);
          return;
        }
        final out = await ShizukuService.instance.prepareOut(name);
        await widget.drive!.downloadSave(folderId, out);
        final ok = await ShizukuService.instance.pushSave(name);
        if (!ok) {
          if (mounted) _snack(l10n.snackWriteError);
          return;
        }
        await _load(silent: true);
        if (mounted) _snack(l10n.snackDownloaded);
      } else {
        final savesDir = SaveService.savesDirectory;
        if (savesDir == null) {
          if (mounted) _snack(l10n.snackPlatformNotSupported);
          return;
        }
        await Directory(savesDir).create(recursive: true);
        final target = '$savesDir${Platform.pathSeparator}$name';
        await widget.drive!.downloadSave(folderId, target);
        await _load(silent: true);
        if (mounted) _snack(l10n.snackDownloaded);
      }
    } catch (e) {
      if (mounted) _snack(l10n.snackDownloadError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  /// Borrado unificado (feedback 2026-07-12): UN solo punto de entrada,
  /// sea cual sea la cara desde la que se abra — el diálogo detecta qué
  /// ubicaciones existen de verdad y solo ofrece esas.
  Future<void> _handleDelete(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final hasLocal = entry.local != null;
    final hasDrive = entry.driveFolderId != null && widget.drive != null;
    if (!hasLocal && !hasDrive) return;

    final farmName = entry.primary.farmName;
    final name = entry.folderName;
    if (_busy.contains(name)) return;

    final choice = await _confirmUnifiedDelete(
      farmName,
      hasLocal: hasLocal,
      hasDrive: hasDrive,
    );
    if (choice == null) return;

    setState(() => _busy.add(name));
    try {
      if (choice == _DeleteChoice.localOnly || choice == _DeleteChoice.both) {
        if (Platform.isAndroid && _mode == AndroidMode.root) {
          final ok = await ShizukuService.instance.deleteLocalAsRoot(name);
          if (!ok && mounted) _snack(l10n.snackDeleteError('su rm failed'));
        } else {
          final localSave = entry.local;
          if (localSave != null) {
            final dir = Directory(localSave.folderPath);
            if (await dir.exists()) await dir.delete(recursive: true);
          }
        }
      }
      if (choice == _DeleteChoice.driveOnly || choice == _DeleteChoice.both) {
        final folderId = entry.driveFolderId;
        if (folderId != null && widget.drive != null) {
          await widget.drive!.trashSave(folderId);
        }
      }
      await _load(silent: true);
      if (mounted) {
        final msg = switch (choice) {
          _DeleteChoice.localOnly => l10n.snackDeletedLocal(farmName),
          _DeleteChoice.driveOnly => l10n.snackTrashed(farmName),
          _DeleteChoice.both => l10n.snackDeletedBoth(farmName),
        };
        _snack(msg);
      }
    } catch (e) {
      if (mounted) _snack(l10n.snackDeleteError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  /// F1 — exporta la cara LOCAL de [entry] a un archivo transportable.
  /// Windows: selector nativo "Guardar como" (`file_picker`). Android: hoja
  /// de compartir nativa del sistema (`share_plus`) — la app nunca impone
  /// ni asume un destino fijo (FR-002/FR-003).
  Future<void> _handleExport(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final local = entry.local;
    if (local == null) return;
    final name = local.folderName;
    if (_busy.contains(name)) return;

    setState(() => _busy.add(name));
    try {
      final zip = await TransferService().exportSave(local.folderPath, name);
      if (Platform.isAndroid || Platform.isIOS) {
        // La hoja de compartir sigue leyendo el archivo tras el `await`
        // (la app receptora lo procesa en segundo plano) — el temporal NO
        // se borra aquí, se deja al ciclo de vida normal del directorio
        // temporal del sistema.
        await SharePlus.instance.share(
          ShareParams(files: [XFile(zip.path)]),
        );
      } else {
        await FilePicker.saveFile(
          fileName: '$name.zip',
          type: FileType.custom,
          allowedExtensions: ['zip'],
          bytes: await zip.readAsBytes(),
        );
        await zip.parent.delete(recursive: true);
      }
      if (mounted) _snack(l10n.exportSuccess);
    } catch (e) {
      if (mounted) _snack(l10n.exportError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  /// F1 — punto de entrada de "Importar partida" (barra superior): abre el
  /// selector nativo filtrado a `.zip` y arranca el pipeline de import.
  Future<void> _handleImport() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    final path = picked?.files.single.path;
    if (path == null) return;
    await _importFromZip(path);
  }

  /// [overwrite] solo se pasa `true` tras confirmar [_confirmImportConflict].
  Future<void> _importFromZip(String zipPath, {bool overwrite = false}) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (Platform.isAndroid && _mode != AndroidMode.chooser) {
        await _importAndroid(zipPath, overwrite: overwrite);
        return;
      }
      final savesDir = SaveService.savesDirectory;
      if (savesDir == null) {
        if (mounted) _snack(l10n.snackPlatformNotSupported);
        return;
      }
      final result = await TransferService().importSave(
        zipPath,
        savesDir: savesDir,
        overwrite: overwrite,
      );
      await _handleImportResult(result, zipPath);
    } catch (e) {
      if (mounted) _snack(l10n.importErrWrite);
    }
  }

  /// Android: el `savesDir` real del juego está protegido — se importa a un
  /// directorio de la propia app (siempre libre, nunca hay conflicto ahí) y
  /// luego se empuja vía Shizuku/root, mismo patrón que `_handleDownload`
  /// (T013). El conflicto (FR-008) se comprueba contra `_entries`, que sí
  /// refleja lo que hay realmente en el juego.
  Future<void> _importAndroid(String zipPath, {required bool overwrite}) async {
    final l10n = AppLocalizations.of(context)!;
    final stagingDir = await Directory.systemTemp.createTemp('vs_import_stage_');
    try {
      final result = await TransferService().importSave(
        zipPath,
        savesDir: stagingDir.path,
      );
      if (!result.ok || result.importedFolderName == null) {
        await _handleImportResult(result, zipPath);
        return;
      }
      final folderName = result.importedFolderName!;

      if (!overwrite) {
        SaveEntry? existing;
        for (final e in _entries) {
          if (e.folderName == folderName && e.local != null) {
            existing = e;
            break;
          }
        }
        if (existing != null) {
          final confirmed = await _confirmImportConflict();
          if (confirmed != true) return;
        }
      }

      if (!_shizukuReady && _mode == AndroidMode.shizuku) {
        if (mounted) _snack(l10n.activateShizuku);
        return;
      }

      final out = await ShizukuService.instance.prepareOut(folderName);
      final outDir = Directory(out);
      if (await outDir.exists()) await outDir.delete(recursive: true);
      await Directory('${stagingDir.path}${Platform.pathSeparator}$folderName')
          .rename(out);

      final ok = _mode == AndroidMode.root
          ? await ShizukuService.instance.pushSaveAsRoot(out, folderName)
          : await ShizukuService.instance.pushSave(folderName);
      if (!ok) {
        if (mounted) _snack(l10n.snackWriteError);
        return;
      }
      await _load(silent: true);
      if (mounted) _snack(l10n.importSuccess(_playerNameFor(folderName)));
    } catch (_) {
      if (mounted) _snack(l10n.importErrWrite);
    } finally {
      if (await stagingDir.exists()) await stagingDir.delete(recursive: true);
    }
  }

  Future<void> _handleImportResult(ImportResult result, String zipPath) async {
    final l10n = AppLocalizations.of(context)!;
    if (result.ok) {
      await _load(silent: true);
      if (mounted) {
        _snack(l10n.importSuccess(_playerNameFor(result.importedFolderName)));
      }
      return;
    }
    if (result.conflict) {
      final confirmed = await _confirmImportConflict();
      if (confirmed == true) await _importFromZip(zipPath, overwrite: true);
      return;
    }
    final msg = switch (result.error!) {
      ImportError.invalidZip => l10n.importErrInvalidZip,
      ImportError.unsafePath => l10n.importErrUnsafePath,
      ImportError.tooLarge => l10n.importErrTooLarge,
      ImportError.notASave => l10n.importErrNotASave,
      ImportError.writeFailure => l10n.importErrWrite,
    };
    if (mounted) _snack(msg);
  }

  String _playerNameFor(String? folderName) {
    for (final e in _entries) {
      if (e.folderName == folderName) return e.primary.playerName;
    }
    return folderName ?? '';
  }

  /// F2 — compartir por email. Individual: siempre `role: reader`, sin
  /// selector. Coop: el dueño elige lectura o sincronizar (research.md D10).
  Future<void> _handleShare(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final folderId = entry.driveFolderId;
    if (widget.drive == null || folderId == null) return;
    final coop = entry.primary.isCoop;

    final picked = await _promptShareEmail(entry: entry, coop: coop);
    if (picked == null) return;
    final (email, role) = picked;
    if (email.isEmpty) return;

    try {
      final existing = await widget.drive!.listPermissions(folderId);
      dynamic current;
      for (final p in existing) {
        if (p.emailAddress?.toLowerCase() == email.toLowerCase()) {
          current = p;
          break;
        }
      }
      if (current == null) {
        await widget.drive!.shareSave(folderId, email, role: role);
      } else if (coop && current.role != role && current.id != null) {
        await widget.drive!.updatePermission(folderId, current.id as String, role);
      }
      if (mounted) _snack(l10n.shareSuccess(email));
    } catch (e) {
      if (mounted) _snack(l10n.exportError(e.toString()));
    }
  }

  /// Diálogo "Compartir": campo de email + (solo coop) selector de rol +
  /// nota informativa. Devuelve `(email, role)` o `null` si se cancela.
  /// Incluye un enlace discreto a la gestión de accesos (T018/T018b), para
  /// no necesitar un segundo punto de entrada en la tarjeta/hoja de detalle.
  Future<(String, String)?> _promptShareEmail({
    required SaveEntry entry,
    required bool coop,
  }) {
    final farmName = entry.primary.farmName;
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    var role = 'reader';
    return showDialog<(String, String)>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: StatefulBuilder(
          builder: (ctx, setState) => _glassDialogShell(
            accent: const Color(0xFFE0B850),
            child: _dialogBody(
              title: Text(l10n.shareDialogTitle,
                  style: GoogleFonts.bodoniModa(
                      color: AppColors.text,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(farmName,
                      style: GoogleFonts.firaCode(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.55))),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: GoogleFonts.firaCode(
                        fontSize: 13, color: Colors.white.withValues(alpha: 0.92)),
                    decoration: InputDecoration(
                      hintText: l10n.shareEmailPlaceholder,
                      hintStyle: GoogleFonts.firaCode(
                          fontSize: 13, color: Colors.white.withValues(alpha: 0.3)),
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: const Color(0xFFE0B850).withValues(alpha: 0.55)),
                      ),
                    ),
                  ),
                  if (coop) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _shareRoleOption(
                            label: l10n.shareRoleReader,
                            selected: role == 'reader',
                            onTap: () => setState(() => role = 'reader'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _shareRoleOption(
                            label: l10n.shareRoleWriter,
                            selected: role == 'writer',
                            onTap: () => setState(() => role = 'writer'),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  _infoBox(
                    color: const Color(0xFF5AA8E0),
                    icon: Icons.info_outline_rounded,
                    text: coop ? l10n.shareInfoNoteCoop : l10n.shareInfoNote,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showManageAccess(entry);
                    },
                    child: Text(
                      l10n.manageAccessTitle,
                      style: GoogleFonts.firaCode(
                        fontSize: 10.5,
                        color: Colors.white.withValues(alpha: 0.45),
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ActionBtn(
                  label: l10n.cancel,
                  color: Colors.white.withValues(alpha: 0.55),
                  filled: false,
                  onTap: () => Navigator.pop(ctx),
                ),
                ActionBtn(
                  label: l10n.shareConfirmButton,
                  color: const Color(0xFFE0B850),
                  icon: Icons.person_add_alt_1_rounded,
                  filled: true,
                  onTap: () =>
                      Navigator.pop(ctx, (controller.text.trim(), role)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shareRoleOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const accent = Color(0xFFE0B850);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: selected ? 0.16 : 0.0),
          border: Border.all(color: accent.withValues(alpha: selected ? 0.55 : 0.20)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.firaCode(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? accent : Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }

  /// Hoja de gestión de accesos (T018/T018b): individual sin control de rol,
  /// coop con rol editable in-line (`updatePermission`, sin revocar).
  Future<void> _showManageAccess(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final folderId = entry.driveFolderId;
    if (widget.drive == null || folderId == null) return;
    final coop = entry.primary.isCoop;

    List<dynamic> permissions;
    try {
      permissions = await widget.drive!.listPermissions(folderId);
    } catch (e) {
      if (mounted) _snack(l10n.exportError(e.toString()));
      return;
    }
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: StatefulBuilder(
          builder: (ctx, setState) => _glassDialogShell(
            maxWidth: 420,
            accent: const Color(0xFFE0B850),
            child: _dialogBody(
              title: Text(l10n.manageAccessTitle,
                  style: GoogleFonts.bodoniModa(
                      color: AppColors.text,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (permissions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(l10n.manageAccessEmpty,
                          style: GoogleFonts.firaCode(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5))),
                    )
                  else
                    for (final p in permissions)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE0B850).withValues(alpha: 0.16),
                              ),
                              child: Text(
                                (p.emailAddress as String? ?? '?')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: GoogleFonts.firaCode(
                                    fontSize: 11, color: const Color(0xFFE0B850)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.emailAddress as String? ?? '',
                                style: GoogleFonts.firaCode(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.85)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (coop) ...[
                              _manageAccessRoleChip(
                                label: l10n.shareRoleReader,
                                selected: p.role == 'reader',
                                onTap: () async {
                                  if (p.role == 'reader') return;
                                  try {
                                    await widget.drive!.updatePermission(
                                        folderId, p.id as String, 'reader');
                                    setState(() => p.role = 'reader');
                                  } catch (e) {
                                    if (mounted) _snack(l10n.exportError(e.toString()));
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              _manageAccessRoleChip(
                                label: l10n.shareRoleWriter,
                                selected: p.role == 'writer',
                                onTap: () async {
                                  if (p.role == 'writer') return;
                                  try {
                                    await widget.drive!.updatePermission(
                                        folderId, p.id as String, 'writer');
                                    setState(() => p.role = 'writer');
                                  } catch (e) {
                                    if (mounted) _snack(l10n.exportError(e.toString()));
                                  }
                                },
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  size: 16, color: Color(0xFFE05252)),
                              tooltip: l10n.manageAccessRevoke,
                              onPressed: () async {
                                try {
                                  await widget.drive!
                                      .unshareSave(folderId, p.id as String);
                                  setState(() => permissions.remove(p));
                                } catch (e) {
                                  if (mounted) _snack(l10n.exportError(e.toString()));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(height: 8),
                  _infoBox(
                    color: const Color(0xFF5AA8E0),
                    icon: Icons.info_outline_rounded,
                    text: coop
                        ? l10n.driveOnlyControlsYourCopyCoop
                        : l10n.driveOnlyControlsYourCopy,
                  ),
                ],
              ),
              actions: [
                ActionBtn(
                  label: l10n.cardCloseBarrier,
                  color: Colors.white.withValues(alpha: 0.55),
                  filled: false,
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _manageAccessRoleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const accent = Color(0xFFE0B850);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: selected ? 0.16 : 0.0),
          border: Border.all(color: accent.withValues(alpha: selected ? 0.5 : 0.18)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.firaCode(
            fontSize: 9.5,
            color: selected ? accent : Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  /// F3 — cambio de anfitrión local. `entry` es el save coop, `target` el
  /// farmhand elegido con el selector ‹ › de la hoja de detalle.
  /// Spec 007: el swap reemplaza el save EN SITIO (mismo folderName/
  /// uniqueIDForThisGame — el folderId de Drive nunca cambia, así los
  /// permisos de compartir y "Compartidas conmigo" sobreviven al swap). El
  /// original se preserva SIEMPRE como zip antes de tocar nada.
  Future<void> _handleMakeHost(SaveEntry entry, PlayerStats target) async {
    final l10n = AppLocalizations.of(context)!;
    final local = entry.local;
    if (local == null) return;
    final name = entry.folderName;
    if (_busy.contains(name)) return;

    final service = HostSwapService();
    final analysis = await service.analyze(
      saveFolderPath: local.folderPath,
      targetUniqueId: target.uniqueId,
    );
    if (!analysis.ok) {
      if (mounted) _snack(_hostSwapErrorMessage(analysis.error));
      return;
    }

    final confirmed = await _confirmMakeHost(
      targetName: analysis.targetName,
      farmName: local.farmName,
      itemsToRelocate: analysis.itemsToRelocate,
    );
    if (confirmed != true) return;

    setState(() => _busy.add(name));
    try {
      final backupsDir = await _backupsDirPath();
      final result = await service.execute(
        saveFolderPath: local.folderPath,
        targetUniqueId: target.uniqueId,
        backupsDir: backupsDir,
      );
      if (!result.ok) {
        if (mounted) _snack(_hostSwapErrorMessage(result.error));
        return;
      }
      await _load(silent: true);
      if (mounted) _snack(l10n.makeHostSuccess(target.name));
      if (mounted && result.backupZipPath != null) {
        await _handleSwapBackupChoice(result.backupZipPath!);
      }
    } catch (e) {
      if (mounted) _snack(l10n.snackDeleteError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  /// `<documents>/ValleySave/Backups/` — nunca dentro de la carpeta Saves
  /// del juego (spec 007).
  Future<String> _backupsDirPath() async {
    final docs = await getApplicationDocumentsDirectory();
    return '${docs.path}${Platform.pathSeparator}ValleySave${Platform.pathSeparator}Backups';
  }

  String _hostSwapErrorMessage(HostSwapError? error) {
    final l10n = AppLocalizations.of(context)!;
    switch (error) {
      case HostSwapError.noFreeTile:
        return l10n.hostSwapErrNoSpace;
      case HostSwapError.writeFailure:
        return l10n.hostSwapErrWrite;
      case HostSwapError.postValidationFailed:
        return l10n.hostSwapErrValidation;
      case HostSwapError.invalidSave:
      case null:
        return l10n.hostSwapErrInvalid;
    }
  }

  /// Tarjeta translúcida compartida por todos los diálogos de confirmación:
  /// ancho acotado (evita la "barra rectangular" a lo ancho de la ventana),
  /// fondo mezclado con blur sutil detrás (sensación de profundidad, nunca
  /// negro plano) y esquinas más suaves que un `AlertDialog` por defecto.
  Widget _glassDialogShell({
    required Widget child,
    double maxWidth = 380,
    Color? accent,
  }) {
    final borderColor = (accent ?? _seasonAccent).withValues(alpha: 0.22);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF14110A).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 44,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Estructura título/contenido-scrollable/acciones común a todos los
  /// diálogos. `Wrap` en vez de `Row` para las acciones: con el ancho ahora
  /// acotado, 3 botones (como en el archivado) necesitan poder bajar de línea
  /// sin desbordar.
  Widget _dialogBody({
    required Widget title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 12),
        Flexible(child: SingleChildScrollView(child: content)),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: actions,
        ),
      ],
    );
  }

  /// Aviso inline: tinte muy sutil, sin borde — más compacto y translúcido
  /// que un `Container` con borde sólido (opción B aprobada, 2026-07-11).
  Widget _infoBox({required Color color, required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.firaCode(
                  fontSize: 10, height: 1.5, color: color.withValues(alpha: 0.85)),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmMakeHost({
    required String targetName,
    required String farmName,
    required int itemsToRelocate,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          maxWidth: 420,
          accent: const Color(0xFFE0B850),
          child: _dialogBody(
            title: Text(
              l10n.makeHostDialogTitle,
              style: GoogleFonts.bodoniModa(
                  color: AppColors.text,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.makeHostDialogIntro(targetName, farmName),
                  style: GoogleFonts.firaCode(
                      fontSize: 12, color: Colors.white.withValues(alpha: 0.80)),
                ),
                const SizedBox(height: 12),
                _infoBox(
                  color: const Color(0xFF7FBF7F),
                  icon: Icons.copy_all_outlined,
                  text: l10n.makeHostNewCopyNote,
                ),
                if (itemsToRelocate > 0) ...[
                  const SizedBox(height: 8),
                  _infoBox(
                    color: const Color(0xFF5AA8E0),
                    icon: Icons.open_with_rounded,
                    text: l10n.makeHostMoveCount(itemsToRelocate),
                  ),
                ],
                const SizedBox(height: 8),
                _infoBox(
                  color: const Color(0xFFE0A860),
                  icon: Icons.warning_amber_rounded,
                  text: l10n.makeHostHouseWarning,
                ),
              ],
            ),
            // Principal (Hacer anfitrión) arriba, Cancelar debajo — mismo
            // orden de jerarquía que el resto de diálogos (feedback 2026-07-11).
            actions: [
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.makeHostConfirmButton,
                  color: const Color(0xFFE0B850),
                  icon: Icons.workspace_premium_rounded,
                  filled: true,
                  onTap: () => Navigator.pop(ctx, true),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.cancel,
                  color: Colors.white.withValues(alpha: 0.55),
                  filled: false,
                  onTap: () => Navigator.pop(ctx, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Spec 007: el zip de respaldo YA existe en local cuando se llega aquí —
  /// las 3 opciones deciden su destino, ninguna es "no hacer nada todavía".
  /// Sin Drive conectado, "Subir" no tiene sentido → se omite el diálogo por
  /// completo y se muestra un snack.
  Future<void> _handleSwapBackupChoice(String backupZipPath) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null) {
      if (mounted) _snack(l10n.swapBackupLocalOnlySnack);
      return;
    }

    final choice = await _confirmSwapBackup();
    switch (choice) {
      case _SwapBackupChoice.upload:
        try {
          await widget.drive!.uploadBackupZip(backupZipPath);
          if (mounted) _snack(l10n.swapBackupUploadOk);
        } catch (e) {
          if (mounted) _snack(l10n.swapBackupUploadErr(e.toString()));
        }
        break;
      case _SwapBackupChoice.deleteNow:
        try {
          final file = File(backupZipPath);
          if (await file.exists()) await file.delete();
        } catch (_) {
          // best-effort
        }
        break;
      case _SwapBackupChoice.keepLocal:
      case null:
        break; // se queda tal cual, solo en local
    }
  }

  Future<_SwapBackupChoice?> _confirmSwapBackup() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<_SwapBackupChoice>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFF97C459),
          child: _dialogBody(
            title: Text(
              l10n.swapBackupDialogTitle,
              style: GoogleFonts.bodoniModa(
                  color: AppColors.text,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700),
            ),
            content: Text(
              l10n.swapBackupDialogBody,
              style: GoogleFonts.firaCode(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.80)),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.swapBackupUpload,
                  color: const Color(0xFF5AA8E0),
                  icon: Icons.cloud_upload_outlined,
                  filled: true,
                  onTap: () => Navigator.pop(ctx, _SwapBackupChoice.upload),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.swapBackupLocalOnly,
                  color: Colors.white.withValues(alpha: 0.65),
                  icon: Icons.laptop_mac_rounded,
                  filled: false,
                  onTap: () => Navigator.pop(ctx, _SwapBackupChoice.keepLocal),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.swapBackupDeleteNow,
                  color: const Color(0xFFE05252).withValues(alpha: 0.75),
                  icon: Icons.delete_outline_rounded,
                  filled: false,
                  onTap: () => Navigator.pop(ctx, _SwapBackupChoice.deleteNow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// spec 007 — abre la gestión de respaldos: merge local+Drive por
  /// `fileName` exacto (G10), nunca por proximidad de fecha.
  Future<void> _handleOpenBackups(SaveEntry entry) async {
    final local = entry.local;
    if (local == null) return;

    final backupsDir = await _backupsDirPath();
    final localBackups = await BackupService()
        .listLocalBackups(backupsDir, folderName: local.folderName);

    var driveBackups = <BackupEntry>[];
    if (widget.drive != null) {
      try {
        driveBackups = await widget.drive!.listDriveBackups(folderName: local.folderName);
      } catch (_) {
        // sin red o sin permiso: se sigue mostrando lo local
      }
    }

    final merged = <String, BackupEntry>{};
    for (final b in localBackups) {
      merged[b.fileName] = b;
    }
    for (final b in driveBackups) {
      final existing = merged[b.fileName];
      merged[b.fileName] =
          existing?.copyWith(driveFileId: b.driveFileId) ?? b;
    }
    final list = merged.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (!mounted) return;
    await _showBackupsDialog(local.farmName, list);
  }

  Future<void> _showBackupsDialog(String farmName, List<BackupEntry> initial) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            final entries = initial;
            return _glassDialogShell(
              maxWidth: 460,
              accent: const Color(0xFF97C459),
              child: _dialogBody(
                title: Text(l10n.backupsScreenTitle(farmName),
                    style: GoogleFonts.bodoniModa(
                        color: AppColors.text,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700)),
                content: entries.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(l10n.backupsEmpty,
                            style: GoogleFonts.firaCode(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5))),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final entry in entries)
                            _backupRow(
                              entry,
                              onRestore: () async {
                                await _handleRestoreBackup(entry);
                                if (ctx.mounted) Navigator.pop(ctx);
                              },
                              onDelete: () async {
                                final ok = await _handleDeleteBackup(entry);
                                if (ok) setState(() => entries.remove(entry));
                              },
                            ),
                        ],
                      ),
                actions: [
                  ActionBtn(
                    label: l10n.cardCloseBarrier,
                    color: Colors.white.withValues(alpha: 0.55),
                    filled: false,
                    onTap: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _backupRow(
    BackupEntry entry, {
    required VoidCallback onRestore,
    required VoidCallback onDelete,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final ts = entry.timestamp;
    String p(int n) => n.toString().padLeft(2, '0');
    final dateLabel = '${p(ts.day)}/${p(ts.month)}/${ts.year} · ${p(ts.hour)}:${p(ts.minute)}';
    final sizeLabel = '${(entry.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateLabel,
                    style: GoogleFonts.firaCode(
                        fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
                Text(sizeLabel,
                    style: GoogleFonts.firaCode(
                        fontSize: 9.5, color: Colors.white.withValues(alpha: 0.4))),
              ],
            ),
          ),
          Icon(Icons.laptop_mac_rounded,
              size: 14,
              color: entry.isLocal
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.12)),
          const SizedBox(width: 6),
          Icon(Icons.cloud_outlined,
              size: 14,
              color: entry.isOnDrive
                  ? const Color(0xFF5AA8E0)
                  : Colors.white.withValues(alpha: 0.12)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onRestore,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFF5AA8E0).withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(l10n.backupsRestore,
                  style: GoogleFonts.firaCode(fontSize: 10.5, color: const Color(0xFF7FC4F5))),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline_rounded,
                size: 16, color: const Color(0xFFE05252).withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRestoreBackup(BackupEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _confirmBackupAction(
      accent: const Color(0xFF5AA8E0),
      title: l10n.backupsRestoreConfirmTitle,
      body: l10n.backupsRestoreConfirmBody,
      confirmLabel: l10n.backupsRestore,
      confirmIcon: Icons.settings_backup_restore_rounded,
    );
    if (confirmed != true) return;

    final savesDir = SaveService.savesDirectory;
    if (savesDir == null) {
      if (mounted) _snack(l10n.snackPlatformNotSupported);
      return;
    }
    try {
      final result = await BackupService().restoreBackup(
        entry,
        savesDir: savesDir,
        downloadToPath: (entry.driveFileId != null && widget.drive != null)
            ? (path) => widget.drive!.downloadFile(entry.driveFileId!, path)
            : null,
      );
      if (!result.ok) {
        if (mounted) _snack(l10n.backupsRestoreErr(result.error?.name ?? ''));
        return;
      }
      await _load(silent: true);
      if (mounted) _snack(l10n.backupsRestoreOk);
    } catch (e) {
      if (mounted) _snack(l10n.backupsRestoreErr(e.toString()));
    }
  }

  /// Devuelve `true` si se borró (para que el caller quite la fila).
  Future<bool> _handleDeleteBackup(BackupEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _confirmBackupAction(
      accent: const Color(0xFFE05252),
      title: l10n.backupsDeleteConfirmTitle,
      body: l10n.backupsDeleteConfirmBody,
      confirmLabel: l10n.backupsDelete,
      confirmIcon: Icons.delete_outline_rounded,
    );
    if (confirmed != true) return false;

    try {
      if (entry.localPath != null) {
        await BackupService().deleteLocalBackup(entry.localPath!);
      }
      if (entry.driveFileId != null && widget.drive != null) {
        await widget.drive!.deleteDriveBackup(entry.driveFileId!);
      }
      unawaited(_loadBackupCounts());
      return true;
    } catch (e) {
      if (mounted) _snack(l10n.backupsDeleteErr(e.toString()));
      return false;
    }
  }

  Future<bool?> _confirmBackupAction({
    required Color accent,
    required String title,
    required String body,
    required String confirmLabel,
    required IconData confirmIcon,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: accent,
          child: _dialogBody(
            title: Text(title,
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: Text(
              body,
              style: GoogleFonts.firaCode(
                  fontSize: 12, height: 1.5, color: Colors.white.withValues(alpha: 0.80)),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: confirmLabel,
                  color: accent,
                  icon: confirmIcon,
                  filled: true,
                  onTap: () => Navigator.pop(ctx, true),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.cancel,
                  color: Colors.white.withValues(alpha: 0.55),
                  filled: false,
                  onTap: () => Navigator.pop(ctx, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Borrado unificado (feedback 2026-07-12): las opciones dependen de
  /// dónde exista de verdad el save — nunca se ofrece borrar una ubicación
  /// que no existe.
  Future<_DeleteChoice?> _confirmUnifiedDelete(
    String farmName, {
    required bool hasLocal,
    required bool hasDrive,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<_DeleteChoice>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE05252),
          child: _dialogBody(
            title: Text(l10n.deleteUnifiedTitle(farmName),
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: Text(
              l10n.deleteChooseLocationBody,
              style: GoogleFonts.firaCode(
                  fontSize: 12, height: 1.5, color: Colors.white.withValues(alpha: 0.80)),
            ),
            actions: [
              if (hasLocal)
                SizedBox(
                  width: double.infinity,
                  child: ActionBtn(
                    label: l10n.deleteOptionLocalOnly,
                    color: const Color(0xFFE0B850),
                    icon: Icons.laptop_mac_rounded,
                    filled: false,
                    onTap: () => Navigator.pop(ctx, _DeleteChoice.localOnly),
                  ),
                ),
              if (hasDrive)
                SizedBox(
                  width: double.infinity,
                  child: ActionBtn(
                    label: l10n.deleteOptionDriveOnly,
                    color: const Color(0xFF5AA8E0),
                    icon: Icons.cloud_outlined,
                    filled: false,
                    onTap: () => Navigator.pop(ctx, _DeleteChoice.driveOnly),
                  ),
                ),
              if (hasLocal && hasDrive)
                SizedBox(
                  width: double.infinity,
                  child: ActionBtn(
                    label: l10n.deleteOptionBoth,
                    color: const Color(0xFFE05252),
                    icon: Icons.delete_outline_rounded,
                    filled: true,
                    onTap: () => Navigator.pop(ctx, _DeleteChoice.both),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.cancel,
                  color: Colors.white.withValues(alpha: 0.55),
                  filled: false,
                  onTap: () => Navigator.pop(ctx),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// F1 — conflicto de importación (US2 escenario 5, FR-008): mismo patrón
  /// visual que [_confirmDeleteLocal], nunca sobrescribe en silencio.
  Future<bool?> _confirmImportConflict() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE05252),
          child: _dialogBody(
            title: Text(l10n.importConflictTitle,
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: Text(
              l10n.importConflictBody,
              style: GoogleFonts.firaCode(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.80)),
            ),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              ActionBtn(
                label: l10n.importConflictConfirm,
                color: const Color(0xFFE05252),
                icon: Icons.sync_alt_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Busca a la persona con este `uniqueId` en la lista de un save concreto
  /// — `null` si esa persona todavía no existe ahí (p.ej. Drive no
  /// re-subido tras un swap). El caller decide el fallback.
  PlayerStats? _matchPlayerById(List<PlayerStats> players, String uniqueId) {
    for (final p in players) {
      if (p.uniqueId == uniqueId) return p;
    }
    return null;
  }

  Future<bool?> _confirmDownload(SaveEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    final driveBase = entry.drive!;
    final localBase = entry.local;
    final playerBase = localBase ?? driveBase;
    final coop = playerBase.hasMultiplePlayers;
    var playerIndex = 0;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: StatefulBuilder(
        builder: (ctx, setDialogState) {
          final idx = coop ? playerIndex.clamp(0, playerBase.players.length - 1) : 0;
          final selected = playerBase.players[idx];
          // Cada lado busca a la MISMA persona (por uniqueId) en su PROPIA
          // lista, en vez de reutilizar el PlayerStats de un solo lado —
          // tras un swap, el índice 0 ya no es la misma persona en local y
          // en Drive (feedback 2026-07-12: "falso positivo" en la comparación).
          final drivePlayer = coop
              ? _matchPlayerById(driveBase.players, selected.uniqueId) ?? selected
              : selected;
          final drive = coop ? driveBase.forPlayer(drivePlayer) : driveBase;
          final local = localBase == null
              ? null
              : (coop
                  ? localBase.forPlayer(
                      _matchPlayerById(localBase.players, selected.uniqueId) ?? selected)
                  : localBase);
          final hostIndex = playerBase.players.indexWhere((p) => p.isHost);
          final switcher = coop
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlayerNameLabel(
                      name: drive.playerName,
                      gender: drive.genderLabel,
                      isHost: idx == hostIndex,
                    ),
                    const SizedBox(height: 6),
                    PlayerSwitcher(
                      count: playerBase.players.length,
                      index: idx,
                      hostIndex: hostIndex,
                      onSelect: (i) => setDialogState(() => playerIndex = i),
                    ),
                  ],
                )
              : null;
          return _glassDialogShell(
            maxWidth: 460,
            child: _dialogBody(
            title: Text(l10n.dlgDownloadTitle,
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (local == null) ...[
                  Text(
                    l10n.dlgDownloadNewDesc(
                      drive.farmName,
                      drive.dayOfMonth,
                      drive.playtimeLabel,
                    ),
                    style: GoogleFonts.firaCode(
                        fontSize: 12, color: Colors.white.withValues(alpha: 0.80)),
                  ),
                  if (switcher != null) ...[
                    const SizedBox(height: 12),
                    Center(child: switcher),
                  ],
                ] else
                  _overwritePreview(
                    l10n: l10n,
                    intro: l10n.dlgDownloadOverwrite(drive.farmName),
                    current: local,
                    result: drive,
                    currentLabel: l10n.previewLocalLabel,
                    resultLabel: l10n.previewFromDrive,
                    currentIcon: _localIcon,
                    resultIcon: '☁️',
                    resultColor: const Color(0xFF5AA8E0),
                    afterIntro: switcher,
                  ),
                if (local != null &&
                    drive.gameVersion.isNotEmpty &&
                    local.gameVersion.isNotEmpty &&
                    drive.gameVersion != local.gameVersion) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE09020).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE09020).withValues(alpha: 0.40)),
                    ),
                    child: Text(
                      l10n.versionMismatch(
                        local.gameVersion,
                        drive.gameVersion,
                      ),
                      style: GoogleFonts.firaCode(
                          fontSize: 10,
                          height: 1.5,
                          color: const Color(0xFFE09020).withValues(alpha: 0.90)),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              ActionBtn(
                label: l10n.dlgDownloadButton,
                color: const Color(0xFF5AA8E0),
                icon: Icons.cloud_download_outlined,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
            ),
          );
        },
        ),
      ),
    );
  }

  Future<bool?> _confirmUpload(SaveEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    final localBase = entry.local!;
    final driveBase = entry.drive;
    final coop = localBase.hasMultiplePlayers;
    var playerIndex = 0;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: StatefulBuilder(
        builder: (ctx, setDialogState) {
          final idx = coop ? playerIndex.clamp(0, localBase.players.length - 1) : 0;
          final selected = localBase.players[idx];
          final local = coop ? localBase.forPlayer(selected) : localBase;
          // Mismo fix que _confirmDownload: buscar a la misma persona (por
          // uniqueId) en la lista PROPIA de Drive, no reutilizar el
          // PlayerStats local para ambas columnas.
          final drive = driveBase == null
              ? null
              : (coop
                  ? driveBase.forPlayer(
                      _matchPlayerById(driveBase.players, selected.uniqueId) ?? selected)
                  : driveBase);
          final hostIndex = localBase.players.indexWhere((p) => p.isHost);
          final switcher = coop
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlayerNameLabel(
                      name: local.playerName,
                      gender: local.genderLabel,
                      isHost: idx == hostIndex,
                    ),
                    const SizedBox(height: 6),
                    PlayerSwitcher(
                      count: localBase.players.length,
                      index: idx,
                      hostIndex: hostIndex,
                      onSelect: (i) => setDialogState(() => playerIndex = i),
                    ),
                  ],
                )
              : null;
          return _glassDialogShell(
            maxWidth: 460,
            child: _dialogBody(
            title: Text(l10n.dlgUploadTitle,
                style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700)),
            content: drive == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dlgUploadNewDesc(
                          local.farmName,
                          local.dayOfMonth,
                          local.playtimeLabel,
                        ),
                        style: GoogleFonts.firaCode(
                            fontSize: 12, color: Colors.white.withValues(alpha: 0.80)),
                      ),
                      if (switcher != null) ...[
                        const SizedBox(height: 12),
                        Center(child: switcher),
                      ],
                    ],
                  )
                : _overwritePreview(
                    l10n: l10n,
                    intro: l10n.dlgUploadOverwriteDrive(local.farmName),
                    current: drive,
                    result: local,
                    currentLabel: l10n.previewDriveLabel,
                    resultLabel: l10n.previewFromDevice,
                    currentIcon: '☁️',
                    resultIcon: _localIcon,
                    resultColor: const Color(0xFFE0B850),
                    afterIntro: switcher,
                  ),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              ActionBtn(
                label: l10n.dlgUploadButton,
                color: const Color(0xFFE0B850),
                icon: Icons.cloud_upload_outlined,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
            ),
          );
        },
        ),
      ),
    );
  }

  /// Card "cómo quedará": estado actual del destino → estado tras la operación.
  Widget _overwritePreview({
    required AppLocalizations l10n,
    required String intro,
    required SaveFile current,
    required SaveFile result,
    required String currentLabel,
    required String resultLabel,
    required String currentIcon,
    required String resultIcon,
    required Color resultColor,
    Widget? afterIntro,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intro,
          style: GoogleFonts.firaCode(
              fontSize: 12,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.80)),
        ),
        if (afterIntro != null) ...[
          const SizedBox(height: 12),
          Center(child: afterIntro),
        ],
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _previewCol(l10n, currentLabel, current,
                    other: result,
                    accent: Colors.white.withValues(alpha: 0.40),
                    icon: currentIcon),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 18, color: Colors.white.withValues(alpha: 0.45)),
              ),
              Expanded(
                child: _previewCol(l10n, resultLabel, result,
                    other: current, accent: resultColor, icon: resultIcon),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color get _seasonAccent =>
      SeasonData.data[SeasonController.instance.season.value]!.accentColor;

  String get _localIcon => (Platform.isAndroid || Platform.isIOS) ? '📱' : '💻';

  Widget _previewCol(AppLocalizations l10n, String header, SaveFile s,
      {required SaveFile other, required Color accent, required String icon}) {
    final hl = _seasonAccent;
    String mine(SaveFile x) =>
        x.deepestMineLevel == 0 ? l10n.previewColUnexplored : 'Nv. ${x.deepestMineLevel}';
    // true = este valor es peor que el otro (lower is worse), false = mejor, null = igual
    bool? w(num a, num b) => a == b ? null : a < b ? true : false;
    // invertido: más = peor (desmayos)
    bool? wi(num a, num b) => a == b ? null : a > b ? true : false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151512),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.60), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 5),
              Text(header,
                  style: GoogleFonts.firaCode(
                      fontSize: 8,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      color: accent)),
            ],
          ),
          const SizedBox(height: 6),
          _previewRow(l10n.previewColDayYear, l10n.statDayYear(s.dayOfMonth, s.year),
              changed: s.dayOfMonth != other.dayOfMonth || s.year != other.year,
              hl: hl,
              worse: w(s.year * 28 + s.dayOfMonth, other.year * 28 + other.dayOfMonth)),
          _previewRow(l10n.previewColTime, s.playtimeLabel,
              changed: s.millisecondsPlayed != other.millisecondsPlayed,
              hl: hl,
              worse: w(s.millisecondsPlayed, other.millisecondsPlayed)),
          _previewRow(l10n.previewColMoney, s.currentMoneyLabel,
              changed: s.currentMoney != other.currentMoney,
              hl: hl,
              worse: w(s.currentMoney, other.currentMoney)),
          _previewRow(l10n.previewColTotal, s.totalMoneyLabel,
              changed: s.totalMoneyEarned != other.totalMoneyEarned,
              hl: hl,
              worse: w(s.totalMoneyEarned, other.totalMoneyEarned)),
          _previewRow(l10n.previewColFarming, '${s.farmingLevel}',
              changed: s.farmingLevel != other.farmingLevel,
              hl: hl,
              worse: w(s.farmingLevel, other.farmingLevel)),
          _previewRow(l10n.previewColForaging, '${s.foragingLevel}',
              changed: s.foragingLevel != other.foragingLevel,
              hl: hl,
              worse: w(s.foragingLevel, other.foragingLevel)),
          _previewRow(l10n.previewColMining, '${s.miningLevel}',
              changed: s.miningLevel != other.miningLevel,
              hl: hl,
              worse: w(s.miningLevel, other.miningLevel)),
          _previewRow(l10n.previewColFishing, '${s.fishingLevel}',
              changed: s.fishingLevel != other.fishingLevel,
              hl: hl,
              worse: w(s.fishingLevel, other.fishingLevel)),
          _previewRow(l10n.previewColCombat, '${s.combatLevel}',
              changed: s.combatLevel != other.combatLevel,
              hl: hl,
              worse: w(s.combatLevel, other.combatLevel)),
          _previewRow(l10n.previewColFriends, '${s.goodFriends}',
              changed: s.goodFriends != other.goodFriends,
              hl: hl,
              worse: w(s.goodFriends, other.goodFriends)),
          _previewRow(l10n.previewColMonsters, SaveFile.formatCount(s.monstersKilled),
              changed: s.monstersKilled != other.monstersKilled,
              hl: hl,
              worse: w(s.monstersKilled, other.monstersKilled)),
          _previewRow(l10n.previewColFaints, '${s.timesUnconscious}',
              changed: s.timesUnconscious != other.timesUnconscious,
              hl: hl,
              worse: wi(s.timesUnconscious, other.timesUnconscious)),
          _previewRow(l10n.previewColMine, mine(s),
              changed: s.deepestMineLevel != other.deepestMineLevel,
              hl: hl,
              worse: w(s.deepestMineLevel, other.deepestMineLevel)),
        ],
      ),
    );
  }

  Widget _previewRow(String label, String value,
      {required bool changed, required Color hl, bool? worse}) {
    const kRed = Color(0xFFE05C5C);
    final pillColor = (changed && worse == true) ? kRed : hl;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: GoogleFonts.firaCode(
                  fontSize: 7.5,
                  letterSpacing: 0.6,
                  color: AppColors.textFaint)),
          const SizedBox(height: 1),
          if (changed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: pillColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: pillColor.withValues(alpha: 0.32)),
              ),
              child: Text(value,
                  style: GoogleFonts.firaCode(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: pillColor)),
            )
          else
            Text(value,
                style: GoogleFonts.firaCode(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.75))),
        ],
      ),
    );
  }

  OverlayEntry? _snackEntry;

  void _snack(String msg) {
    if (!mounted) return;
    _snackEntry?.remove();
    final accent = _seasonAccent;
    _snackEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 48,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accent.withValues(alpha: 0.32)),
              ),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: GoogleFonts.firaCode(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.45,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_snackEntry!);
    Future.delayed(const Duration(seconds: 4), () {
      _snackEntry?.remove();
      _snackEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.f5) {
          _refresh();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: ValueListenableBuilder<SeasonState>(
              valueListenable: SeasonController.instance.season,
              builder: (_, season, _) => ValleyCanvasWidget(season: season),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.40, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.62),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SavesTopBar(
                  onBack: () => Navigator.pop(context),
                  onSettings: _openSettings,
                  onRefresh: _refresh,
                  refreshing: _refreshing,
                  canLaunchGame: _gameCanLaunch,
                  onLaunch: _handleLaunchGame,
                  onImport: _handleImport,
                ),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBody() {
    if (Platform.isAndroid) {
      // Aún leyendo la preferencia de modo.
      if (_mode == null) return _spinner();
      // Sin vía elegida → selector.
      if (_mode == AndroidMode.chooser) return _buildModeChooser();
      // Submodo Shizuku: comprobando / sin permiso → onboarding.
      if (_mode == AndroidMode.shizuku) {
        if (_shizukuRunning == null) return _spinner();
        if (!_shizukuReady) return _buildShizukuGate();
      }
      // Submodo Puente: nunca bloquea; cae al flujo normal de lista.
    }
    if (_loading) return _seasonalLoader();

    // US5: la sección "Compartidas conmigo" es su propio ítem final de la
    // lista — solo con Drive conectado (sin él no hay forma de usar Picker).
    final showShared = widget.drive != null;
    // Un save descargado de un compartido NUNCA se duplica en "Mis
    // partidas" — vive solo en "Compartidas conmigo" (decisión 2026-07-12,
    // evita confusión de dos tarjetas casi idénticas). Sigue existiendo de
    // verdad en la carpeta Saves del juego (necesario para cargarlo), solo
    // se oculta de esta lista.
    final sharedFolderNames = _sharedEntries.map((e) => e.folderName).toSet();
    final visibleEntries =
        _entries.where((e) => !sharedFolderNames.contains(e.folderName)).toList();
    final entriesEmpty = visibleEntries.isEmpty;
    final sharedEmpty = !showShared || (_sharedEntries.isEmpty && !_sharedLoading);
    if (entriesEmpty && sharedEmpty) return _buildEmpty();

    final itemCount = visibleEntries.length + (showShared ? 1 : 0);

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          if (showShared && i == visibleEntries.length) {
            return StaggerItem(
              key: ValueKey('${_staggerVersion}_shared'),
              index: i,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: _buildSharedSection(),
                ),
              ),
            );
          }
          return StaggerItem(
            key: ValueKey('${_staggerVersion}_$i'),
            index: i,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (i == 0)
                      LatestBadge(color: visibleEntries[0].primary.seasonColor),
                    SaveCard(
                      entry: visibleEntries[i],
                      busy: _busy.contains(visibleEntries[i].folderName),
                      onUpload: () => _handleUpload(visibleEntries[i]),
                      onDownload: () => _handleDownload(visibleEntries[i]),
                      // Borrado unificado: da igual desde qué cara se pulse
                      // "Eliminar" — el mismo diálogo detecta qué ubicaciones
                      // existen y ofrece solo esas (feedback 2026-07-12).
                      onDeleteFromDrive: (visibleEntries[i].driveFolderId != null &&
                                  widget.drive != null) ||
                              visibleEntries[i].local != null
                          ? () => _handleDelete(visibleEntries[i])
                          : null,
                      onDeleteLocal: (visibleEntries[i].driveFolderId != null &&
                                  widget.drive != null) ||
                              visibleEntries[i].local != null
                          ? () => _handleDelete(visibleEntries[i])
                          : null,
                      // F3 — v1 solo Windows; el gate de plataforma vive aquí,
                      // en un único sitio (ver plan.md §Flujo UI).
                      onMakeHost: Platform.isWindows && visibleEntries[i].local != null
                          ? (target) => _handleMakeHost(visibleEntries[i], target)
                          : null,
                      onExport: visibleEntries[i].local != null
                          ? () => _handleExport(visibleEntries[i])
                          : null,
                      onShare: widget.drive != null && visibleEntries[i].driveFolderId != null
                          ? () => _handleShare(visibleEntries[i])
                          : null,
                      onBackups: (_backupCounts[visibleEntries[i].folderName] ?? 0) > 0
                          ? () => _handleOpenBackups(visibleEntries[i])
                          : null,
                      backupCount: _backupCounts[visibleEntries[i].folderName] ?? 0,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// US5 — bloque "Compartidas conmigo", visualmente separado de las
  /// secciones propias (locales/Drive) — nunca mezcla tarjetas.
  Widget _buildSharedSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_entries.isNotEmpty) const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.sharedWithMeTitle.toUpperCase(),
                style: GoogleFonts.firaCode(
                  fontSize: 10.5,
                  letterSpacing: 1.2,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
            GestureDetector(
              onTap: _handleAddShared,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0B850).withValues(alpha: 0.16),
                  border:
                      Border.all(color: const Color(0xFFE0B850).withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '+ ${l10n.sharedWithMeAdd}',
                  style: GoogleFonts.firaCode(
                      fontSize: 10.5, color: const Color(0xFFE0B850)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_sharedLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_sharedEntries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              l10n.sharedWithMeEmpty,
              style: GoogleFonts.firaCode(
                  fontSize: 12, color: Colors.white.withValues(alpha: 0.35)),
            ),
          )
        else
          for (final e in _sharedEntries) ...[
            SharedSaveCard(
              entry: e,
              busy: _busy.contains(e.folderName),
              onDownload: () => _handleDownloadShared(e),
              onSync: (e.canSync && e.localMatch != null)
                  ? () => _handleSyncShared(e)
                  : null,
              onRemove: () => _handleRemoveShared(e),
              // F3 — mismo gate que la lista principal (v1 solo Windows,
              // solo con copia local); la hoja de detalle aplica el resto
              // (coop + jugador visible no-anfitrión).
              onMakeHost: Platform.isWindows && e.localMatch != null
                  ? (target) => _handleMakeHost(e.asEntry, target)
                  : null,
              // Modelo de 3 sitios: "Subir a mi Drive" compara LOCAL contra
              // TU PROPIO Drive (asOwnEntry), nunca contra el del dueño —
              // el footer decide cuándo mostrarlo (revocado, o local por
              // delante de tu copia). Disponible siempre que haya Drive
              // conectado y copia local, no solo cuando se revoca el acceso
              // (decisión 2026-07-12, modelo de 3 sitios).
              onUploadToOwnDrive: widget.drive != null && e.localMatch != null
                  ? () => _handleUpload(e.asOwnEntry)
                  : null,
              onSyncBoth: widget.drive != null &&
                      e.localMatch != null &&
                      e.canSync
                  ? () async {
                      await _handleUpload(e.asOwnEntry);
                      if (mounted) await _handleSyncShared(e);
                    }
                  : null,
              // Exportar/Backups operan sobre la copia LOCAL — mismo
              // comportamiento que en "Mis partidas", recuperado tras el
              // rediseño de la tarjeta compartida (2026-07-12).
              onExport: e.localMatch != null
                  ? () => _handleExport(e.asEntry)
                  : null,
              onBackups: (_backupCounts[e.folderName] ?? 0) > 0
                  ? () => _handleOpenBackups(e.asEntry)
                  : null,
              backupCount: _backupCounts[e.folderName] ?? 0,
            ),
            const SizedBox(height: 14),
          ],
      ],
    );
  }

  Widget _spinner() => _seasonalLoader();

  Widget _seasonalLoader() => ValueListenableBuilder<SeasonState>(
        valueListenable: SeasonController.instance.season,
        builder: (_, season, _) => SeasonalLoader(
          key: ValueKey(season),
          season: season,
        ),
      );

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌾', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            l10n.emptyNoSaves,
            style: GoogleFonts.firaCode(fontSize: 13, color: AppColors.textFaint),
          ),
          const SizedBox(height: 6),
          Text(
            SaveService.savesDirectory ?? l10n.emptyNoSavesHint,
            style: GoogleFonts.firaCode(
              fontSize: 9,
              color: AppColors.textFaint.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Selector de vía: Root / Shizuku.
  Widget _buildModeChooser() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const Text('🔌', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 14),
          Text(
            l10n.chooserTitle,
            style: GoogleFonts.bodoniModa(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.92),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.chooserDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.firaCode(
              fontSize: 11.5,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 22),
          _modeCard(
            badge: l10n.chooserRootBadge,
            title: l10n.chooserRootTitle,
            desc: l10n.chooserRootDesc,
            onTap: () => _chooseMode(AndroidMode.root),
            recommended: false,
          ),
          const SizedBox(height: 9),
          _modeCard(
            badge: l10n.hiwShizukuBadge,
            title: l10n.hiwShizukuTitle,
            desc: l10n.chooserShizukuDesc,
            onTap: () => _chooseMode(AndroidMode.shizuku),
            recommended: false,
          ),
          const SizedBox(height: 18),
          _howItWorksLink(),
        ],
      ),
    );
  }

  Widget _modeCard({
    required String badge,
    required String title,
    required String desc,
    required VoidCallback onTap,
    required bool recommended,
  }) {
    // Mismo lenguaje que _modeTile de Opciones: transparente sobre el canvas,
    // tinte de estación; el recomendado destacado, el otro tenue pero acorde.
    final season = _seasonAccent;
    bool pressed = false;
    return StatefulBuilder(
      builder: (_, setState) => Listener(
        onPointerDown: (_) => setState(() => pressed = true),
        onPointerUp: (_) => setState(() => pressed = false),
        onPointerCancel: (_) => setState(() => pressed = false),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedScale(
            scale: pressed ? 0.97 : 1.0,
            duration: pressed
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: recommended
                    ? Color.alphaBlend(
                        season.withValues(alpha: 0.16),
                        const Color(0xFF040405),
                      ).withValues(alpha: 0.68)
                    : Color.alphaBlend(
                        season.withValues(alpha: 0.07),
                        Colors.black,
                      ).withValues(alpha: 0.42),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: season.withValues(alpha: recommended ? 0.60 : 0.22),
                  width: recommended ? 1.5 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(badge,
                            style: GoogleFonts.firaCode(
                              fontSize: 8.5,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w700,
                              color: recommended ? season : AppColors.textFaint,
                            )),
                        const SizedBox(height: 4),
                        Text(title,
                            style: GoogleFonts.firaCode(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: recommended ? season : AppColors.text,
                            )),
                        const SizedBox(height: 5),
                        Text(desc,
                            style: GoogleFonts.firaCode(
                              fontSize: 12,
                              height: 1.5,
                              color: recommended
                                  ? Colors.white.withValues(alpha: 0.82)
                                  : AppColors.textFaint,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: recommended ? season : Colors.transparent,
                      border: recommended
                          ? null
                          : Border.all(
                              color: season.withValues(alpha: 0.30), width: 2),
                    ),
                    child: recommended
                        ? const Icon(Icons.check_rounded,
                            size: 13, color: Colors.black)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _howItWorksLink() {
    final accent =
        SeasonData.data[SeasonController.instance.season.value]!.accentColor;
    bool pressed = false;
    return StatefulBuilder(
      builder: (_, setState) => Listener(
        onPointerDown: (_) => setState(() => pressed = true),
        onPointerUp: (_) => setState(() => pressed = false),
        onPointerCancel: (_) => setState(() => pressed = false),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            AppPageRoute(
                builder: (_) =>
                    const HowItWorksScreen(scrollToSection: 'shizuku')),
          ),
          child: AnimatedScale(
            scale: pressed ? 0.97 : 1.0,
            duration: pressed
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.32),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.70)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.help_outline_rounded,
                      size: 15, color: Colors.white.withValues(alpha: 0.90)),
                  const SizedBox(width: 7),
                  Text(
                    AppLocalizations.of(context)!.howItWorks,
                    style: GoogleFonts.firaCode(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.90),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildShizukuGate() {
    final l10n = AppLocalizations.of(context)!;
    final running = _shizukuRunning == true;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  l10n.shizukuStepTitle,
                  style: GoogleFonts.bodoniModa(
                    fontSize: 26,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  l10n.shizukuGateSubtitle,
                  style: GoogleFonts.firaCode(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Estado como pasos-fila transparentes; el CTA "conceder" se
              // integra en la fila de permiso cuando Shizuku ya está activo.
              _statusRow(
                l10n.shizukuStatusLabel,
                running ? l10n.shizukuStatusRunning : l10n.shizukuStatusNotDetected,
                running,
              ),
              _statusRow(
                l10n.shizukuPermLabel,
                _shizukuGranted
                    ? l10n.shizukuPermGranted
                    : l10n.shizukuPermNotGranted,
                _shizukuGranted,
                action: (running && !_shizukuGranted)
                    ? _miniGateButton(
                        l10n.shizukuGrant, _requestShizukuPermission, _seasonAccent)
                    : null,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    _seasonAccent.withValues(alpha: 0.06),
                    Colors.black,
                  ).withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _seasonAccent.withValues(alpha: 0.16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.shizukuGuideHeader,
                      style: GoogleFonts.firaCode(
                        fontSize: 9,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        color: _seasonAccent.withValues(alpha: 0.60),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _guideStep('1', l10n.shizukuStep1Title,
                        l10n.shizukuStep1DescFull,
                        action: Wrap(spacing: 8, runSpacing: 8, children: [
                          _smallButton(l10n.btnPlayStore, _openShizukuPlayStore),
                          _smallButton(l10n.btnApkGithub, _openShizukuGithub),
                        ])),
                    _guideStep('2', l10n.shizukuStep2TitleFull,
                        l10n.shizukuStep2DescFull),
                    _guideStep('3', l10n.shizukuStep3TitleFull,
                        l10n.shizukuStep3DescFull,
                        action: _smallButton(l10n.btnOpenAndHighlight, _openWirelessDebug,
                            icon: Icons.open_in_new_rounded)),
                    _guideStep('4', l10n.shizukuStep4Title,
                        l10n.shizukuStep4Desc,
                        action: _smallButton(l10n.btnOpenShizuku, _openShizukuApp,
                            icon: Icons.open_in_new_rounded)),
                    _guideStep('5', l10n.shizukuStep5Title,
                        l10n.shizukuStep5Desc,
                        action: _smallButton(l10n.btnShizukuAppInfo,
                            _openShizukuAppInfo, icon: Icons.open_in_new_rounded)),
                    _guideStep(
                      '6',
                      l10n.shizukuStep3Title,
                      running
                          ? l10n.shizukuStep6DescActive
                          : l10n.shizukuStep6DescWaiting,
                      action: running
                          ? _gateButton(
                              l10n.btnGrantPermission, _requestShizukuPermission,
                              filled: true)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    if (!running)
                      _gateButton(l10n.btnCheckShizuku, _checkShizuku,
                          filled: true),
                    const SizedBox(height: 10),
                    _gateButton(l10n.bridgeChangeMode, _resetMode, filled: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(child: _howItWorksLink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusRow(String label, String sublabel, bool done, {Widget? action}) {
    // Hecho → verde de estado real. Pendiente → acento de la estación.
    final tone = done ? AppColors.statusOk : _seasonAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          tone.withValues(alpha: done ? 0.06 : 0.11),
          Colors.black,
        ).withValues(alpha: 0.44),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tone.withValues(alpha: done ? 0.32 : 0.50),
          width: done ? 1 : 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? tone.withValues(alpha: 0.16) : Colors.transparent,
              border: done
                  ? null
                  : Border.all(color: tone.withValues(alpha: 0.65), width: 2),
            ),
            child: done
                ? Icon(Icons.check_rounded, size: 13, color: tone)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  sublabel,
                  style: GoogleFonts.firaCode(
                    fontSize: 10.5,
                    height: 1.4,
                    color: _seasonAccent.withValues(alpha: 0.90),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (action != null)
            action
          else
            Text(
              done
                  ? AppLocalizations.of(context)!.statusDone
                  : AppLocalizations.of(context)!.statusPending,
              style: GoogleFonts.firaCode(
                fontSize: 9,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w700,
                color: tone.withValues(alpha: done ? 0.85 : 0.70),
              ),
            ),
        ],
      ),
    );
  }

  /// Botón compacto (p. ej. "conceder") para integrar dentro de una fila.
  Widget _miniGateButton(String label, VoidCallback onTap, Color tone) {
    bool pressed = false;
    return StatefulBuilder(
      builder: (_, setState) => GestureDetector(
        onTap: onTap,
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) => setState(() => pressed = false),
        onTapCancel: () => setState(() => pressed = false),
        child: AnimatedScale(
          scale: pressed ? 0.94 : 1.0,
          duration: pressed
              ? const Duration(milliseconds: 100)
              : const Duration(milliseconds: 200),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: tone.withValues(alpha: 0.45)),
            ),
            child: Text(
              label,
              style: GoogleFonts.firaCode(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: tone,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _guideStep(String n, String title, String desc, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _seasonAccent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border:
                  Border.all(color: _seasonAccent.withValues(alpha: 0.35)),
            ),
            child: Text(
              n,
              style: GoogleFonts.firaCode(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _seasonAccent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    title,
                    style: GoogleFonts.firaCode(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.firaCode(
                    fontSize: 14,
                    height: 1.55,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 9),
                  action,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String label, VoidCallback onTap, {IconData? icon}) {
    final tone = _seasonAccent;
    bool pressed = false;
    return StatefulBuilder(
      builder: (_, setState) => Listener(
        onPointerDown: (_) => setState(() => pressed = true),
        onPointerUp: (_) => setState(() => pressed = false),
        onPointerCancel: (_) => setState(() => pressed = false),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedScale(
            scale: pressed ? 0.95 : 1.0,
            duration: pressed
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: tone.withValues(alpha: 0.40)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 13, color: tone),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.firaCode(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tone,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gateButton(String label, VoidCallback onTap, {required bool filled}) {
    final tone = _seasonAccent;
    bool pressed = false;
    return StatefulBuilder(
      builder: (_, setState) => Listener(
        onPointerDown: (_) => setState(() => pressed = true),
        onPointerUp: (_) => setState(() => pressed = false),
        onPointerCancel: (_) => setState(() => pressed = false),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedScale(
            scale: pressed ? 0.97 : 1.0,
            duration: pressed
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: filled ? tone.withValues(alpha: 0.14) : Colors.transparent,
                border: Border.all(
                    color: tone.withValues(alpha: filled ? 0.55 : 0.28)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: GoogleFonts.firaCode(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: filled ? tone : AppColors.textFaint,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
