import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/save_entry.dart';
import '../../core/models/save_file.dart';
import '../../core/models/season_state.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/bridge_service.dart';
import '../../core/services/drive_service.dart';
import '../../core/services/save_service.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/shizuku_service.dart';
import '../../core/services/stardew_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../help/how_it_works_screen.dart';
import '../settings/settings_screen.dart';
import 'save_card.dart';

/// Vía de acceso a los saves locales en Android.
/// `chooser` = aún sin elegir · `shizuku` = automático (ADB, única vía fiable en
/// Android 13+) · `bridge` = puente manual (solo útil en Android 11-12).
enum AndroidMode { chooser, shizuku, bridge, root }

class SavesScreen extends StatefulWidget {
  const SavesScreen({super.key, this.drive});

  final DriveService? drive;

  @override
  State<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends State<SavesScreen> with WidgetsBindingObserver {
  List<SaveEntry> _entries = [];
  bool _loading = true;
  final _busy = <String>{}; // folderName en curso (subiendo/descargando)

  // ── Modo de acceso en Android ──
  static const _modePrefKey = 'android_access_mode';
  AndroidMode? _mode; // null = aún leyendo la preferencia
  String? _bridgeInPath; // ruta de bridge_in (modo puente), para mostrar
  int _sdkInt = 33; // assume 13+ until native replies; hides bridge by default
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
    // Puente: el usuario pudo copiar partidas con Archivos mientras tanto.
    if (_mode == AndroidMode.bridge) {
      _load(silent: true);
    }
  }

  /// Comprueba si el dispositivo puede leer gameSavesPath directamente (root).
  Future<bool> _canAccessDirect() async {
    try {
      final dir = Directory(gameSavesPath);
      if (!await dir.exists()) return false;
      await dir.list().first;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _init() async {
    if (!Platform.isAndroid) {
      _mode = AndroidMode.bridge; // no aplica; evita ramas de gate en desktop
      await _load();
      return;
    }
    // Detectar versión de Android para condicionar el chooser.
    _sdkInt = await ShizukuService.instance.sdkInt();
    // Root / acceso directo: si funciona, carga sin mostrar ningún selector.
    if (await _canAccessDirect()) {
      if (!mounted) return;
      setState(() => _mode = AndroidMode.root);
      await _load();
      return;
    }
    // Recupera la vía elegida en sesiones anteriores.
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_modePrefKey);
    final mode = switch (saved) {
      'shizuku' => AndroidMode.shizuku,
      'bridge' => AndroidMode.bridge,
      _ => AndroidMode.chooser,
    };
    if (!mounted) return;
    setState(() => _mode = mode);
    await _enterMode(mode);
  }

  Future<void> _chooseMode(AndroidMode mode) async {
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
      case AndroidMode.bridge:
        await _prepareBridge();
        await _load();
      case AndroidMode.chooser:
        if (mounted) setState(() => _loading = false);
      case AndroidMode.root:
        await _load(); // acceso directo ya verificado en _init
    }
  }

  /// Crea las carpetas del puente y cachea la ruta de `bridge_in` para mostrarla.
  Future<void> _prepareBridge() async {
    final inPath = await BridgeService.instance.inPath();
    await BridgeService.instance.outDir(); // asegura que existe
    if (mounted) setState(() => _bridgeInPath = inPath);
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
    final ok = await ShizukuService.instance.openWirelessDebug();
    if (!ok) {
      _snack('Ábrelo a mano: Ajustes → Opciones de desarrollador → '
          'Depuración inalámbrica.');
    }
  }

  /// Abre la app Shizuku directamente (sin diálogo de selección).
  Future<void> _openShizukuApp() async {
    final ok = await ShizukuService.instance.openShizukuApp();
    if (!ok) _snack('Abre Shizuku desde tu cajón de apps.');
  }

