import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/app_localizations.dart';
import '../../core/models/save_entry.dart';
import '../../core/models/save_file.dart';
import '../../core/models/season_state.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/drive_service.dart';
import '../../core/services/game_launch_service.dart';
import '../../core/services/save_service.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/shizuku_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/utils/app_page_route.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../help/how_it_works_screen.dart';
import '../settings/settings_screen.dart';
import 'save_card.dart';
import 'widgets/latest_badge.dart';
import 'widgets/saves_top_bar.dart';
import 'widgets/seasonal_loader.dart';
import 'widgets/stagger_item.dart';

/// Vía de acceso a los saves locales en Android.
/// `chooser` = aún sin elegir · `shizuku` = ADB (Shizuku) · `root` = su directo.
enum AndroidMode { chooser, shizuku, root }

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
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel,
                style: GoogleFonts.firaCode(
                    color: Colors.white.withValues(alpha: 0.6))),
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

  Future<void> _handleDeleteFromDrive(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final folderId = entry.driveFolderId;
    if (folderId == null || widget.drive == null) return;

    final farmName = entry.primary.farmName;
    final name = entry.folderName;
    if (_busy.contains(name)) return;

    final confirmed = await _confirmDelete(farmName);
    if (confirmed != true) return;

    setState(() => _busy.add(name));
    try {
      await widget.drive!.trashSave(folderId);
      await _load(silent: true);
      if (mounted) _snack(l10n.snackTrashed(farmName));
    } catch (e) {
      if (mounted) _snack(l10n.snackDeleteError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  Future<void> _handleDeleteLocal(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final farmName = entry.primary.farmName;
    final name = entry.folderName;
    if (_busy.contains(name)) return;

    final confirmed = await _confirmDeleteLocal(farmName);
    if (confirmed != true) return;

    setState(() => _busy.add(name));
    try {
      if (Platform.isAndroid && _mode == AndroidMode.root) {
        final ok = await ShizukuService.instance.deleteLocalAsRoot(name);
        if (!ok && mounted) _snack(l10n.snackDeleteError('su rm failed'));
      } else {
        final localSave = entry.local;
        if (localSave == null) return;
        final dir = Directory(localSave.folderPath);
        if (await dir.exists()) await dir.delete(recursive: true);
      }
      await _load(silent: true);
      if (mounted) _snack(l10n.snackDeletedLocal(farmName));
    } catch (e) {
      if (mounted) _snack(l10n.snackDeleteError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  Future<bool?> _confirmDelete(String farmName) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color.alphaBlend(
            const Color(0xFFE05252).withValues(alpha: 0.08),
            const Color(0xFF0A0A0B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
              color: const Color(0xFFE05252).withValues(alpha: 0.35)),
        ),
        title: Text(l10n.dlgDeleteDriveTitle,
            style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.confirmDelete(farmName),
              style: GoogleFonts.firaCode(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.80)),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.hiwTipDeletion,
              style: GoogleFonts.firaCode(
                  fontSize: 11,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.55)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel,
                style: GoogleFonts.firaCode(
                    color: Colors.white.withValues(alpha: 0.6))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.cardDetailDeleteLabel,
                style: GoogleFonts.firaCode(
                    color: const Color(0xFFE05252),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDeleteLocal(String farmName) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color.alphaBlend(
            const Color(0xFFE05252).withValues(alpha: 0.08),
            const Color(0xFF0A0A0B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
              color: const Color(0xFFE05252).withValues(alpha: 0.35)),
        ),
        title: Text(l10n.dlgDeleteLocalTitle,
            style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.deleteFromDeviceMessage(farmName),
              style: GoogleFonts.firaCode(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.80)),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.dlgDeleteLocalWarning,
              style: GoogleFonts.firaCode(
                  fontSize: 11,
                  height: 1.5,
                  color: const Color(0xFFE05252).withValues(alpha: 0.90),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel,
                style: GoogleFonts.firaCode(
                    color: Colors.white.withValues(alpha: 0.6))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.dlgDelete,
                style: GoogleFonts.firaCode(
                    color: const Color(0xFFE05252),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
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
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final idx = coop ? playerIndex.clamp(0, playerBase.players.length - 1) : 0;
          final drive = coop ? driveBase.forPlayer(playerBase.players[idx]) : driveBase;
          final local = localBase == null
              ? null
              : (coop ? localBase.forPlayer(playerBase.players[idx]) : localBase);
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
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: _seasonAccent.withValues(alpha: 0.25)),
            ),
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
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              const SizedBox(width: 8),
              ActionBtn(
                label: l10n.dlgDownloadButton,
                color: const Color(0xFF5AA8E0),
                icon: Icons.cloud_download_outlined,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
          );
        },
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
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final idx = coop ? playerIndex.clamp(0, localBase.players.length - 1) : 0;
          final local = coop ? localBase.forPlayer(localBase.players[idx]) : localBase;
          final drive = driveBase == null
              ? null
              : (coop ? driveBase.forPlayer(localBase.players[idx]) : driveBase);
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
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: _seasonAccent.withValues(alpha: 0.25)),
            ),
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
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
              const SizedBox(width: 8),
              ActionBtn(
                label: l10n.dlgUploadButton,
                color: const Color(0xFFE0B850),
                icon: Icons.cloud_upload_outlined,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ],
          );
        },
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
    if (_entries.isEmpty) return _buildEmpty();

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: _entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (_, i) => StaggerItem(
          key: ValueKey('${_staggerVersion}_$i'),
          index: i,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (i == 0) LatestBadge(color: _entries[0].primary.seasonColor),
                  SaveCard(
                    entry: _entries[i],
                    busy: _busy.contains(_entries[i].folderName),
                    onUpload: () => _handleUpload(_entries[i]),
                    onDownload: () => _handleDownload(_entries[i]),
                    onDeleteFromDrive: _entries[i].driveFolderId != null &&
                            widget.drive != null
                        ? () => _handleDeleteFromDrive(_entries[i])
                        : null,
                    onDeleteLocal: _entries[i].local != null &&
                            _mode != AndroidMode.root
                        ? () => _handleDeleteLocal(_entries[i])
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