  /// Abre la info de la app Shizuku para que el usuario ponga energía → No restringido.
  Future<void> _openShizukuAppInfo() async {
    try {
      const intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:moe.shizuku.privileged.api',
      );
      await intent.launch();
    } catch (_) {
      _snack('Ajustes → Apps → Shizuku → Batería → No restringido.');
    }
  }

  /// Escanea los saves locales según plataforma y modo.
  /// - Desktop: carpeta nativa de Stardew.
  /// - Android · Shizuku: copia-puente del shell ADB.
  /// - Android · Puente: carpeta `bridge_in` que el usuario rellena con Archivos.
  Future<List<SaveFile>> _scanLocal() async {
    if (!Platform.isAndroid) return SaveService().scan();
    switch (_mode) {
      case AndroidMode.root:
        return SaveService().scanDir(gameSavesPath);
      case AndroidMode.shizuku:
        if (!_shizukuReady) return [];
        final bridge = await ShizukuService.instance.pullSaves();
        if (bridge == null) return [];
        return SaveService().scanDir(bridge);
      case AndroidMode.bridge:
        final dir = await BridgeService.instance.inDir();
        return SaveService().scanDir(dir.path);
      default:
        return [];
    }
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);

    final local = await _scanLocal();
    var drive = <DriveSaveSummary>[];
    if (widget.drive != null) {
      try {
        drive = await widget.drive!.listSaveSummaries();
      } catch (_) {}
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
      });
      SeasonController.instance.setFromSaves(entries);
    }
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen(showDisconnect: true)),
    );
    if (mounted && result == 'disconnect') {
      _disconnectDrive();
    }
  }

  Future<void> _disconnectDrive() async {
    await AuthService.instance.signOut();
    if (mounted) Navigator.pop(context, true); // true = se desconectó
  }

  // ── Acciones ────────────────────────────────────────────────────────────

  Future<void> _handleUpload(SaveEntry entry) async {
    final local = entry.local;
    if (local == null || widget.drive == null) return;
    final name = local.folderName;
    if (_busy.contains(name)) return;

    setState(() => _busy.add(name));
    try {
      await widget.drive!.uploadSave(local.folderPath, name);
      await _load(silent: true);
    } catch (e) {
      _snack('Error al subir: $e');
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  Future<void> _handleDownload(SaveEntry entry) async {
    final drive = entry.drive;
    final folderId = entry.driveFolderId;
    if (drive == null || folderId == null || widget.drive == null) return;

    final name = drive.folderName;
    final confirmed = await _confirmDownload(entry);
    if (confirmed != true) return;

    setState(() => _busy.add(name));
    try {
      if (Platform.isAndroid && _mode == AndroidMode.shizuku) {
        // Shizuku: descargar a carpeta propia → empujar al juego vía cp.
        if (!_shizukuReady) {
          _snack('Activa Shizuku para escribir el save en el juego.');
          return;
        }
        final out = await ShizukuService.instance.prepareOut(name);
        await widget.drive!.downloadSave(folderId, out);
        final ok = await ShizukuService.instance.pushSave(name);
        if (!ok) {
          _snack('No se pudo escribir en el juego. Algunos móviles bloquean '
              '/Android/data aun con Shizuku.');
          return;
        }
        await _load(silent: true);
        _snack('Partida descargada en el juego.');
      } else if (Platform.isAndroid && _mode == AndroidMode.bridge) {
        // Puente: descargar a bridge_out → el usuario la copia con Archivos.
        final out = await BridgeService.instance.prepareOut(name);
        await widget.drive!.downloadSave(folderId, out);
        if (mounted) await _showBridgeCopyDialog(name, out);
      } else {
        final savesDir = SaveService.savesDirectory;
        if (savesDir == null) {
          _snack('Esta plataforma no permite escribir el save local todavía.');
          return;
        }
        await Directory(savesDir).create(recursive: true);
        final target = '$savesDir${Platform.pathSeparator}$name';
        await widget.drive!.downloadSave(folderId, target);
        await _load(silent: true);
        _snack('Partida descargada en el juego.');
      }
    } catch (e) {
      _snack('Error al descargar: $e');
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  /// Diálogo tras descargar en modo puente: indica al usuario que copie la
  /// partida de `bridge_out` a la carpeta del juego con su app de Archivos.
  Future<void> _showBridgeCopyDialog(String name, String fromPath) {
    const dest = gameSavesPath;
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF12180F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        title: Text('Copia la partida al juego',
            style: GoogleFonts.fraunces(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'La partida está lista. Con tu app de Archivos, copia la carpeta '
              '"$name" y pégala en la carpeta de Stardew.',
              style: GoogleFonts.dmMono(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.82)),
            ),
            const SizedBox(height: 14),
            _dialogPath('Desde', fromPath),
            const SizedBox(height: 8),
            _dialogPath('Hasta', dest),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: dest));
              _snack('Ruta de destino copiada.');
            },
            child: Text('Copiar destino',
                style: GoogleFonts.dmMono(
                    color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Entendido',
                style: GoogleFonts.dmMono(
                    color: Colors.white.withValues(alpha: 0.6))),
          ),
        ],
      ),
    );
  }

  Widget _dialogPath(String label, String path) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSub),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: GoogleFonts.dmMono(
                  fontSize: 8, letterSpacing: 0.8, color: AppColors.textFaint)),
          const SizedBox(height: 2),
          Text(path,
              style:
                  GoogleFonts.dmMono(fontSize: 9.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Future<bool?> _confirmDownload(SaveEntry entry) {
    final drive = entry.drive!;
    final local = entry.local;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF12180F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        title: Text('Descargar de Drive',
            style: GoogleFonts.fraunces(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700)),
        content: Text(
          local == null
              ? 'Se copiará "${drive.farmName}" (Día ${drive.dayOfMonth}, '
                  '${drive.playtimeLabel}) a este equipo.'
              : 'Esto SOBRESCRIBE tu save local de "${drive.farmName}".\n\n'
                  'Local: Día ${local.dayOfMonth} · ${local.playtimeLabel}\n'
                  'Drive: Día ${drive.dayOfMonth} · ${drive.playtimeLabel}\n\n'
                  '¿Continuar?',
          style: GoogleFonts.dmMono(
              fontSize: 12, color: Colors.white.withValues(alpha: 0.80)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: GoogleFonts.dmMono(color: Colors.white.withValues(alpha: 0.6))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Descargar',
                style: GoogleFonts.dmMono(
                    color: const Color(0xFF5AA8E0), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: GoogleFonts.dmMono(
              fontSize: 12,
              color: Colors.white,
              height: 1.45,
            ),
          ),
          backgroundColor: const Color(0xFF241A0C),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _TopBar(
                  onBack: () => Navigator.pop(context),
                  onSettings: _openSettings,
                ),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
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
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 1.5,
        ),
      );
    }
    if (_entries.isEmpty) return _buildEmpty();

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: _entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (_, i) => Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (i == 0) _LatestBadge(color: _entries[0].primary.seasonColor),
                SaveCard(
                  entry: _entries[i],
                  busy: _busy.contains(_entries[i].folderName),
                  onUpload: () => _handleUpload(_entries[i]),
                  onDownload: () => _handleDownload(_entries[i]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _spinner() => const Center(
        child: CircularProgressIndicator(
            color: AppColors.accent, strokeWidth: 1.5),
      );

  Widget _buildEmpty() {
    // Modo puente: explicar cómo traer partidas a bridge_in con Archivos.
    if (Platform.isAndroid && _mode == AndroidMode.bridge) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text('📂', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 14),
            Text(
              'Trae tus partidas',
              style: GoogleFonts.fraunces(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Para ver y subir tus partidas locales, cópialas con tu app de '
              'Archivos desde la carpeta de Stardew a esta carpeta de ValleySave. '
              'Luego desliza para refrescar.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmMono(
                fontSize: 11.5,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(height: 18),
            _pathBox('Desde (Stardew)', gameSavesPath),
            const SizedBox(height: 8),
            _pathBox('Hasta (ValleySave)', _bridgeInPath ?? '…'),
            const SizedBox(height: 22),
            _gateButton('Refrescar', () => _load(), filled: true),
            const SizedBox(height: 10),
            _gateButton('Cambiar método', _resetMode, filled: false),
            const SizedBox(height: 16),
            _howItWorksLink(),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌾', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'No se encontraron partidas',
            style: GoogleFonts.dmMono(fontSize: 13, color: AppColors.textFaint),
          ),
          const SizedBox(height: 6),
          Text(
            SaveService.savesDirectory ??
                'En este dispositivo no se leen saves locales',
            style: GoogleFonts.dmMono(
              fontSize: 9,
              color: AppColors.textFaint.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Selector de vía: Shizuku (recomendado) / Puente manual.
  Widget _buildModeChooser() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const Text('🔌', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 14),
          Text(
            'Elige cómo conectar',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.92),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Android protege la carpeta del juego. Elige cómo darle acceso a '
            'ValleySave — puedes cambiarlo cuando quieras.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmMono(
              fontSize: 11.5,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 22),
          _modeCard(
            icon: Icons.bolt_rounded,
            accent: AppColors.accent,
            badge: 'AUTOMÁTICO · RECOMENDADO',
            title: 'Con Shizuku',
            desc: 'Se configura 1 vez. Después ValleySave sincroniza sola, sin '
                'que toques nada. Única vía fiable en Android 13+.',
            onTap: () => _chooseMode(AndroidMode.shizuku),
          ),
          if (_sdkInt < 33) ...[
            const SizedBox(height: 12),
            _modeCard(
              icon: Icons.swap_horiz_rounded,
              accent: AppColors.green,
              badge: 'SOLO ANDROID 11-12',
              title: 'Puente manual',
              desc: 'Copias la partida con tu app de Archivos. Disponible en '
                  'Android 11 y 12 porque el gestor del sistema sí puede entrar '
                  'en la carpeta del juego.',
              onTap: () => _chooseMode(AndroidMode.bridge),
            ),
          ],
          const SizedBox(height: 18),
          _howItWorksLink(),
        ],
      ),
    );
  }

  Widget _modeCard({
    required IconData icon,
    required Color accent,
    required String badge,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.30)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 21, color: accent),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(badge,
                      style: GoogleFonts.dmMono(
                        fontSize: 8.5,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                        color: accent.withValues(alpha: 0.85),
                      )),
                  const SizedBox(height: 3),
                  Text(title,
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      )),
                  const SizedBox(height: 5),
                  Text(desc,
                      style: GoogleFonts.dmMono(
                        fontSize: 11,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.72),
                      )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: accent.withValues(alpha: 0.6), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _pathBox(String label, String path) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.bgAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSub),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                    style: GoogleFonts.dmMono(
                        fontSize: 8,
                        letterSpacing: 0.8,
                        color: AppColors.textFaint)),
                const SizedBox(height: 3),
                Text(path,
                    style: GoogleFonts.dmMono(
                        fontSize: 9.5, color: AppColors.textMuted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: path));
              _snack('Ruta copiada.');
            },
            child: Icon(Icons.copy_rounded, size: 15, color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }

  Widget _howItWorksLink() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HowItWorksScreen()),
      ),
      child: Text(
        '¿Cómo funciona?',
        style: GoogleFonts.dmMono(
          fontSize: 12,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.textFaint.withValues(alpha: 0.5),
          color: AppColors.textFaint,
        ),
      ),
    );
  }
  Widget _buildShizukuGate() {
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
              const SizedBox(height: 4),
              const Center(child: Text('🔑', style: TextStyle(fontSize: 42))),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Conecta Shizuku',
                  style: GoogleFonts.fraunces(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Android 13+ bloquea la carpeta de Stardew. Shizuku abre ese '
                'acceso sin root: se configura una vez y ValleySave sincroniza '
                'sola. Tus datos no salen del teléfono.',
                style: GoogleFonts.dmMono(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              // Estado en vivo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _statusRow('Shizuku activo', running),
                    Divider(
                        height: 14,
                        color: Colors.white.withValues(alpha: 0.06)),
                    _statusRow('Permiso concedido', _shizukuGranted),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'GUÍA PASO A PASO',
                style: GoogleFonts.dmMono(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textFaint,
                ),
              ),
              const SizedBox(height: 8),
              _guideStep('1', 'Instala Shizuku',
                  'Gratis. Si Google Play te lo bloquea (móviles nuevos como el '
                  'A16), usa el APK oficial de GitHub.',
                  action: Wrap(spacing: 8, runSpacing: 8, children: [
                    _smallButton('Play Store', _openShizukuPlayStore),
                    _smallButton('APK GitHub', _openShizukuGithub),
                  ])),
              _guideStep('2', 'Activa Opciones de desarrollador',
                  'Ajustes → Información del teléfono → Información de software → '
                  'toca "Número de compilación" 7 veces.'),
              _guideStep('3', 'Activa Depuración inalámbrica',
                  'El botón te lleva ahí y la resalta. Actívala (ON). '
                  'Después toca "Emparejar dispositivo con código de vinculación" '
                  '— aparecerá un código de 6 dígitos en pantalla.',
                  action: _smallButton('Abrir y resaltar', _openWirelessDebug,
                      icon: Icons.open_in_new_rounded)),
              _guideStep('4', 'Empareja e INICIA Shizuku',
                  'Abre Shizuku → "Iniciar mediante depuración inalámbrica" → '
                  '"Emparejar con código de sincronización". '
                  'Shizuku enviará una notificación indicando que está a la espera. '
                  'Introduce el código de 6 dígitos que ves en la pantalla de '
                  'Depuración inalámbrica. Tras emparejar, pulsa INICIAR — '
                  'sin ese último toque Shizuku no queda activo.',
                  action: _smallButton('Abrir Shizuku', _openShizukuApp,
                      icon: Icons.open_in_new_rounded)),
              _guideStep('5', 'Pon la energía de Shizuku en No restringido',
                  'Abre la info de la app → Batería → No restringido. '
                  'Si no lo haces, el sistema cerrará Shizuku en segundo '
                  'plano y tendrás que volver a darle a Iniciar.',
                  action: _smallButton('Info de app Shizuku',
                      _openShizukuAppInfo, icon: Icons.open_in_new_rounded)),
              _guideStep(
                '6',
                'Concede el permiso a ValleySave',
                running
                    ? 'Shizuku está activo. Pulsa el botón para autorizar.'
                    : 'Disponible en cuanto Shizuku esté activo (paso 4).',
                action: running
                    ? _gateButton(
                        'Conceder permiso', _requestShizukuPermission,
                        filled: true)
                    : null,
              ),
              const SizedBox(height: 16),
              if (!running)
                _gateButton('Ya lo he hecho · Comprobar', _checkShizuku,
                    filled: true),
              const SizedBox(height: 10),
              _gateButton('Cambiar método', _resetMode, filled: false),
              const SizedBox(height: 16),
              Center(child: _howItWorksLink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusRow(String label, bool done) {
    return Row(
      children: [
        Icon(
          done
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 18,
          color: done ? AppColors.statusOk : AppColors.textFaint,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.dmMono(
            fontSize: 12.5,
            fontWeight: done ? FontWeight.w600 : FontWeight.w400,
            color: done
                ? Colors.white.withValues(alpha: 0.90)
                : AppColors.textFaint,
          ),
        ),
        const Spacer(),
        Text(
          done ? 'LISTO' : 'PENDIENTE',
          style: GoogleFonts.dmMono(
            fontSize: 8.5,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: done ? AppColors.statusOk : AppColors.textFaint,
          ),
        ),
      ],
    );
  }

  Widget _guideStep(String n, String title, String desc, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Text(
              n,
              style: GoogleFonts.dmMono(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    title,
                    style: GoogleFonts.dmMono(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.90),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: GoogleFonts.dmMono(
                    fontSize: 11,
                    height: 1.5,
                    color: AppColors.textFaint,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: AppColors.accent),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.dmMono(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gateButton(String label, VoidCallback onTap, {required bool filled}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.accent.withValues(alpha: 0.14) : Colors.transparent,
          border: Border.all(
              color: AppColors.accent.withValues(alpha: filled ? 0.55 : 0.28)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmMono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: filled ? AppColors.accent : AppColors.textFaint,
          ),
        ),
      ),
    );
  }
}

// ── Badge última partida ────────────────────────────────────────────────────────

class _LatestBadge extends StatelessWidget {
  const _LatestBadge({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              border: Border.all(color: color.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '· ÚLTIMA PARTIDA ·',
              style: GoogleFonts.dmMono(
                fontSize: 8,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Barra superior ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
    required this.onSettings,
  });

  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 492),
          child: Row(
            children: [
              _IconCircle(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              const Spacer(),
              Text(
                'Mis partidas',
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
              const Spacer(),
              _IconCircle(icon: Icons.settings_rounded, onTap: onSettings),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.30),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.70)),
      ),
    );
  }
}

