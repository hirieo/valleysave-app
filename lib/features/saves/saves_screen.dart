import 'dart:async';
import 'dart:io';

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
import '../../core/models/shared_sync_state.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/auto_refresh_prefs.dart';
import '../../core/services/auto_sync_prefs.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/drive_service.dart';
import '../../core/services/game_launch_service.dart';
import '../../core/services/host_swap_service.dart';
import '../../core/services/local_save_watcher.dart';
import '../../core/services/save_replace_service.dart';
import '../../core/services/save_service.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/shizuku_service.dart';
import '../../core/services/transfer_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/utils/app_page_route.dart';
import '../../shared/widgets/valley_canvas_widget.dart';
import '../../shared/widgets/pressable_scale.dart';
import '../../shared/widgets/glass_dialog.dart';
import '../help/how_it_works_screen.dart';
import '../settings/settings_screen.dart';
import 'save_card.dart';
import 'widgets/backup_action_button.dart';
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

enum _BackupDeleteChoice { local, ownDrive, sharedDrive, all }

enum _SharedSyncTarget { ownDrive, ownerDrive, both }

enum _SharedDownloadSource { ownDrive, ownerDrive }

/// spec 009 (Capa 2, D6): qué hacer, si acaso, para un destino concreto —
/// `none` cubre tanto "está sincronizado" como "el veredicto no es verde"
/// (G7): en ambos casos la Capa 2 no actúa, la card ya se actualizó por la
/// Capa 1 (refresco pasivo) y el usuario decide a mano igual que hoy.
enum _AutoSyncAction { none, upload, download }

/// Rediseño del diálogo subir/bajar (2026-07-29): clasificación del veredicto
/// que se muestra sobre el ledger de diferencias. `red` (peligro) dispara
/// además el segundo diálogo de confirmación — ver `_confirmDangerousOverwrite`.
enum _OverwriteVerdict { green, amber, gray, red }

/// Una fila del ledger: `before`→`after` ya formateados para mostrar, y si
/// `after` es peor que `before` para ese stat (colorea la píldora en rojo).
typedef _StatDiff = ({String label, String before, String after, bool worse});

/// Resultado completo de comparar el lado que se va a sobrescribir (`current`)
/// contra el que lo reemplazará (`result`). `headline` son los 4 stats que
/// siempre van en fila individual (día/año, tiempo, dinero actual, dinero
/// total); `skills` y `others` son las dos rejillas de 2 columnas (solo los
/// stats que cambiaron, sin título de grupo). `isDanger`/`verdict` deciden el
/// color del diálogo y si hace falta doble confirmación.
typedef OverwriteLedger = ({
  List<_StatDiff> headline,
  List<_StatDiff> skills,
  List<_StatDiff> others,
  List<String> identicalLabels,
  bool isDanger,
  _OverwriteVerdict verdict,
  String verdictText,
  /// Frase corta ("7 días y 3h30m") ya formateada — se reutiliza tal cual en
  /// el segundo diálogo de confirmación del caso peligro, sin recalcularla.
  String delta,
});

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
  final GlobalKey _sharedSectionKey = GlobalKey();
  bool _showSharedHeader = false;
  bool _hostSwapProgressVisible = false;

  // ── spec 007 — respaldos pre-swap: conteo LOCAL por folderName, para el
  // badge del botón "Backups" en la hoja de detalle (rápido, sin red).
  Map<String, int> _backupCounts = {};

  // Cuenta Google conectada — subtítulo bajo el título de la cabecera.
  String? _connectedEmail;

  // ── spec 009 — Capa 1: refresco pasivo (D1-D5) ──
  static const _driveChangesPageTokenKey = 'drive_changes_page_token';
  bool _autoRefreshEnabled = true; // default true (D4) hasta leer la pref
  LocalSaveWatcher? _localWatcher;
  Timer? _driveChangesTimer;

  // ── spec 009 — Capa 2: auto-sync por partida (D6-D9) ──
  Set<String> _autoSyncFolders = {};
  bool _isAutoSyncEnabled(String folderName) =>
      _autoSyncFolders.contains(folderName);
  // Timer PROPIO (2026-08-02): antes el ciclo de auto-sync solo se disparaba
  // dentro de `_pollDriveChanges`, que corta en seco si `_autoRefreshEnabled`
  // (Capa 1, interruptor global) está apagado. Eso rompía la garantía D7
  // ("independiente del refresco global") — con el refresco global apagado,
  // el chip AUTO quedaba encendido en la UI pero nunca sincronizaba nada.
  Timer? _autoSyncTimer;

  /// Arranca/para el timer de Capa 2 según haya o no partidas con AUTO
  /// encendido — nunca según `_autoRefreshEnabled`. Llamar tras cualquier
  /// cambio a `_autoSyncFolders`.
  void _syncAutoSyncTimerState() {
    if (_autoSyncFolders.isEmpty) {
      _autoSyncTimer?.cancel();
      _autoSyncTimer = null;
    } else {
      _autoSyncTimer ??= Timer.periodic(
        const Duration(seconds: 30),
        (_) => _autoSyncTick(),
      );
    }
  }

  /// Un ciclo de Capa 2: refresca el estado (mismo criterio de espera que
  /// `_pollDriveChanges`, G4) y evalúa/ejecuta el auto-sync sobre datos
  /// frescos.
  Future<void> _autoSyncTick() async {
    if (!mounted || _busy.isNotEmpty) return;
    await _load(silent: true);
    if (mounted) await _runAutoSyncCycle();
  }

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
    _loadConnectedEmail();
    _initAutoRefresh();
    _loadAutoSyncPrefs();
  }

  Future<void> _loadConnectedEmail() async {
    final email = await widget.drive?.myEmail();
    if (mounted && email != null) setState(() => _connectedEmail = email);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopAutoRefresh();
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  // ── spec 009 — Capa 1: watcher local + sondeo de Drive (T910-T916) ─────

  /// T911/T913 — arranca (o no) según la pref persistida. Independiente del
  /// resto de `_init()` (modo Android/Shizuku): el refresco pasivo no
  /// depende de qué vía de acceso local se use.
  Future<void> _initAutoRefresh() async {
    final enabled = await AutoRefreshPrefs.isEnabled();
    if (!mounted) return;
    setState(() => _autoRefreshEnabled = enabled);
    if (enabled) _startAutoRefresh();
  }

  /// T917 — carga inicial del conjunto de partidas con auto-sync activado.
  Future<void> _loadAutoSyncPrefs() async {
    final folders = await AutoSyncPrefs.loadAll();
    if (!mounted) return;
    setState(() => _autoSyncFolders = folders);
    _syncAutoSyncTimerState();
  }

  /// T918/T919 — alterna el chip `⚡ AUTO` de UNA partida (por `folderName`),
  /// nunca el interruptor global (D7 — capas independientes). Actualiza el
  /// estado en memoria al instante (chip responde sin esperar disco) y
  /// persiste en segundo plano.
  Future<void> _toggleAutoSync(String folderName) async {
    final enabled = !_isAutoSyncEnabled(folderName);
    // Cada activación en cualquier partida → explicar antes de encender nada
    // (2026-07-31, checkbox añadido 2026-08-01): el chip por sí solo no deja
    // claro que la app va a subir/bajar SIN preguntar. Si cancela, no se
    // activa. Apagar nunca pregunta (no hay riesgo en volver a manual). El
    // aviso vuelve a salir cada vez salvo que el usuario marque "no volver
    // a mostrar" (desmarcado por defecto).
    if (enabled && !await AutoSyncPrefs.explainerDismissed(folderName)) {
      if (!mounted) return;
      final result = await _explainAutoSync(folderName);
      if (result == null || !result.confirmed) return;
      if (result.dontShowAgain) {
        await AutoSyncPrefs.markExplainerDismissed(folderName);
      }
      if (!mounted) return;
    }
    setState(() {
      if (enabled) {
        _autoSyncFolders.add(folderName);
      } else {
        _autoSyncFolders.remove(folderName);
      }
    });
    _syncAutoSyncTimerState();
    await AutoSyncPrefs.setEnabled(folderName, enabled);
  }

  /// Diálogo de la PRIMERA activación de auto-sync (una sola vez en toda la
  /// app, no por partida). Reutiliza `_glassDialogShell`/`_dialogBody`, cero
  /// componentes nuevos. Mockup aprobado 2026-07-31.
  Future<({bool confirmed, bool dontShowAgain})?> _explainAutoSync(
    String folderName,
  ) {
    final l10n = AppLocalizations.of(context)!;
    const kAutoSync = Color(0xFF62B074);
    final matches = _entries.where((e) => e.folderName == folderName);
    final farmName = matches.isEmpty
        ? folderName
        : matches.first.primary.farmName;
    // Desmarcado por defecto (decisión del usuario 2026-08-01): el aviso
    // vuelve a salir cada vez que se activa AUTO salvo que el usuario marque
    // explícitamente que ya lo tiene claro.
    bool dontShowAgain = false;
    return showDialog<({bool confirmed, bool dontShowAgain})>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: _glassDialogShell(
            maxWidth: 380,
            accent: kAutoSync,
            child: _dialogBody(
              title: Text(
                l10n.autoSyncExplainTitle,
                style: GoogleFonts.bodoniModa(
                  color: AppColors.text,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.autoSyncExplainBody(farmName),
                    style: GoogleFonts.firaCode(
                      fontSize: 12,
                      height: 1.55,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoBox(
                    color: kAutoSync,
                    icon: Icons.check_rounded,
                    text: l10n.autoSyncExplainSafe,
                  ),
                  const SizedBox(height: 8),
                  _infoBox(
                    color: const Color(0xFFE0A850),
                    icon: Icons.shield_outlined,
                    text: l10n.autoSyncExplainDanger,
                  ),
                  const SizedBox(height: 8),
                  // Decisión del usuario 2026-08-01: auto-sync NO crea la copia
                  // que falta (solo mantiene sincronizadas dos que ya existen),
                  // para que borrar siga significando borrar. Se dice aquí
                  // explícitamente porque si no sorprende.
                  _infoBox(
                    color: Colors.white.withValues(alpha: 0.55),
                    icon: Icons.info_outline_rounded,
                    text: l10n.autoSyncExplainMissing,
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setDialogState(
                      () => dontShowAgain = !dontShowAgain,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: dontShowAgain
                                  ? kAutoSync
                                  : Colors.transparent,
                              border: Border.all(
                                color: dontShowAgain
                                    ? kAutoSync
                                    : Colors.white.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: AnimatedScale(
                              scale: dontShowAgain ? 1.0 : 0.6,
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeOutBack,
                              child: AnimatedOpacity(
                                opacity: dontShowAgain ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 120),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 11,
                                  color: Color(0xFF0A1E0F),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              l10n.autoSyncExplainDontShowAgain,
                              style: GoogleFonts.firaCode(
                                fontSize: 11.5,
                                color: Colors.white.withValues(alpha: 0.72),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ActionBtn(
                  label: l10n.autoSyncExplainConfirm,
                  color: kAutoSync,
                  icon: Icons.autorenew_rounded,
                  filled: true,
                  onTap: () => Navigator.pop(
                    ctx,
                    (confirmed: true, dontShowAgain: dontShowAgain),
                  ),
                ),
                ActionBtn(
                  label: l10n.cancel,
                  color: Colors.white.withValues(alpha: 0.55),
                  filled: false,
                  onTap: () => Navigator.pop(
                    ctx,
                    (confirmed: false, dontShowAgain: dontShowAgain),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startAutoRefresh() {
    _startLocalWatcher();
    _startDriveChangesTimer();
  }

  void _stopAutoRefresh() {
    _localWatcher?.stop();
    _driveChangesTimer?.cancel();
    _driveChangesTimer = null;
  }

  /// T910/T911 (D1) — solo aplica a escritorio: Android no tiene una carpeta
  /// de Saves directa (accede vía Shizuku/root, sin ruta de archivos fija
  /// que observar).
  void _startLocalWatcher() {
    final dir = SaveService.savesDirectory;
    if (dir == null) return;
    _localWatcher?.stop();
    _localWatcher = LocalSaveWatcher(
      path: dir,
      onChange: () {
        if (mounted) _load(silent: true);
      },
    )..start();
  }

  /// T913 (D2, G2) — el timer solo se crea si hay Drive conectado; el
  /// interruptor global ya se comprobó en el caller (`_startAutoRefresh`/
  /// `_setAutoRefreshEnabled`).
  void _startDriveChangesTimer() {
    _driveChangesTimer?.cancel();
    _driveChangesTimer = null;
    if (widget.drive == null) return;
    _driveChangesTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _pollDriveChanges(),
    );
  }

  /// T913 (G2, G4, G5) — un ciclo de sondeo barato vía Changes API, Capa 1
  /// (refresco pasivo). D5: si hubo CUALQUIER cambio, dispara
  /// `_load(silent: true)` sin intentar averiguar cuál archivo cambió.
  ///
  /// NO dispara el auto-sync por partida (Capa 2) — ese tiene su propio
  /// timer (`_autoSyncTimer`/`_autoSyncTick`), a propósito: esta función
  /// corta en seco si `_autoRefreshEnabled` está apagado, y Capa 2 debe
  /// seguir funcionando aunque el refresco global esté apagado (D7). Fusionar
  /// ambos ciclos en uno reintrodujo ese acoplamiento (bug 2026-08-02: con el
  /// refresco global apagado, el chip AUTO no sincronizaba nunca).
  Future<void> _pollDriveChanges() async {
    final drive = widget.drive;
    if (!_autoRefreshEnabled || drive == null) return;
    if (_busy.isNotEmpty) return; // G4 — no a mitad de una operación

    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_driveChangesPageTokenKey);
    try {
      token ??= await drive.getStartPageToken();
      final result = await drive.listChanges(token);
      await prefs.setString(_driveChangesPageTokenKey, result.newPageToken);
      if (result.changedFileIds.isNotEmpty && mounted) {
        await _load(silent: true);
      }
    } catch (_) {
      // G5 — fallo de red o token inválido/caducado: pedir uno nuevo y
      // seguir en silencio, sin snack; no es una acción crítica, se
      // reintenta en el siguiente ciclo de 30s.
      try {
        final fresh = await drive.getStartPageToken();
        await prefs.setString(_driveChangesPageTokenKey, fresh);
      } catch (_) {
        // Sin red ahora mismo tampoco — se reintenta en 30s.
      }
    }
  }

  /// El título de la cabecera representa el bloque que está entrando bajo
  /// ella. Se mide la posición real del bloque, por lo que funciona igual con
  /// una, muchas o ninguna tarjeta propia y al cambiar el tamaño de ventana.
  void _updateSharedHeaderFromScroll() {
    final context = _sharedSectionKey.currentContext;
    if (context == null) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final sharedTop = renderObject.localToGlobal(Offset.zero).dy;
    final media = MediaQuery.maybeOf(this.context);
    // El bloque ya es la sección activa cuando ha llegado justo debajo de la
    // barra superior. No depende de píxeles de scroll ni de la altura de cards.
    final headerBottom = (media?.padding.top ?? 0) + 78;
    final shouldShowSharedTitle = sharedTop <= headerBottom;
    if (shouldShowSharedTitle != _showSharedHeader && mounted) {
      setState(() => _showSharedHeader = shouldShowSharedTitle);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Submodo Shizuku: el usuario pudo activarlo fuera de la app.
      if (Platform.isAndroid && _mode == AndroidMode.shizuku && !_shizukuReady) {
        _checkShizuku();
      }
      // spec 009 (T914, D3, G3): al volver a primer plano, reanuda el timer
      // de Drive + un chequeo inmediato (cubre haber estado en segundo
      // plano más de 30s sin sondear). El watcher local no se pausa nunca
      // (D1 es instantáneo, sin coste de red).
      if (_autoRefreshEnabled && widget.drive != null) {
        _startDriveChangesTimer();
        _pollDriveChanges();
      }
      return;
    }
    // Cualquier otro estado (paused/inactive/hidden/detached) en Android/
    // iOS: pausar el timer de Drive — D3, en segundo plano no hay pantalla
    // que actualizar. Desktop no tiene "segundo plano" real en el mismo
    // sentido (ver spec.md, "Ciclo de vida") — se deja corriendo.
    if (Platform.isAndroid || Platform.isIOS) {
      _driveChangesTimer?.cancel();
      _driveChangesTimer = null;
    }
  }

  Future<void> _init() async {
    await GameLaunchService.instance.init();
    if (mounted) {
      setState(() => _gameCanLaunch = GameLaunchService.instance.canLaunch);
    }

    // Recupera temporales huérfanas de un cierre anterior (crash, corte de
    // luz) ANTES del primer escaneo — spec 001-integridad-transaccional-saves
    // FR-012. Solo aplica a escritorio: Android no tiene savesDirectory
    // directo (accede vía Shizuku/root, ver SaveService.savesDirectory).
    final sweepDir = SaveService.savesDirectory;
    if (sweepDir != null) {
      final backupsDir = await _backupsDirPath();
      await SaveReplaceService.instance.sweepOrphans(
        sweepDir,
        backupsDir: backupsDir,
      );
    }

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
      setState(() {
        _mode = AndroidMode.chooser;
        _loading = false;
      });
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
      _ => AndroidMode.shizuku,
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
    final granted = running
        ? await ShizukuService.instance.hasPermission()
        : false;
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
      'https://play.google.com/store/apps/details?id=moe.shizuku.privileged.api',
    );
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
        final isAuthError =
            e.toString().contains('invalid_grant') ||
            e.toString().contains('access credentials');
        if (isAuthError) {
          await AuthService.instance.signOut();
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            _snack(l10n.snackSessionExpired);
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            _snack(AppLocalizations.of(context)!.snackDriveError(e.toString()));
          }
        }
      }
    }

    final localByName = {for (final s in local) s.folderName: s};
    final driveByName = {for (final d in drive) d.folderName: d};
    final names = {...localByName.keys, ...driveByName.keys};

    final entries = <SaveEntry>[];
    for (final name in names) {
      final d = driveByName[name];
      entries.add(
        SaveEntry(
          local: localByName[name],
          drive: d?.save,
          driveFolderId: d?.folderId,
          driveComplete: d?.complete ?? true,
        ),
      );
    }
    entries.sort(
      (a, b) => b.primary.lastModified.compareTo(a.primary.lastModified),
    );

    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
        // Solo en cargas NO silenciosas (2026-08-02): esto cambia la `key`
        // de cada card y fuerza a Flutter a recrearlas, repitiendo la
        // animación de entrada. Un refresco silencioso (watcher local, Drive
        // Changes, o el timer de auto-sync cada 30s) debe actualizar datos
        // sin ningún parpadeo visual.
        if (!silent) _staggerVersion++;
      });
      SeasonController.instance.setFromSaves(entries);
    }

    // Las acciones esperan también a que la vista COOP recomponga sus tres
    // ubicaciones. Así el spinner no termina antes de que "Mi Drive" refleje
    // una subida o un borrado, igual que en las partidas normales.
    await Future.wait([_loadSharedSaves(local), _loadBackupCounts()]);
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
      // Auto-detección: cualquier carpeta que Drive ya marca `sharedWithMe`
      // y que coincide con algo que ya tenemos (local o nuestro propio
      // Drive) se registra sola como compartida — no hace falta pasar por
      // "Añadir" si ya jugábamos esa granja (2026-07-15, petición usuario).
      await _autoRegisterMatchingShares(local);

      final shared = await widget.drive!.listSharedSaves();
      final localByName = {for (final s in local) s.folderName: s};
      // `_entries` ya está actualizado en este punto (lo fija `_load` con
      // setState de forma síncrona antes del `unawaited` que llega aquí) —
      // reutilizamos su emparejamiento local↔Drive PROPIO sin llamada extra
      // a la API (modelo de 3 sitios, ver `SharedSaveEntry.ownDriveStats`).
      final ownByName = {for (final e in _entries) e.folderName: e};

      // Revocación REAL confirmada por la vía pasiva (racha de 24h ver
      // `DriveService.listSharedSaves`) — se deja de rastrear como
      // compartida y pasa a ser una partida normal (2026-07-15, petición
      // usuario). Los fallos transitorios (cuota, red) NUNCA llegan aquí.
      final reallyRevoked = shared.where((s) => s.revoked).toList();

      final merged = [
        for (final s in shared)
          if (!s.revoked)
            s.copyWith(
              localMatch: localByName[s.folderName],
              ownDriveStats: ownByName[s.folderName]?.drive,
              ownDriveFolderId: ownByName[s.folderName]?.driveFolderId,
              ownDriveComplete: ownByName[s.folderName]?.driveComplete ?? true,
            ),
      ];
      if (mounted) {
        setState(() {
          _sharedEntries = merged;
          _sharedLoading = false;
        });
      }
      final myEmail = reallyRevoked.isEmpty
          ? null
          : await widget.drive!.myEmail();
      for (final r in reallyRevoked) {
        await _handleConfirmedRevocation(
          folderId: r.folderId,
          ownerEmail: r.ownerEmail,
          farmName: r.folderName,
          reload: false,
          // Registro corrupto (dueño == tú mismo, ver `DriveService.
          // listSharedSaves`) — no una revocación de verdad de otra
          // persona. Mensaje distinto: "email X ha dejado de compartir
          // contigo" no tiene sentido cuando X eres tú.
          selfCleanup: myEmail != null && r.ownerEmail == myEmail,
        );
      }
    } catch (_) {
      if (mounted) setState(() => _sharedLoading = false);
    }
  }

  /// Punto único para las dos vías de revocación confirmada (2026-07-15):
  /// pasiva (racha de 24h en `listSharedSaves`) y activa (Drive responde con
  /// éxito "ya no hay permiso" al intentar sincronizar/subir un backup,
  /// `SharedAccessRevokedException` — señal inmediata, no espera la racha).
  /// En ambos casos: se deja de rastrear + aviso único con "Aceptar".
  /// [reload] se salta cuando el caller (`_loadSharedSaves`) ya va a hacer
  /// su propio `setState` justo después, para no recargar dos veces.
  Future<void> _handleConfirmedRevocation({
    required String folderId,
    required String ownerEmail,
    required String farmName,
    bool reload = true,
    bool selfCleanup = false,
  }) async {
    if (widget.drive == null) return;
    await widget.drive!.removeSharedSave(folderId);
    if (reload) await _load(silent: true);
    if (mounted) {
      await _showSharedRevokedDialog(
        ownerEmail,
        farmName,
        selfCleanup: selfCleanup,
      );
    }
  }

  /// B — coincidencia por `folderName` entre lo ya registrado en
  /// "Compartidas conmigo" y algo que Drive ya marca como compartido con
  /// nosotros: se registra sola. `folderName` incluye un ID numérico único
  /// por granja, así que una coincidencia es prácticamente inequívoca.
  /// Best-effort: cualquier fallo se ignora, la siguiente carga reintenta.
  Future<void> _autoRegisterMatchingShares(List<SaveFile> local) async {
    final drive = widget.drive;
    if (drive == null) return;
    try {
      final knownFolderNames = {
        for (final s in local) s.folderName,
        for (final e in _entries)
          if (e.drive != null) e.folderName,
      };
      if (knownFolderNames.isEmpty) return;
      final alreadyTracked = await drive.sharedFolderIds();
      final candidates = await drive.listSharedFolders();
      for (final folder in candidates) {
        final id = folder.id;
        final name = folder.name;
        if (id == null || name == null) continue;
        if (alreadyTracked.contains(id)) continue;
        if (!knownFolderNames.contains(name)) continue;
        try {
          await drive.addSharedSave(id);
        } catch (_) {}
      }
    } catch (_) {}
  }

  /// A — aviso único, centrado, que exige "Aceptar" (no un snackbar: es una
  /// pérdida de acceso, debe quedar claro que se ha visto). Mockup aprobado
  /// 2026-07-15. [selfCleanup]: el registro apuntaba a un save del que TÚ
  /// eres dueño (dato corrupto, ver `DriveService.listSharedSaves`) — texto
  /// distinto, "email X ha dejado de compartir contigo" no tiene sentido
  /// cuando X eres tú mismo.
  Future<void> _showSharedRevokedDialog(
    String ownerEmail,
    String farmName, {
    bool selfCleanup = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE0B850),
          child: _dialogBody(
            title: Text(
              selfCleanup
                  ? l10n.sharedSelfCleanupTitle
                  : l10n.sharedWithMeRevoked,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              selfCleanup
                  ? l10n.sharedSelfCleanupBody(farmName)
                  : l10n.sharedRevokedDialogBody(ownerEmail, farmName),
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            actions: [
              ActionBtn(
                label: l10n.sharedRevokedAccept,
                color: const Color(0xFFE0B850),
                filled: true,
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// US5 — botón "Añadir" de la sección: abre el selector de carpetas
  /// compartidas conmigo en Drive y, si se elige una, la valida y persiste.
  Future<void> _handleAddShared() async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null) return;
    final folderId = await showPickerScreen(context, drive: widget.drive!);
    if (folderId == null || folderId.isEmpty) return;

    try {
      await widget.drive!.addSharedSave(folderId);
      await _load(silent: true);
    } catch (e) {
      if (mounted) _snack(l10n.importErrNotASave);
    }
  }

  Future<void> _handleDownloadShared(SharedSaveEntry entry) async {
    // La carpeta compartida también es una carpeta normal de Drive para la
    // API. Reutilizar el flujo estándar conserva preview, confirmación,
    // Shizuku/root y el indicador estacional en todas las plataformas.
    await _handleDownload(entry.asEntry);
  }

  /// Único punto que sube al Drive del DUEÑO (mismo papel que
  /// `_uploadToOwnDrive` para Mi Drive, ver G9) — SIN confirmación propia:
  /// el caller decide cuándo hace falta (`_handleSyncShared` la muestra
  /// siempre; `_handleSyncBoth`, T815, ya la mostró combinada antes de
  /// llegar aquí). Conserva ÍNTEGRO el manejo de
  /// `SharedAccessRevokedException`/`SharedAccessReadOnlyException` (G2) —
  /// es la parte que NUNCA se fusiona con la subida a Mi Drive.
  Future<void> _uploadToOwnerDrive(SharedSaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null || entry.localMatch == null) return;

    setState(() => _busy.add(entry.folderName));
    try {
      await widget.drive!.uploadToSharedSave(
        entry.folderId,
        entry.localMatch!.folderPath,
        players: entry.localMatch!.players,
      );
      await _load(silent: true);
      if (mounted) _snack(l10n.exportSuccess);
    } on SharedAccessRevokedException {
      // Vía activa: Drive respondió con éxito "ya no hay permiso" — señal
      // inmediata y fiable, no hace falta esperar la racha pasiva de 24h.
      await _handleConfirmedRevocation(
        folderId: entry.folderId,
        ownerEmail: entry.ownerEmail,
        farmName: entry.folderName,
      );
    } on SharedAccessReadOnlyException {
      // El acceso SIGUE siendo válido (Drive respondió con éxito), solo
      // bajó a lector — no es una revocación, no se quita de la lista.
      await _load(silent: true);
      if (mounted) _snack(l10n.sharedAccessReadOnly(entry.ownerEmail));
    } on UploadIncompleteSaveException {
      if (mounted) _snack(l10n.snackUploadIncomplete);
    } catch (e) {
      if (mounted) _snack(l10n.exportError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(entry.folderName));
    }
  }

  /// T813 (spec 008) — pasa por el mismo ledger de diferencias que
  /// `_handleUpload` (`_confirmUploadStep`), con las etiquetas del Drive del
  /// dueño (verde menta `#42D392`, 🔗) en vez del texto plano de
  /// `_confirmSyncShared` (retirado, sin más usos). La ejecución real y su
  /// `try/catch` de excepciones de compartido viven en `_uploadToOwnerDrive`
  /// — es la única parte que NO se unifica con `_handleUpload` (spec: "seam
  /// limpio", subir al Drive del dueño puede revocar acceso o bajar a
  /// lector, subir a Mi Drive nunca).
  Future<void> _handleSyncShared(SharedSaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null || entry.localMatch == null) return;
    if (_busy.contains(entry.folderName)) return;

    final proceed = await _confirmUploadStep(
      entry.asEntry,
      remoteLabel: l10n.sharedSideOwnerDrive(entry.ownerEmail),
      remoteColor: const Color(0xFF42D392),
      remoteIcon: '🔗',
      actionLabel: l10n.overwriteUploadToOwner(entry.ownerEmail),
    );
    if (!proceed) return;
    await _uploadToOwnerDrive(entry);
  }

  /// T814 (spec 008) — deja de llamar `drive.uploadSave`/`uploadToSharedSave`
  /// por su cuenta (duplicaba la subida a Mi Drive, ver G9): enruta cada
  /// destino por su único punto de subida (`_handleUpload` /
  /// `_handleSyncShared` / `_handleSyncBoth`), cada uno con su propio ledger
  /// de confirmación. T818: con un solo destino válido va DIRECTO a ese
  /// ledger, sin el selector intermedio — el selector solo aparece cuando
  /// de verdad hay que elegir entre dos.
  Future<void> _handleSharedSyncRequested(SharedSaveEntry entry) async {
    final drive = widget.drive;
    final local = entry.localMatch;
    if (drive == null || local == null || _busy.contains(entry.folderName)) {
      return;
    }

    final state = SharedSyncState.fromEntry(entry);
    final canOwn = state.uploadTargets.contains(SharedCloudLocation.ownDrive);
    final canOwner = state.uploadTargets.contains(
      SharedCloudLocation.ownerDrive,
    );
    if (!canOwn && !canOwner) return;

    if (canOwn && !canOwner) {
      await _handleUpload(entry.asOwnEntry);
      return;
    }
    if (canOwner && !canOwn) {
      await _handleSyncShared(entry);
      return;
    }

    final target = await _chooseSharedSyncTarget(
      entry,
      canOwn: canOwn,
      canOwner: canOwner,
    );
    if (target == null || !mounted) return;
    switch (target) {
      case _SharedSyncTarget.ownDrive:
        await _handleUpload(entry.asOwnEntry);
      case _SharedSyncTarget.ownerDrive:
        await _handleSyncShared(entry);
      case _SharedSyncTarget.both:
        await _handleSyncBoth(entry);
    }
  }

  /// T815 (spec 008, D3) — sustituye la secuencia anterior de `onSyncBoth`
  /// (`_handleUpload` + `_handleSyncShared` encadenados, cada uno con su
  /// propia confirmación por separado). Una única confirmación combinada
  /// (`_confirmUploadToBoth`, dos ledgers independientes, un solo veredicto
  /// de peligro); si se cancela, no se ejecuta ninguna subida (G6) — las dos
  /// llamadas reales solo ocurren después de confirmar, cada una por su
  /// único punto de subida (`_uploadToOwnDrive`/`_uploadToOwnerDrive`, G9),
  /// conservando el manejo de excepciones de compartido de la segunda (G2).
  Future<void> _handleSyncBoth(SharedSaveEntry entry) async {
    if (widget.drive == null || entry.localMatch == null) return;
    if (_busy.contains(entry.folderName)) return;

    final proceed = await _confirmUploadToBoth(entry);
    if (!proceed) return;

    await _uploadToOwnDrive(entry.asOwnEntry);
    if (mounted) await _uploadToOwnerDrive(entry);
  }

  Future<void> _handleSharedDownloadRequested(SharedSaveEntry entry) async {
    final state = SharedSyncState.fromEntry(entry);
    final canOwn = state.downloadSources.contains(SharedCloudLocation.ownDrive);
    final canOwner = state.downloadSources.contains(
      SharedCloudLocation.ownerDrive,
    );
    if (!canOwn && !canOwner) return;

    final _SharedDownloadSource? source;
    if (canOwn && canOwner) {
      source = await _chooseSharedDownloadSource(entry);
    } else {
      source = canOwn
          ? _SharedDownloadSource.ownDrive
          : _SharedDownloadSource.ownerDrive;
    }
    if (source == null || !mounted) return;

    if (source == _SharedDownloadSource.ownDrive) {
      await _handleDownload(entry.asOwnEntry);
    } else {
      await _handleDownloadShared(entry);
    }
  }

  Future<void> _handleRemoveShared(SharedSaveEntry entry) async {
    if (widget.drive == null) return;
    final confirmed = await _confirmRemoveShared(entry.ownerEmail);
    if (confirmed != true) return;
    await widget.drive!.removeSharedSave(entry.folderId);
    await _load(silent: true);
  }

  /// "Salir del compartido" — a diferencia de `_handleRemoveShared`, esto
  /// SÍ revoca tu acceso de verdad en Drive (`leaveSharedSave`, permiso
  /// `'me'`). Irreversible sin que el dueño vuelva a compartir contigo.
  Future<void> _handleLeaveShared(SharedSaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.drive == null) return;
    final confirmed = await _confirmLeaveShared(entry.ownerEmail);
    if (confirmed != true) return;
    try {
      await widget.drive!.leaveSharedSave(entry.folderId);
      await widget.drive!.removeSharedSave(entry.folderId);
      if (mounted) _snack(l10n.sharedLeaveSuccess(entry.ownerEmail));
      await _load(silent: true);
    } catch (e) {
      if (mounted) _snack(l10n.exportError(e.toString()));
    }
  }

  Future<T?> _showSharedChoice<T>({
    required Color accent,
    required String title,
    required String body,
    required List<({String label, IconData icon, Color color, T value})>
    choices,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.cancel,
      barrierColor: Colors.black.withValues(alpha: 0.54),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, _, _) => Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _glassDialogShell(
                accent: accent,
                child: _dialogBody(
                  title: Text(
                    title,
                    style: GoogleFonts.bodoniModa(
                      color: AppColors.text,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        body,
                        style: GoogleFonts.firaCode(
                          fontSize: 11.5,
                          height: 1.5,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (var i = 0; i < choices.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        ActionBtn(
                          key: ValueKey('shared-choice-$i'),
                          label: choices[i].label,
                          icon: choices[i].icon,
                          color: choices[i].color,
                          filled: true,
                          onTap: () =>
                              Navigator.pop(dialogContext, choices[i].value),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    ActionBtn(
                      label: l10n.cancel,
                      color: Colors.white.withValues(alpha: 0.55),
                      filled: false,
                      onTap: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (dialogContext, animation, _, child) {
        final reduceMotion =
            MediaQuery.maybeOf(dialogContext)?.disableAnimations ?? false;
        return FadeTransition(
          opacity: animation,
          child: AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (_, animatedChild) {
              if (reduceMotion) return animatedChild!;
              final value = Curves.easeOutCubic.transform(animation.value);
              return Transform.translate(
                offset: Offset(0, (1 - value) * 3),
                child: Transform.scale(
                  scale: 0.96 + (0.04 * value),
                  alignment: Alignment.center,
                  child: animatedChild,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<_SharedSyncTarget?> _chooseSharedSyncTarget(
    SharedSaveEntry entry, {
    required bool canOwn,
    required bool canOwner,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return _showSharedChoice<_SharedSyncTarget>(
      accent: const Color(0xFFE0B850),
      title: l10n.sharedSyncChooseTitle,
      body: l10n.sharedSyncChooseBody,
      choices: [
        if (canOwn)
          (
            label: l10n.sharedSyncTargetOwn,
            icon: Icons.cloud_outlined,
            color: const Color(0xFF5AA8E0),
            value: _SharedSyncTarget.ownDrive,
          ),
        if (canOwner)
          (
            label: l10n.sharedSyncTargetOwner(entry.ownerEmail),
            icon: Icons.link_rounded,
            color: const Color(0xFF42D392),
            value: _SharedSyncTarget.ownerDrive,
          ),
        if (canOwn && canOwner)
          (
            label: l10n.sharedSyncTargetBoth,
            icon: Icons.cloud_sync_outlined,
            color: const Color(0xFF62B074),
            value: _SharedSyncTarget.both,
          ),
      ],
    );
  }

  Future<_SharedDownloadSource?> _chooseSharedDownloadSource(
    SharedSaveEntry entry,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return _showSharedChoice<_SharedDownloadSource>(
      accent: const Color(0xFF5AA8E0),
      title: l10n.sharedDownloadChooseTitle,
      body: l10n.sharedDownloadChooseBody,
      choices: [
        (
          label: l10n.sharedDownloadSourceOwn,
          icon: Icons.cloud_download_outlined,
          color: const Color(0xFF5AA8E0),
          value: _SharedDownloadSource.ownDrive,
        ),
        (
          label: l10n.sharedDownloadSourceOwner(entry.ownerEmail),
          icon: Icons.link_rounded,
          color: const Color(0xFF42D392),
          value: _SharedDownloadSource.ownerDrive,
        ),
      ],
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
          accent: const Color(0xFFE0B850),
          child: _dialogBody(
            title: Text(
              l10n.sharedWithMeRemove,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.sharedWithMeRemoveConfirm(ownerEmail),
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            actions: [
              ActionBtn(
                label: l10n.sharedWithMeRemove,
                color: const Color(0xFFE0B850),
                icon: Icons.close_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "Salir del compartido" — misma estructura que `_confirmRemoveShared`
  /// pero en rojo (acción con más consecuencia: revoca el acceso real).
  Future<bool?> _confirmLeaveShared(String ownerEmail) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE05252),
          child: _dialogBody(
            title: Text(
              l10n.sharedLeaveButton,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.sharedLeaveConfirm(ownerEmail),
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            actions: [
              ActionBtn(
                label: l10n.sharedLeaveButton,
                color: const Color(0xFFE05252),
                icon: Icons.link_off_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Diálogo "Administrar" (junto a "+ Añadir save compartido") — lista
  /// TODAS las compartidas con sus dos acciones, separado de las tarjetas
  /// para que ningún desliz al tocar una tarjeta dispare "Salir del
  /// compartido" por accidente.
  Future<void> _showManageSharedDialog() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE07040),
          child: _dialogBody(
            title: Text(
              l10n.sharedManageDialogTitle,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sharedManageDialogHint,
                  style: GoogleFonts.firaCode(
                    fontSize: 10.5,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                for (final e in _sharedEntries) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.folderName,
                          style: GoogleFonts.firaCode(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.sharedWithMeOwnedBy(e.ownerEmail),
                          style: GoogleFonts.firaCode(
                            fontSize: 10,
                            color: const Color(0xFFE07040),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ActionBtn(
                                label: l10n.sharedWithMeRemove,
                                color: const Color(0xFFE0B850),
                                filled: false,
                                onTap: () async {
                                  Navigator.pop(ctx);
                                  await _handleRemoveShared(e);
                                },
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: ActionBtn(
                                label: l10n.sharedLeaveButton,
                                color: const Color(0xFFE05252),
                                filled: false,
                                onTap: () async {
                                  Navigator.pop(ctx);
                                  await _handleLeaveShared(e);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
    );
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<String?>(
      context,
      AppPageRoute(
        builder: (_) =>
            SettingsScreen(showDisconnect: true, drive: widget.drive),
      ),
    );
    if (!mounted) return;
    if (result == 'disconnect') {
      _disconnectDrive();
    } else if (result == 'change_mode') {
      _showChangeModeDialog();
    } else {
      await GameLaunchService.instance.init();
      if (mounted) {
        setState(() => _gameCanLaunch = GameLaunchService.instance.canLaunch);
      }
    }
    // T916 (D4, G6): el interruptor de auto-actualizar pudo cambiar en
    // Ajustes — releer y aplicar en caliente (arranca o para watcher+timer),
    // sin reiniciar la app.
    await _syncAutoRefreshFromPrefs();
  }

  Future<void> _syncAutoRefreshFromPrefs() async {
    final enabled = await AutoRefreshPrefs.isEnabled();
    if (!mounted || enabled == _autoRefreshEnabled) return;
    setState(() => _autoRefreshEnabled = enabled);
    if (enabled) {
      _startAutoRefresh();
    } else {
      _stopAutoRefresh();
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
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: accent,
          child: _dialogBody(
            title: Text(
              l10n.bridgeChangeMode,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _changeModeOption(
                  ctx,
                  l10n.chooserRootBadge,
                  l10n.chooserRootTitle,
                  AndroidMode.root,
                  accent,
                ),
                const SizedBox(height: 8),
                _changeModeOption(
                  ctx,
                  l10n.hiwShizukuBadge,
                  l10n.hiwShizukuTitle,
                  AndroidMode.shizuku,
                  accent,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeModeOption(
    BuildContext ctx,
    String badge,
    String title,
    AndroidMode mode,
    Color accent,
  ) {
    final isActive = _mode == mode;
    return PressableScale(
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
                  Text(
                    badge,
                    style: GoogleFonts.firaCode(
                      fontSize: 8.5,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: isActive ? accent : AppColors.textFaint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: GoogleFonts.firaCode(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? accent : AppColors.text,
                    ),
                  ),
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

  /// T812 (spec 008) — paso de confirmación de subida compartido entre Mi
  /// Drive y el Drive del dueño: SOLO decide si procede subir (o si no hace
  /// falta confirmar porque es copia nueva, `entry.drive == null`). La
  /// llamada real a Drive (`uploadSave` vs `uploadToSharedSave`) y su
  /// `try/catch` de excepciones de compartido (G2) siguen en cada handler —
  /// nunca aquí. "Seam limpio": se unifica la confirmación, NO los handlers
  /// (ver spec.md → "Diseño técnico").
  Future<bool> _confirmUploadStep(
    SaveEntry entry, {
    String? remoteLabel,
    Color? remoteColor,
    String? remoteIcon,
    String? actionLabel,
  }) async {
    if (entry.drive == null) return true;
    final confirmed = await _confirmUpload(
      entry,
      remoteLabel: remoteLabel,
      remoteColor: remoteColor,
      remoteIcon: remoteIcon,
      actionLabel: actionLabel,
    );
    return confirmed == true;
  }

  /// Único punto que sube a Mi Drive (G9: antes había dos —
  /// `_handleSharedSyncRequested` llamaba `drive.uploadSave` por su cuenta,
  /// ver T814). SIN confirmación propia: el caller decide cuándo hace falta
  /// (`_handleUpload` la muestra siempre; `_handleSyncBoth`, T815, ya la
  /// mostró combinada antes de llegar aquí).
  Future<void> _uploadToOwnDrive(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final local = entry.local;
    if (local == null || widget.drive == null) return;
    final name = local.folderName;

    setState(() => _busy.add(name));
    try {
      await widget.drive!.uploadSave(
        local.folderPath,
        name,
        players: local.players,
      );
      await _load(silent: true);
    } on UploadIncompleteSaveException {
      if (mounted) _snack(l10n.snackUploadIncomplete);
    } catch (e) {
      if (mounted) _snack(l10n.snackUploadError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  Future<void> _handleUpload(SaveEntry entry) async {
    final local = entry.local;
    if (local == null || widget.drive == null) return;
    final name = local.folderName;
    if (_busy.contains(name)) return;

    // Sobrescribe una versión ya existente en Drive → preview + confirmar.
    if (!await _confirmUploadStep(entry)) return;
    await _uploadToOwnDrive(entry);
  }

  Future<void> _handleDownload(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final drive = entry.drive;
    final folderId = entry.driveFolderId;
    if (drive == null || folderId == null || widget.drive == null) return;

    // FR-015: nunca se ofrece descargar un save al que le falta contenido en
    // Drive — evita bajar algo a medias. El aviso llega como snack (mismo
    // patrón que el resto de errores), no como diálogo de confirmación.
    if (!entry.driveComplete) {
      _snack(l10n.snackDownloadIncomplete);
      return;
    }

    final confirmed = await _confirmDownload(entry);
    if (confirmed != true) return;
    await _downloadNow(entry);
  }

  /// Ejecuta la descarga real, SIN confirmación — mismo papel que
  /// `_uploadToOwnDrive` para subidas (G9): único punto de escritura local
  /// para AMBAS direcciones de descarga (Mi Drive propia y, vía
  /// `_handleDownloadShared`, el Drive del dueño). Lo llama `_handleDownload`
  /// tras confirmar, y el auto-sync (T920, spec 009) cuando el ledger ya dio
  /// `verdict == green`, saltándose `_confirmDownload` a propósito — el paso
  /// de confirmación es precisamente lo que la Capa 2 se salta cuando es
  /// seguro (D6).
  Future<void> _downloadNow(SaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final drive = entry.drive;
    final folderId = entry.driveFolderId;
    if (drive == null || folderId == null || widget.drive == null) return;

    final name = drive.folderName;
    setState(() => _busy.add(name));
    try {
      if (Platform.isAndroid && _mode == AndroidMode.root) {
        final out = await ShizukuService.instance.prepareOut(name);
        await widget.drive!.downloadSaveToDir(folderId, name, Directory(out));
        if (!await _isValidStagedSave(out, name)) {
          if (mounted) _snack(l10n.snackReplaceValidationFailed);
          return;
        }
        final ok = await ShizukuService.instance.pushSaveAsRoot(out, name);
        if (!ok) {
          if (mounted) _snack(l10n.snackWriteError);
          return;
        }
        await _load(silent: true);
        if (mounted) _snack(l10n.snackDownloaded);
      } else if (Platform.isAndroid && _mode == AndroidMode.shizuku) {
        // Shizuku: descargar a carpeta propia → validar → empujar al juego vía cp.
        if (!_shizukuReady) {
          if (mounted) _snack(l10n.activateShizuku);
          return;
        }
        final out = await ShizukuService.instance.prepareOut(name);
        await widget.drive!.downloadSaveToDir(folderId, name, Directory(out));
        if (!await _isValidStagedSave(out, name)) {
          if (mounted) _snack(l10n.snackReplaceValidationFailed);
          return;
        }
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
        final backupsDir = await _backupsDirPath();
        final result = await SaveReplaceService.instance.replaceSaveFolder(
          savesDir: savesDir,
          folderName: name,
          backupsDir: backupsDir,
          prepare: (stagingDir) =>
              widget.drive!.downloadSaveToDir(folderId, name, stagingDir),
        );
        if (!result.ok) {
          if (mounted) _snack(_replaceErrorMessage(result.error));
          return;
        }
        await _load(silent: true);
        if (mounted) _snack(l10n.snackDownloaded);
      }
    } catch (e) {
      if (mounted) _snack(l10n.snackDownloadError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy.remove(name));
    }
  }

  /// Desde una cara concreta confirma solo esa ubicación; desde la papelera
  /// compacta permite escoger local, Drive propio o ambas.
  Future<void> _handleDelete(SaveEntry entry, {_DeleteChoice? location}) async {
    final l10n = AppLocalizations.of(context)!;
    final hasLocal = entry.local != null;
    final hasDrive = entry.driveFolderId != null && widget.drive != null;
    if (!hasLocal && !hasDrive) return;

    final farmName = entry.primary.farmName;
    final name = entry.folderName;
    if (_busy.contains(name)) return;

    final choice = await _confirmUnifiedDelete(
      entry,
      requestedLocation: location,
      backupCount: _backupCounts[name] ?? 0,
    );
    if (choice == null) return;

    setState(() => _busy.add(name));
    try {
      if (choice == _DeleteChoice.localOnly || choice == _DeleteChoice.both) {
        if (Platform.isAndroid && _mode == AndroidMode.root) {
          final ok = await ShizukuService.instance.deleteLocalAsRoot(name);
          if (!ok && mounted) _snack(l10n.snackDeleteError('su rm failed'));
        } else if (Platform.isAndroid && _mode == AndroidMode.shizuku) {
          // `entry.local.folderPath` es la copia puente en este modo, NUNCA
          // la carpeta real del juego — borrarla ahí no borraría nada de
          // verdad (ver doc de deleteLocalViaShizuku).
          final ok = await ShizukuService.instance.deleteLocalViaShizuku(name);
          if (!ok && mounted) _snack(l10n.snackDeleteError('shizuku rm failed'));
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

  /// Hace visible que el cambio de anfitrión está trabajando sobre una copia
  /// temporal, creando el respaldo y validando el resultado antes de tocar
  /// la partida real. No se puede cerrar a mitad de operación.
  void _showHostSwapProgress() {
    if (!mounted || _hostSwapProgressVisible) return;
    _hostSwapProgressVisible = true;
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 36),
          child: _glassDialogShell(
            maxWidth: 330,
            accent: const Color(0xFFE9C44B),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _seasonalLoader(),
                  const SizedBox(height: 18),
                  Text(
                    'Cambiando anfitrión…',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaCode(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guardando un respaldo y verificando la partida.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaCode(
                      fontSize: 10,
                      height: 1.45,
                      color: Colors.white.withValues(alpha: .55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() => _hostSwapProgressVisible = false);
  }

  /// Cierra exclusivamente el diálogo creado por [_showHostSwapProgress].
  /// Todas las salidas del swap pasan por `finally`, también error y retorno
  /// temprano, para no dejar la interfaz bloqueada.
  void _dismissHostSwapProgress() {
    if (!mounted || !_hostSwapProgressVisible) return;
    Navigator.of(context, rootNavigator: true).pop();
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
        await SharePlus.instance.share(ShareParams(files: [XFile(zip.path)]));
      } else {
        await FilePicker.platform.saveFile(
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
    final picked = await FilePicker.platform.pickFiles(
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
        backupsDir: await _backupsDirPath(),
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
    final stagingDir = await Directory.systemTemp.createTemp(
      'vs_import_stage_',
    );
    try {
      final result = await TransferService().importSave(
        zipPath,
        savesDir: stagingDir.path,
        backupsDir: await _backupsDirPath(),
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
      await Directory(
        '${stagingDir.path}${Platform.pathSeparator}$folderName',
      ).rename(out);

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
      ImportError.backupFailed => l10n.importErrBackupFailed,
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
        await widget.drive!.updatePermission(
          folderId,
          current.id as String,
          role,
        );
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
              title: Text(
                l10n.shareDialogTitle,
                style: GoogleFonts.bodoniModa(
                  color: AppColors.text,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmName,
                    style: GoogleFonts.firaCode(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: GoogleFonts.firaCode(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.shareEmailPlaceholder,
                      hintStyle: GoogleFonts.firaCode(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: const Color(
                            0xFFE0B850,
                          ).withValues(alpha: 0.55),
                        ),
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
                  PressableScale(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showManageAccess(entry);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0B850).withValues(alpha: 0.10),
                        border: Border.all(
                          color: const Color(
                            0xFFE0B850,
                          ).withValues(alpha: 0.35),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people_alt_outlined,
                            size: 13,
                            color: Color(0xFFE0B850),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.manageAccessTitle,
                            style: GoogleFonts.firaCode(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE0B850),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ActionBtn(
                  label: l10n.shareConfirmButton,
                  color: const Color(0xFFE0B850),
                  icon: Icons.person_add_alt_1_rounded,
                  filled: true,
                  onTap: () =>
                      Navigator.pop(ctx, (controller.text.trim(), role)),
                ),
                ActionBtn(
                  label: l10n.cancel,
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

  Widget _shareRoleOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const accent = Color(0xFFE0B850);
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: selected ? 0.16 : 0.0),
          border: Border.all(
            color: accent.withValues(alpha: selected ? 0.55 : 0.20),
          ),
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
              title: Text(
                l10n.manageAccessTitle,
                style: GoogleFonts.bodoniModa(
                  color: AppColors.text,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (permissions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        l10n.manageAccessEmpty,
                        style: GoogleFonts.firaCode(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
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
                                color: const Color(
                                  0xFFE0B850,
                                ).withValues(alpha: 0.16),
                              ),
                              child: Text(
                                (p.emailAddress as String? ?? '?')
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: GoogleFonts.firaCode(
                                  fontSize: 11,
                                  color: const Color(0xFFE0B850),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.emailAddress as String? ?? '',
                                style: GoogleFonts.firaCode(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
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
                                      folderId,
                                      p.id as String,
                                      'reader',
                                    );
                                    setState(() => p.role = 'reader');
                                  } catch (e) {
                                    if (mounted) {
                                      _snack(l10n.exportError(e.toString()));
                                    }
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
                                      folderId,
                                      p.id as String,
                                      'writer',
                                    );
                                    setState(() => p.role = 'writer');
                                  } catch (e) {
                                    if (mounted) {
                                      _snack(l10n.exportError(e.toString()));
                                    }
                                  }
                                },
                              ),
                            ],
                            Tooltip(
                              message: l10n.manageAccessRevoke,
                              child: PressableScale(
                                semanticLabel: l10n.manageAccessRevoke,
                                onTap: () async {
                                  try {
                                    await widget.drive!.unshareSave(
                                      folderId,
                                      p.id as String,
                                    );
                                    setState(() => permissions.remove(p));
                                  } catch (e) {
                                    if (mounted) {
                                      _snack(l10n.exportError(e.toString()));
                                    }
                                  }
                                },
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: Color(0xFFE05252),
                                  ),
                                ),
                              ),
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
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: selected ? 0.16 : 0.0),
          border: Border.all(
            color: accent.withValues(alpha: selected ? 0.5 : 0.18),
          ),
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
  /// F3 v2 (2026-07-15): Windows siempre; Android solo en root/Shizuku, los
  /// únicos modos con una copia local sobre la que se puede escribir de
  /// verdad (el modo Puente no da esa garantía). Punto único — reutilizado
  /// en los dos gates de la UI (lista principal y tarjeta compartida).
  bool get _hostSwapAvailable =>
      Platform.isWindows ||
      (Platform.isAndroid &&
          (_mode == AndroidMode.root || _mode == AndroidMode.shizuku));

  /// F3 v2 (2026-07-15) — Android root/Shizuku: [entry.local.folderPath] YA
  /// es la copia puente legible (`pullSaves`/`pullSavesAsRoot`), así que
  /// `analyze` (solo lectura) corre directo sobre ella. `execute` en cambio
  /// SÍ escribe — se hace sobre una copia de trabajo aparte
  /// (`prepareOut`) y solo se empuja al juego si termina con éxito, para
  /// que un fallo a mitad de camino nunca deje la copia que lee la app a
  /// medio reorganizar.
  Future<void> _handleMakeHost(SaveEntry entry, PlayerStats target) async {
    final l10n = AppLocalizations.of(context)!;
    final local = entry.local;
    if (local == null) return;
    final name = entry.folderName;
    if (_busy.contains(name)) return;

    final androidBridge =
        Platform.isAndroid &&
        (_mode == AndroidMode.root || _mode == AndroidMode.shizuku);
    if (androidBridge && _mode == AndroidMode.shizuku && !_shizukuReady) {
      if (mounted) await _showHostSwapErrorDialog(l10n.activateShizuku);
      return;
    }

    final service = HostSwapService();
    final analysis = await service.analyze(
      saveFolderPath: local.folderPath,
      targetUniqueId: target.uniqueId,
    );
    if (!analysis.ok) {
      if (mounted) {
        await _showHostSwapErrorDialog(_hostSwapErrorMessage(analysis.error));
      }
      return;
    }

    final confirmed = await _confirmMakeHost(
      targetName: analysis.targetName,
      farmName: local.farmName,
      itemsToRelocate: analysis.itemsToRelocate,
    );
    if (confirmed != true) return;

    setState(() => _busy.add(name));
    _showHostSwapProgress();
    String? backupZipPath;
    String? failureMessage;
    try {
      final backupsDir = await _backupsDirPath();
      final workingPath = androidBridge
          ? await ShizukuService.instance.prepareOut(name)
          : local.folderPath;
      if (androidBridge) {
        await copyDirectory(
          Directory(local.folderPath),
          Directory(workingPath),
        );
      }
      final result = await service.execute(
        saveFolderPath: workingPath,
        targetUniqueId: target.uniqueId,
        backupsDir: backupsDir,
      );
      if (!result.ok) {
        failureMessage = _hostSwapErrorMessage(result.error);
      } else {
        var published = true;
        if (androidBridge) {
          published = _mode == AndroidMode.root
              ? await ShizukuService.instance.pushSaveAsRoot(workingPath, name)
              : await ShizukuService.instance.pushSave(name);
          if (!published) {
            failureMessage = l10n.snackWriteError;
          }
        }
        if (published) {
          await _load(silent: true);
          if (mounted) _snack(l10n.makeHostSuccess(target.name));
          backupZipPath = result.backupZipPath;
        }
      }
    } catch (e) {
      failureMessage = l10n.snackDeleteError(e.toString());
    } finally {
      _dismissHostSwapProgress();
      if (mounted) setState(() => _busy.remove(name));
    }

    // Los errores del swap pueden implicar que la operación fue descartada
    // o que no existe una colocación segura. No deben desaparecer solos como
    // un snackbar: el usuario confirma que ha leído el resultado.
    if (mounted && failureMessage != null) {
      await _showHostSwapErrorDialog(failureMessage);
      return;
    }

    // El diálogo de progreso ya se cerró antes de preguntar qué hacer con el
    // respaldo: de otra forma su barrera impediría interactuar con esta hoja.
    if (mounted && backupZipPath != null) {
      await _handleSwapBackupChoice(backupZipPath);
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

  Future<void> _showHostSwapErrorDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          maxWidth: 420,
          accent: AppColors.statusErr,
          child: _dialogBody(
            title: Text(
              l10n.makeHostDialogTitle,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: _infoBox(
              color: AppColors.statusErr,
              icon: Icons.error_outline_rounded,
              text: message,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.sharedRevokedAccept,
                  color: AppColors.statusErr,
                  icon: Icons.check_rounded,
                  filled: true,
                  onTap: () => Navigator.pop(ctx),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mensaje para cualquier fallo de `SaveReplaceService.replaceSaveFolder`
  /// (descarga, importación o restauración de backup) — spec
  /// 001-integridad-transaccional-saves FR-013: distingue red/contenido
  /// inválido/respaldo/rollback, siempre dejando claro que el destino no se
  /// perdió (salvo [ReplaceError.busy], que ni siquiera llegó a intentarlo).
  String _replaceErrorMessage(ReplaceError? error) {
    final l10n = AppLocalizations.of(context)!;
    switch (error) {
      case ReplaceError.prepareFailed:
        return l10n.snackReplacePrepareFailed;
      case ReplaceError.validationFailed:
        return l10n.snackReplaceValidationFailed;
      case ReplaceError.backupFailed:
        return l10n.snackReplaceBackupFailed;
      case ReplaceError.swapFailed:
      // Mismo desenlace de cara al usuario: el original se restauró desde el
      // rollback, no se perdió nada.
      case ReplaceError.postValidationFailed:
        return l10n.snackReplaceSwapFailed;
      case ReplaceError.busy:
      case null:
        return l10n.snackReplaceBusy;
    }
  }

  /// Valida el contenido descargado a la copia puente de Android ANTES de
  /// empujarlo al juego (`pushSave`/`pushSaveAsRoot`) — spec
  /// 001-integridad-transaccional-saves T008. El push nativo (`cp -rfp`) no
  /// es transaccional (fuera de alcance de esta spec, ver Assumptions), pero
  /// al menos nunca empuja un save a medias o corrupto.
  Future<bool> _isValidStagedSave(String dir, String folderName) async {
    final sep = Platform.pathSeparator;
    final info = File('$dir${sep}SaveGameInfo');
    final main = File('$dir$sep$folderName');
    if (!await info.exists() || !await main.exists()) return false;
    final parsed = SaveService.parseSaveGameInfo(
      await info.readAsString(),
      folderName: folderName,
      lastModified: DateTime.now(),
    );
    return parsed != null;
  }

  /// Tarjeta translúcida compartida por todos los diálogos de confirmación:
  /// ancho acotado (evita la "barra rectangular" a lo ancho de la ventana),
  /// fondo mezclado con blur sutil detrás (sensación de profundidad, nunca
  /// negro plano) y esquinas más suaves que un `AlertDialog` por defecto.
  /// Delegan al widget compartido `lib/shared/widgets/glass_dialog.dart`
  /// (2026-07-15 — antes vivían solo aquí duplicados; ahora Settings y el
  /// diálogo de idioma también los usan, una sola fuente de verdad).
  Widget _glassDialogShell({
    required Widget child,
    double maxWidth = 380,
    Color? accent,
  }) => glassDialogShell(
    context,
    maxWidth: maxWidth,
    accent: accent ?? _seasonAccent,
    child: child,
  );

  Widget _dialogBody({
    required Widget title,
    required Widget content,
    required List<Widget> actions,
  }) => dialogBody(title: title, content: content, actions: actions);

  /// Aviso inline: tinte muy sutil, sin borde — más compacto y translúcido
  /// que un `Container` con borde sólido (opción B aprobada, 2026-07-11).
  Widget _infoBox({
    required Color color,
    required IconData icon,
    required String text,
  }) {
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
                fontSize: 10,
                height: 1.5,
                color: color.withValues(alpha: 0.85),
              ),
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
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.makeHostDialogIntro(targetName, farmName),
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.80),
                  ),
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
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.swapBackupDialogBody,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.80),
              ),
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
  Future<void> _handleOpenBackups(
    SaveEntry entry, {
    String? sharedFolderId,
    bool canEditShared = false,
    String? sharedOwnerEmail,
  }) async {
    final source = entry.local ?? entry.drive;
    if (source == null) return;

    final backupsDir = await _backupsDirPath();
    final localBackups = await BackupService().listLocalBackups(
      backupsDir,
      folderName: source.folderName,
    );

    var driveBackups = <BackupEntry>[];
    var sharedBackups = <BackupEntry>[];
    if (widget.drive != null) {
      try {
        driveBackups = await widget.drive!.listDriveBackups(
          folderName: source.folderName,
        );
      } catch (_) {
        // sin red o sin permiso: se sigue mostrando lo local
      }
      if (sharedFolderId != null) {
        try {
          sharedBackups = await widget.drive!.listSharedSaveBackups(
            sharedFolderId,
            folderName: source.folderName,
          );
        } catch (_) {
          // El propietario pudo revocar el acceso; el resto sigue disponible.
        }
      }
    }

    final merged = <String, BackupEntry>{};
    for (final b in localBackups) {
      merged[b.fileName] = b;
    }
    for (final b in driveBackups) {
      final existing = merged[b.fileName];
      merged[b.fileName] = existing?.mergeWith(b) ?? b;
    }
    for (final b in sharedBackups) {
      final existing = merged[b.fileName];
      merged[b.fileName] = existing?.mergeWith(b) ?? b;
    }
    final list = merged.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (!mounted) return;
    await _showBackupsDialog(
      source.farmName,
      list,
      backupsDir: backupsDir,
      localSave: entry.local,
      sharedFolderId: sharedFolderId,
      canEditShared: canEditShared,
      sharedOwnerEmail: sharedOwnerEmail,
    );
  }

  Future<void> _showBackupsDialog(
    String farmName,
    List<BackupEntry> initial, {
    required String backupsDir,
    SaveFile? localSave,
    String? sharedFolderId,
    required bool canEditShared,
    String? sharedOwnerEmail,
  }) async {
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
              maxWidth: 420,
              accent: const Color(0xFF97C459),
              child: _dialogBody(
                title: Text(
                  l10n.backupsScreenTitle(farmName),
                  style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (localSave != null) ...[
                      _infoBox(
                        color: const Color(0xFF97C459),
                        icon: Icons.laptop_mac_rounded,
                        text: l10n.backupsCreateLocalHint,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (localSave != null || entries.isEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (localSave != null)
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 235),
                              child: BackupActionButton(
                                key: const ValueKey('backup-create-action'),
                                label: l10n.backupsCreate,
                                icon: Icons.add_box_outlined,
                                color: const Color(0xFFE0B850),
                                filled: true,
                                onPressed: () => _createManualBackup(
                                  localSave,
                                  backupsDir,
                                  entries,
                                  setState,
                                ),
                              ),
                            ),
                          if (entries.isEmpty)
                            Text(
                              l10n.backupsEmpty,
                              style: GoogleFonts.firaCode(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                        ],
                      ),
                    if (localSave != null || entries.isEmpty)
                      const SizedBox(height: 5),
                    if (entries.isNotEmpty)
                      for (final entry in List<BackupEntry>.of(entries))
                        _backupRow(
                          entry,
                          onRestore: () async {
                            await _handleRestoreBackup(entry);
                          },
                          onDelete: _canDeleteBackup(entry, canEditShared)
                              ? () async {
                                  final result = await _handleDeleteBackup(
                                    entry,
                                    canEditShared: canEditShared,
                                  );
                                  if (!result.changed) return;
                                  setState(() {
                                    final index = entries.indexWhere(
                                      (item) => item.fileName == entry.fileName,
                                    );
                                    if (index < 0) return;
                                    final remaining = result.remaining;
                                    if (remaining == null) {
                                      entries.removeAt(index);
                                    } else {
                                      entries[index] = remaining;
                                    }
                                  });
                                }
                              : null,
                          onDownload:
                              !entry.isLocal &&
                                  widget.drive != null &&
                                  (entry.isOnDrive || entry.isOnSharedDrive)
                              ? () => _downloadBackup(
                                  entry,
                                  backupsDir,
                                  entries,
                                  setState,
                                )
                              : null,
                          onUploadOwn: widget.drive != null && !entry.isOnDrive
                              ? () => _uploadBackup(entry, entries, setState)
                              : null,
                          ownActionCopiesRemote:
                              !entry.isLocal && entry.isOnSharedDrive,
                          onUploadShared:
                              widget.drive != null &&
                                  sharedFolderId != null &&
                                  canEditShared &&
                                  !entry.isOnSharedDrive
                              ? () => _uploadBackup(
                                  entry,
                                  entries,
                                  setState,
                                  sharedFolderId: sharedFolderId,
                                  sharedOwnerEmail: sharedOwnerEmail,
                                )
                              : null,
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
    required Future<void> Function() onRestore,
    Future<void> Function()? onDelete,
    Future<void> Function()? onDownload,
    Future<void> Function()? onUploadOwn,
    Future<void> Function()? onUploadShared,
    bool ownActionCopiesRemote = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final ts = entry.timestamp;
    String p(int n) => n.toString().padLeft(2, '0');
    final dateLabel =
        '${p(ts.day)}/${p(ts.month)}/${ts.year} · ${p(ts.hour)}:${p(ts.minute)}';
    final sizeLabel =
        '${(entry.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .035),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFF8C795A).withValues(alpha: .38),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateLabel,
                        style: GoogleFonts.firaCode(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: .85),
                        ),
                      ),
                      Text(
                        sizeLabel,
                        style: GoogleFonts.firaCode(
                          fontSize: 9.5,
                          color: Colors.white.withValues(alpha: .4),
                        ),
                      ),
                    ],
                  ),
                ),
                _backupLocationIcon(
                  icon: Icons.laptop_mac_rounded,
                  active: entry.isLocal,
                  activeColor: const Color(0xFFE0B850),
                  tooltip: l10n.backupsLocationLocal,
                ),
                const SizedBox(width: 5),
                _backupLocationIcon(
                  icon: Icons.cloud_outlined,
                  active: entry.isOnDrive,
                  activeColor: const Color(0xFF5AA8E0),
                  tooltip: l10n.backupsLocationOwnDrive,
                ),
                const SizedBox(width: 5),
                _backupLocationIcon(
                  icon: Icons.link_rounded,
                  active: entry.isOnSharedDrive,
                  activeColor: const Color(0xFF42D392),
                  tooltip: l10n.backupsLocationSharedDrive,
                ),
                const SizedBox(width: 6),
                BackupActionButton(
                  key: ValueKey('backup-restore-${entry.fileName}'),
                  label: l10n.backupsRestore,
                  icon: Icons.settings_backup_restore_rounded,
                  color: const Color(0xFF7FC4F5),
                  onPressed: onRestore,
                ),
                if (onDelete != null) ...[
                  const SizedBox(width: 6),
                  BackupActionButton(
                    key: ValueKey('backup-delete-${entry.fileName}'),
                    label: l10n.backupsDelete,
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFE05252),
                    iconOnly: true,
                    tooltip: l10n.backupsDelete,
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
            if (onDownload != null ||
                onUploadOwn != null ||
                onUploadShared != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  if (onDownload != null)
                    BackupActionButton(
                      key: ValueKey('backup-download-${entry.fileName}'),
                      label: l10n.backupsDownload,
                      icon: Icons.download_rounded,
                      color: const Color(0xFF7FC4F5),
                      filled: true,
                      onPressed: onDownload,
                    ),
                  if (onUploadOwn != null)
                    BackupActionButton(
                      key: ValueKey('backup-upload-own-${entry.fileName}'),
                      label: ownActionCopiesRemote
                          ? l10n.backupsCopyOwn
                          : l10n.backupsUploadOwn,
                      icon: Icons.cloud_upload_outlined,
                      color: const Color(0xFF5AA8E0),
                      onPressed: onUploadOwn,
                    ),
                  if (onUploadShared != null)
                    BackupActionButton(
                      key: ValueKey('backup-upload-shared-${entry.fileName}'),
                      label: l10n.backupsUploadShared,
                      icon: Icons.link_rounded,
                      color: const Color(0xFF42D392),
                      onPressed: onUploadShared,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _backupLocationIcon({
    required IconData icon,
    required bool active,
    required Color activeColor,
    required String tooltip,
  }) => Tooltip(
    message: tooltip,
    child: Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? activeColor.withValues(alpha: .10) : Colors.transparent,
        border: Border.all(
          color: active
              ? activeColor.withValues(alpha: .55)
              : Colors.white.withValues(alpha: .10),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(
        icon,
        size: 14,
        color: active ? activeColor : Colors.white.withValues(alpha: .16),
      ),
    ),
  );

  Future<void> _uploadBackup(
    BackupEntry entry,
    List<BackupEntry> entries,
    void Function(void Function()) refresh, {
    String? sharedFolderId,
    String? sharedOwnerEmail,
  }) async {
    if (widget.drive == null) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      final id = await _withBackupFile(
        entry,
        (path) => sharedFolderId == null
            ? widget.drive!.uploadBackupZip(path)
            : widget.drive!.uploadBackupZipToSharedSave(sharedFolderId, path),
      );
      final updated = sharedFolderId == null
          ? entry.copyWith(driveFileId: id)
          : entry.copyWith(sharedDriveFileId: id);
      _replaceBackupEntry(entry, updated, entries, refresh);
      if (mounted) _snack(l10n.backupsUploadOk);
    } on SharedAccessRevokedException {
      // Vía activa (ver `_handleSyncShared`) — también puede saltar al
      // intentar subir un backup a un compartido que ya no es nuestro.
      if (sharedFolderId != null && sharedOwnerEmail != null) {
        if (mounted) Navigator.of(context).pop();
        await _handleConfirmedRevocation(
          folderId: sharedFolderId,
          ownerEmail: sharedOwnerEmail,
          farmName: entry.folderName,
        );
      }
    } on SharedAccessReadOnlyException {
      // Ver `_handleSyncShared` — acceso válido, solo bajó a lector.
      if (mounted && sharedOwnerEmail != null) {
        _snack(l10n.sharedAccessReadOnly(sharedOwnerEmail));
      }
    } catch (e) {
      if (mounted) _snack(l10n.backupsUploadErr(e.toString()));
    }
  }

  Future<void> _createManualBackup(
    SaveFile local,
    String backupsDir,
    List<BackupEntry> entries,
    void Function(void Function()) refresh,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final created = await BackupService().createBackup(
        saveFolderPath: local.folderPath,
        folderName: local.folderName,
        backupsDir: backupsDir,
      );
      refresh(() {
        entries.insert(0, created);
        entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
      unawaited(_loadBackupCounts());
      if (mounted) _snack(l10n.backupsCreateOk);
    } catch (e) {
      if (mounted) _snack(l10n.backupsCreateErr(e.toString()));
    }
  }

  Future<void> _downloadBackup(
    BackupEntry entry,
    String backupsDir,
    List<BackupEntry> entries,
    void Function(void Function()) refresh,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final remoteId = entry.driveFileId ?? entry.sharedDriveFileId;
    if (widget.drive == null || remoteId == null) return;
    try {
      final path = '$backupsDir${Platform.pathSeparator}${entry.fileName}';
      await widget.drive!.downloadFile(remoteId, path);
      final updated = entry.copyWith(
        localPath: path,
        sizeBytes: await File(path).length(),
      );
      _replaceBackupEntry(entry, updated, entries, refresh);
      unawaited(_loadBackupCounts());
      if (mounted) _snack(l10n.backupsDownloadOk);
    } catch (e) {
      if (mounted) _snack(l10n.backupsDownloadErr(e.toString()));
    }
  }

  Future<T> _withBackupFile<T>(
    BackupEntry entry,
    Future<T> Function(String path) action,
  ) async {
    if (entry.localPath != null) return action(entry.localPath!);
    final remoteId = entry.driveFileId ?? entry.sharedDriveFileId;
    if (widget.drive == null || remoteId == null) {
      throw StateError('El respaldo no está disponible para transferirlo.');
    }
    final tempDir = await Directory.systemTemp.createTemp('vs_backup_copy_');
    final path = '${tempDir.path}${Platform.pathSeparator}${entry.fileName}';
    try {
      await widget.drive!.downloadFile(remoteId, path);
      return await action(path);
    } finally {
      try {
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      } catch (_) {
        // Limpieza best-effort del puente remoto → remoto.
      }
    }
  }

  void _replaceBackupEntry(
    BackupEntry previous,
    BackupEntry updated,
    List<BackupEntry> entries,
    void Function(void Function()) refresh,
  ) {
    final index = entries.indexWhere(
      (item) => item.fileName == previous.fileName,
    );
    if (index >= 0) refresh(() => entries[index] = updated);
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

    // F6 (T023) — mismo gate que `_hostSwapAvailable`: root/Shizuku son los
    // únicos submodos Android con una copia local sobre la que se puede
    // escribir de verdad. En modo Puente no hay forma automática de empujar
    // el backup restaurado al juego — se explica la alternativa manual en
    // vez de mostrar el snack genérico de "plataforma no soportada".
    final androidBridge =
        Platform.isAndroid &&
        (_mode == AndroidMode.root || _mode == AndroidMode.shizuku);
    if (Platform.isAndroid && !androidBridge) {
      await _showManualRestoreDialog();
      return;
    }
    if (androidBridge && _mode == AndroidMode.shizuku && !_shizukuReady) {
      if (mounted) _snack(l10n.activateShizuku);
      return;
    }

    final remoteId = entry.driveFileId ?? entry.sharedDriveFileId;
    final downloadToPath = (remoteId != null && widget.drive != null)
        ? (String path) => widget.drive!.downloadFile(remoteId, path)
        : null;

    if (androidBridge) {
      await _restoreBackupAndroid(entry, downloadToPath: downloadToPath);
      return;
    }

    final savesDir = SaveService.savesDirectory;
    if (savesDir == null) {
      if (mounted) _snack(l10n.snackPlatformNotSupported);
      return;
    }
    try {
      final result = await BackupService().restoreBackup(
        entry,
        savesDir: savesDir,
        backupsDir: await _backupsDirPath(),
        downloadToPath: downloadToPath,
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

  /// F6 (T023) — Android root/Shizuku: restaura a una carpeta puente propia
  /// (nunca al `savesDir` real, protegido) y solo empuja al juego si
  /// `BackupService.restoreBackup` (que hereda la transaccionalidad de F5)
  /// termina con éxito — mismo patrón que `_importAndroid`.
  Future<void> _restoreBackupAndroid(
    BackupEntry entry, {
    Future<void> Function(String localPath)? downloadToPath,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final folderName = entry.folderName;
    final stagingDir = await Directory.systemTemp.createTemp(
      'vs_restore_stage_',
    );
    try {
      final result = await BackupService().restoreBackup(
        entry,
        savesDir: stagingDir.path,
        backupsDir: await _backupsDirPath(),
        downloadToPath: downloadToPath,
      );
      if (!result.ok) {
        if (mounted) _snack(l10n.backupsRestoreErr(result.error?.name ?? ''));
        return;
      }

      final out = await ShizukuService.instance.prepareOut(folderName);
      final outDir = Directory(out);
      if (await outDir.exists()) await outDir.delete(recursive: true);
      await Directory(
        '${stagingDir.path}${Platform.pathSeparator}$folderName',
      ).rename(out);

      final ok = _mode == AndroidMode.root
          ? await ShizukuService.instance.pushSaveAsRoot(out, folderName)
          : await ShizukuService.instance.pushSave(folderName);
      if (!ok) {
        if (mounted) _snack(l10n.snackWriteError);
        return;
      }
      await _load(silent: true);
      if (mounted) _snack(l10n.backupsRestoreOk);
    } catch (e) {
      if (mounted) _snack(l10n.backupsRestoreErr(e.toString()));
    } finally {
      if (await stagingDir.exists()) await stagingDir.delete(recursive: true);
    }
  }

  /// F6 (T023) — alternativa manual para el submodo Puente: sin root ni
  /// Shizuku no hay forma de que la app escriba en la carpeta del juego.
  Future<void> _showManualRestoreDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await _confirmBackupAction(
      accent: const Color(0xFF5AA8E0),
      title: l10n.backupsRestoreManualTitle,
      body: l10n.backupsRestoreManualBody,
      confirmLabel: l10n.ok,
      confirmIcon: Icons.info_outline_rounded,
    );
  }

  bool _canDeleteBackup(BackupEntry entry, bool canEditShared) =>
      entry.isLocal ||
      entry.isOnDrive ||
      (entry.isOnSharedDrive && canEditShared);

  Future<({bool changed, BackupEntry? remaining})> _handleDeleteBackup(
    BackupEntry entry, {
    required bool canEditShared,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await _confirmBackupDelete(
      entry,
      canEditShared: canEditShared,
    );
    if (choice == null) return (changed: false, remaining: entry);

    try {
      var remaining = entry;
      if ((choice == _BackupDeleteChoice.local ||
              choice == _BackupDeleteChoice.all) &&
          entry.localPath != null) {
        await BackupService().deleteLocalBackup(entry.localPath!);
        remaining = remaining.copyWith(clearLocalPath: true);
      }
      if ((choice == _BackupDeleteChoice.ownDrive ||
              choice == _BackupDeleteChoice.all) &&
          entry.driveFileId != null &&
          widget.drive != null) {
        await widget.drive!.deleteDriveBackup(entry.driveFileId!);
        remaining = remaining.copyWith(clearDriveFileId: true);
      }
      if ((choice == _BackupDeleteChoice.sharedDrive ||
              choice == _BackupDeleteChoice.all) &&
          entry.sharedDriveFileId != null &&
          canEditShared &&
          widget.drive != null) {
        await widget.drive!.deleteDriveBackup(entry.sharedDriveFileId!);
        remaining = remaining.copyWith(clearSharedDriveFileId: true);
      }
      unawaited(_loadBackupCounts());
      return (
        changed: true,
        remaining: remaining.locationCount == 0 ? null : remaining,
      );
    } catch (e) {
      if (mounted) _snack(l10n.backupsDeleteErr(e.toString()));
      return (changed: false, remaining: entry);
    }
  }

  Future<_BackupDeleteChoice?> _confirmBackupDelete(
    BackupEntry entry, {
    required bool canEditShared,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final deletableCount =
        (entry.isLocal ? 1 : 0) +
        (entry.isOnDrive ? 1 : 0) +
        (entry.isOnSharedDrive && canEditShared ? 1 : 0);
    final canDeleteAll =
        deletableCount > 1 && deletableCount == entry.locationCount;
    return showDialog<_BackupDeleteChoice>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE05252),
          child: _dialogBody(
            title: Text(
              l10n.backupsDeleteConfirmTitle,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.backupsDeleteChooseBody,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.5,
                color: Colors.white.withValues(alpha: .80),
              ),
            ),
            actions: [
              if (entry.isLocal)
                SizedBox(
                  width: double.infinity,
                  child: BackupActionButton(
                    label: l10n.backupsDeleteLocalOnly,
                    color: const Color(0xFFE0B850),
                    icon: Icons.laptop_mac_rounded,
                    filled: false,
                    onPressed: () async =>
                        Navigator.pop(ctx, _BackupDeleteChoice.local),
                  ),
                ),
              if (entry.isOnDrive)
                SizedBox(
                  width: double.infinity,
                  child: BackupActionButton(
                    label: l10n.backupsDeleteOwnOnly,
                    color: const Color(0xFF5AA8E0),
                    icon: Icons.cloud_outlined,
                    filled: false,
                    onPressed: () async =>
                        Navigator.pop(ctx, _BackupDeleteChoice.ownDrive),
                  ),
                ),
              if (entry.isOnSharedDrive && canEditShared)
                SizedBox(
                  width: double.infinity,
                  child: BackupActionButton(
                    label: l10n.backupsDeleteSharedOnly,
                    color: const Color(0xFF42D392),
                    icon: Icons.link_rounded,
                    filled: false,
                    onPressed: () async =>
                        Navigator.pop(ctx, _BackupDeleteChoice.sharedDrive),
                  ),
                ),
              if (canDeleteAll)
                SizedBox(
                  width: double.infinity,
                  child: BackupActionButton(
                    label: l10n.backupsDeleteAll,
                    color: const Color(0xFFE05252),
                    icon: Icons.delete_outline_rounded,
                    filled: true,
                    onPressed: () async =>
                        Navigator.pop(ctx, _BackupDeleteChoice.all),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ActionBtn(
                  label: l10n.cancel,
                  color: Colors.white.withValues(alpha: .55),
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
            title: Text(
              title,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              body,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.80),
              ),
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
    SaveEntry entry, {
    _DeleteChoice? requestedLocation,
    required int backupCount,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final hasLocal = entry.local != null;
    final hasDrive = entry.driveFolderId != null && widget.drive != null;
    final farmName = entry.primary.farmName;
    final deletingLocal = requestedLocation == _DeleteChoice.localOnly;
    final deletingDrive = requestedLocation == _DeleteChoice.driveOnly;

    final title = deletingLocal
        ? l10n.deleteLocalContextTitle(farmName)
        : deletingDrive
        ? l10n.deleteDriveContextTitle(farmName)
        : l10n.deleteUnifiedTitle(farmName);

    final notices = <Widget>[];
    if (deletingDrive && hasLocal) {
      notices.add(
        _infoBox(
          color: const Color(0xFF7FBF7F),
          icon: Icons.laptop_mac_rounded,
          text: l10n.deleteDriveLocalKept,
        ),
      );
    } else if (deletingLocal) {
      final local = entry.local;
      final drive = entry.drive;
      if (drive != null) {
        final driveDate = l10n.statDayYear(drive.dayOfMonth, drive.year);
        final (color, icon, text) = switch (entry.status) {
          SaveSyncStatus.synced => (
            const Color(0xFF5AA8E0),
            Icons.cloud_done_outlined,
            l10n.deleteLocalDriveCurrent(driveDate),
          ),
          SaveSyncStatus.driveAhead => (
            const Color(0xFF5AA8E0),
            Icons.cloud_done_outlined,
            l10n.deleteLocalDriveAhead(driveDate),
          ),
          SaveSyncStatus.localAhead => (
            const Color(0xFFE0A860),
            Icons.warning_amber_rounded,
            l10n.deleteLocalDriveOlder(
              driveDate,
              l10n.statDayYear(local!.dayOfMonth, local.year),
            ),
          ),
          _ => (
            const Color(0xFF5AA8E0),
            Icons.cloud_outlined,
            l10n.deleteLocalDriveCurrent(driveDate),
          ),
        };
        notices.add(_infoBox(color: color, icon: icon, text: text));
      } else if (backupCount > 0) {
        notices.add(
          _infoBox(
            color: const Color(0xFF97C459),
            icon: Icons.inventory_2_outlined,
            text: l10n.deleteLocalBackupAvailable(backupCount),
          ),
        );
      } else {
        notices.add(
          _infoBox(
            color: const Color(0xFFE05252),
            icon: Icons.warning_amber_rounded,
            text: l10n.deleteLocalNoRecovery,
          ),
        );
      }
    }

    final body = deletingLocal
        ? l10n.deleteLocalContextBody
        : deletingDrive
        ? l10n.deleteDriveContextBody
        : l10n.deleteChooseLocationBody;

    return showDialog<_DeleteChoice>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          accent: const Color(0xFFE05252),
          child: _dialogBody(
            title: Text(
              title,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  body,
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.80),
                  ),
                ),
                if (notices.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...notices,
                ],
              ],
            ),
            actions: [
              if (hasLocal && !deletingDrive)
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
              if (hasDrive && !deletingLocal)
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
              if (requestedLocation == null && hasLocal && hasDrive)
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
            title: Text(
              l10n.importConflictTitle,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.importConflictBody,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            actions: [
              ActionBtn(
                label: l10n.importConflictConfirm,
                color: const Color(0xFFE05252),
                icon: Icons.sync_alt_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
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

  /// [remoteLabel]/[remoteColor]/[remoteIcon] (spec 008, T811): generalizan
  /// la cara "Drive" a un tercer sitio (Drive del dueño) sin tocar el
  /// comportamiento de las partidas propias — por defecto quedan sin usar y
  /// `_flowHeader`/`_overwritePreview` caen en `previewDriveLabel` + azul,
  /// exactamente como antes (G3).
  Future<bool?> _confirmDownload(
    SaveEntry entry, {
    String? remoteLabel,
    Color? remoteColor,
    String? remoteIcon,
  }) {
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
            final idx = coop
                ? playerIndex.clamp(0, playerBase.players.length - 1)
                : 0;
            // Un SaveGameInfo remoto puede no traer `players.json`.
            // En ese caso la granja sigue siendo descargable, pero no hay
            // jugador que seleccionar ni comparar por uniqueId.
            final selected = coop ? playerBase.players[idx] : null;
            // Cada lado busca a la MISMA persona (por uniqueId) en su PROPIA
            // lista, en vez de reutilizar el PlayerStats de un solo lado —
            // tras un swap, el índice 0 ya no es la misma persona en local y
            // en Drive (feedback 2026-07-12: "falso positivo" en la comparación).
            final drivePlayer = coop
                ? _matchPlayerById(driveBase.players, selected!.uniqueId) ??
                      selected
                : null;
            final drive = coop ? driveBase.forPlayer(drivePlayer!) : driveBase;
            final local = localBase == null
                ? null
                : (coop
                      ? localBase.forPlayer(
                          _matchPlayerById(
                                localBase.players,
                                selected!.uniqueId,
                              ) ??
                              selected,
                        )
                      : localBase);
            final hostIndex = coop
                ? playerBase.players.indexWhere((p) => p.isHost)
                : -1;
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
            final ledger = local == null
                ? null
                : _computeOverwriteLedger(
                    l10n,
                    current: local,
                    result: drive,
                    overwrittenSideLabel: l10n.previewLocalLabel,
                  );
            final danger = ledger?.isDanger ?? false;
            return _glassDialogShell(
              maxWidth: 460,
              child: _dialogBody(
                title: Text(
                  l10n.dlgDownloadTitle,
                  style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.80),
                        ),
                      ),
                      _flowHeader(
                        l10n,
                        uploading: false,
                        isNewCopy: true,
                        remoteLabel: remoteLabel,
                        remoteColor: remoteColor,
                        remoteIcon: remoteIcon,
                      ),
                      if (switcher != null) ...[
                        const SizedBox(height: 12),
                        Center(child: switcher),
                      ],
                    ] else
                      _overwritePreview(
                        l10n: l10n,
                        intro: l10n.dlgDownloadOverwrite(drive.farmName),
                        uploading: false,
                        ledger: ledger!,
                        afterIntro: switcher,
                        remoteLabel: remoteLabel,
                        remoteColor: remoteColor,
                        remoteIcon: remoteIcon,
                      ),
                    if (local != null &&
                        drive.gameVersion.isNotEmpty &&
                        local.gameVersion.isNotEmpty &&
                        drive.gameVersion != local.gameVersion) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFE09020,
                          ).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(
                              0xFFE09020,
                            ).withValues(alpha: 0.40),
                          ),
                        ),
                        child: Text(
                          l10n.versionMismatch(
                            local.gameVersion,
                            drive.gameVersion,
                          ),
                          style: GoogleFonts.firaCode(
                            fontSize: 10,
                            height: 1.5,
                            color: const Color(
                              0xFFE09020,
                            ).withValues(alpha: 0.90),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  ActionBtn(
                    label: danger
                        ? l10n.overwriteDangerButtonDownload
                        : l10n.dlgDownloadButton,
                    color: danger
                        ? const Color(0xFFE05C5C)
                        : (remoteColor ?? const Color(0xFF5AA8E0)),
                    icon: danger
                        ? Icons.warning_amber_rounded
                        : Icons.cloud_download_outlined,
                    filled: true,
                    onTap: () async {
                      if (danger) {
                        final confirmed = await _confirmDangerousOverwrite(
                          l10n: l10n,
                          uploading: false,
                          delta: ledger!.delta,
                          target: l10n.previewLocalLabel,
                        );
                        if (confirmed == true && ctx.mounted) {
                          Navigator.pop(ctx, true);
                        }
                      } else {
                        Navigator.pop(ctx, true);
                      }
                    },
                  ),
                  ActionBtn(
                    label: l10n.cancel,
                    color: Colors.white.withValues(alpha: 0.55),
                    filled: false,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// [remoteLabel]/[remoteColor]/[remoteIcon] (spec 008, T811): mismo
  /// mecanismo que `_confirmDownload` para generalizar la cara "Drive" a un
  /// tercer sitio, sin tocar el comportamiento de las partidas propias (G3).
  /// [actionLabel] sobrescribe el texto del botón normal (no-peligro) —
  /// D2 exige nombres explícitos por destino ("Subir al Drive de {email}")
  /// en vez del genérico `dlgUploadButton`; por defecto sigue siendo ese
  /// genérico.
  Future<bool?> _confirmUpload(
    SaveEntry entry, {
    String? remoteLabel,
    Color? remoteColor,
    String? remoteIcon,
    String? actionLabel,
  }) {
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
            final idx = coop
                ? playerIndex.clamp(0, localBase.players.length - 1)
                : 0;
            final selected = coop ? localBase.players[idx] : null;
            final local = coop ? localBase.forPlayer(selected!) : localBase;
            // Mismo fix que _confirmDownload: buscar a la misma persona (por
            // uniqueId) en la lista PROPIA de Drive, no reutilizar el
            // PlayerStats local para ambas columnas.
            final drive = driveBase == null
                ? null
                : (coop
                      ? driveBase.forPlayer(
                          _matchPlayerById(
                                driveBase.players,
                                selected!.uniqueId,
                              ) ??
                              selected,
                        )
                      : driveBase);
            final hostIndex = coop
                ? localBase.players.indexWhere((p) => p.isHost)
                : -1;
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
            final ledger = drive == null
                ? null
                : _computeOverwriteLedger(
                    l10n,
                    current: drive,
                    result: local,
                    overwrittenSideLabel: remoteLabel ?? l10n.previewDriveLabel,
                  );
            final danger = ledger?.isDanger ?? false;
            return _glassDialogShell(
              maxWidth: 460,
              child: _dialogBody(
                title: Text(
                  l10n.dlgUploadTitle,
                  style: GoogleFonts.bodoniModa(
                    color: AppColors.text,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.80),
                            ),
                          ),
                          _flowHeader(
                            l10n,
                            uploading: true,
                            isNewCopy: true,
                            remoteLabel: remoteLabel,
                            remoteColor: remoteColor,
                            remoteIcon: remoteIcon,
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
                        uploading: true,
                        ledger: ledger!,
                        afterIntro: switcher,
                        remoteLabel: remoteLabel,
                        remoteColor: remoteColor,
                        remoteIcon: remoteIcon,
                      ),
                actions: [
                  ActionBtn(
                    label: danger
                        ? l10n.overwriteDangerButtonUpload
                        : (actionLabel ?? l10n.dlgUploadButton),
                    color: danger
                        ? const Color(0xFFE05C5C)
                        : (remoteColor ?? const Color(0xFFE0B850)),
                    icon: danger
                        ? Icons.warning_amber_rounded
                        : Icons.cloud_upload_outlined,
                    filled: true,
                    onTap: () async {
                      if (danger) {
                        final confirmed = await _confirmDangerousOverwrite(
                          l10n: l10n,
                          uploading: true,
                          delta: ledger!.delta,
                          target: remoteLabel ?? l10n.previewDriveLabel,
                        );
                        if (confirmed == true && ctx.mounted) {
                          Navigator.pop(ctx, true);
                        }
                      } else {
                        Navigator.pop(ctx, true);
                      }
                    },
                  ),
                  ActionBtn(
                    label: l10n.cancel,
                    color: Colors.white.withValues(alpha: 0.55),
                    filled: false,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Card "cómo quedará": ledger de diferencias entre lo que se sobrescribe
  /// (`current`) y lo que lo reemplazará (`result`). Rediseño 2026-07-29 —
  /// reemplaza las dos columnas de 13 filas por: indicador de flujo fijo
  /// (ESTE EQUIPO ↔ EN DRIVE, nunca invertido), ledger solo-diferencias
  /// (habilidades/otras-stats en rejilla de 2 columnas sin título) y una
  /// caja de veredicto. Ver memoria `project_valleysave_overwrite_dialog_redesign`.
  Widget _overwritePreview({
    required AppLocalizations l10n,
    required String intro,
    required bool uploading,
    required OverwriteLedger ledger,
    Widget? afterIntro,
    String? remoteLabel,
    Color? remoteColor,
    String? remoteIcon,
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
            color: Colors.white.withValues(alpha: 0.80),
          ),
        ),
        if (afterIntro != null) ...[
          const SizedBox(height: 12),
          Center(child: afterIntro),
        ],
        const SizedBox(height: 14),
        _flowHeader(
          l10n,
          uploading: uploading,
          danger: ledger.isDanger,
          remoteLabel: remoteLabel,
          remoteColor: remoteColor,
          remoteIcon: remoteIcon,
        ),
        const SizedBox(height: 14),
        _ledgerWidget(l10n, ledger),
        const SizedBox(height: 12),
        _verdictBox(ledger),
      ],
    );
  }

  /// Indicador de flujo: IZQUIERDA = ESTE EQUIPO SIEMPRE, DERECHA = EN DRIVE
  /// SIEMPRE (decisión aprobada — antes se invertía según subir/bajar, lo que
  /// confundía). La flecha en círculo indica la dirección real de la copia;
  /// la etiqueta "SE SOBRESCRIBE" va pegada al lado que se pierde.
  ///
  /// [remoteLabel]/[remoteColor]/[remoteIcon] generalizan la caja derecha a
  /// un tercer sitio (spec 008, T810): por defecto siguen siendo
  /// `l10n.previewDriveLabel` + azul `#5AA8E0` + ☁️ — las partidas propias no
  /// cambian ni un píxel (G3). Para el Drive del dueño el caller pasa
  /// `l10n.sharedSideOwnerDrive(email)` + verde menta `#42D392` + 🔗.
  Widget _flowHeader(
    AppLocalizations l10n, {
    required bool uploading,
    bool danger = false,
    bool isNewCopy = false,
    String? remoteLabel,
    Color? remoteColor,
    String? remoteIcon,
  }) {
    const kLocalColor = Color(0xFFE0B850);
    final kDriveColor = remoteColor ?? const Color(0xFF5AA8E0);
    const kDangerColor = Color(0xFFE05C5C);
    final arrowColor = danger
        ? kDangerColor
        : (uploading ? kLocalColor : kDriveColor);
    // Subiendo: se sobrescribe EN DRIVE (derecha). Bajando: se sobrescribe
    // ESTE EQUIPO (izquierda).
    final overwriteOnLeft = !uploading;

    var leftLabel = l10n.previewLocalLabel;
    var rightLabel = remoteLabel ?? l10n.previewDriveLabel;
    if (isNewCopy) {
      if (uploading) {
        rightLabel = '$rightLabel (${l10n.overwriteNewCopyTag})';
      } else {
        leftLabel = '$leftLabel (${l10n.overwriteNewCopyTag})';
      }
    }

    Widget box({
      required String label,
      required String icon,
      required Color color,
      required bool tagged,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF151512),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (tagged && danger ? kDangerColor : color)
                  .withValues(alpha: 0.60),
              width: 1.5,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: tagged ? 6 : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.firaCode(
                        fontSize: 8,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              if (tagged)
                Positioned(
                  top: -17,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: kDangerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.overwriteTagOverwritten,
                      style: GoogleFonts.firaCode(
                        fontSize: 6.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: const Color(0xFF1B0E0E),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          box(
            label: leftLabel,
            icon: _localIcon,
            color: kLocalColor,
            tagged: !isNewCopy && overwriteOnLeft,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: arrowColor.withValues(alpha: 0.16),
                border: Border.all(color: arrowColor, width: 2),
              ),
              child: Icon(
                uploading
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_back_rounded,
                size: 17,
                color: arrowColor,
              ),
            ),
          ),
          box(
            label: rightLabel,
            icon: remoteIcon ?? '☁️',
            color: kDriveColor,
            tagged: !isNewCopy && !overwriteOnLeft,
          ),
        ],
      ),
    );
  }

  /// Ledger solo-diferencias: los 4 stats "cabecera" en fila individual con
  /// píldora, y habilidades/otras-stats en rejilla de 2 columnas sin título
  /// (solo los que cambiaron) — decisión aprobada 2026-07-29.
  Widget _ledgerWidget(AppLocalizations l10n, OverwriteLedger ledger) {
    const kGreen = Color(0xFF62B074);
    const kRed = Color(0xFFE05C5C);
    const kTextMuted = Color(0xFFC0A980);

    Widget pillRow(_StatDiff d) {
      final color = d.worse ? kRed : kGreen;
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              d.label.toUpperCase(),
              style: GoogleFonts.firaCode(
                fontSize: 8,
                letterSpacing: 0.6,
                color: kTextMuted,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: color.withValues(alpha: 0.32)),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${d.before} ',
                      style: GoogleFonts.firaCode(
                        fontSize: 10.5,
                        color: color.withValues(alpha: 0.55),
                      ),
                    ),
                    TextSpan(
                      text: '→ ${d.after}',
                      style: GoogleFonts.firaCode(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget gridCell(_StatDiff d) {
      final color = d.worse ? kRed : kGreen;
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                d.label.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.firaCode(
                  fontSize: 8,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w500,
                  color: kTextMuted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${d.before} ',
                    style: GoogleFonts.firaCode(
                      fontSize: 10.5,
                      color: color.withValues(alpha: 0.5),
                    ),
                  ),
                  TextSpan(
                    text: '→ ${d.after}',
                    style: GoogleFonts.firaCode(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget grid(List<_StatDiff> items) {
      if (items.isEmpty) return const SizedBox.shrink();
      final rows = <Widget>[];
      for (var i = 0; i < items.length; i += 2) {
        final pair = items.sublist(i, (i + 2).clamp(0, items.length));
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                gridCell(pair[0]),
                if (pair.length > 1) ...[
                  const SizedBox(width: 14),
                  gridCell(pair[1]),
                ] else
                  const Spacer(),
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(children: rows),
      );
    }

    final identicalLine = ledger.identicalLabels.isEmpty
        ? null
        : l10n.overwriteIdenticalSummary(
            ledger.identicalLabels.length,
            ledger.identicalLabels.join(', '),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.overwriteWhatChanges.toUpperCase(),
          style: GoogleFonts.firaCode(
            fontSize: 8,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: kTextMuted,
          ),
        ),
        const SizedBox(height: 7),
        ...ledger.headline.map(pillRow),
        grid(ledger.skills),
        grid(ledger.others),
        if (identicalLine != null)
          Text(
            identicalLine,
            style: GoogleFonts.firaCode(
              fontSize: 9,
              height: 1.5,
              color: AppColors.textFaint,
            ),
          ),
      ],
    );
  }

  /// Caja de veredicto/aviso — verde (por delante, seguro), ámbar (dinero
  /// gastado, informativo), gris (diferencia insignificante) o rojo (peligro,
  /// dispara además el segundo diálogo de confirmación al pulsar el botón).
  Widget _verdictBox(OverwriteLedger ledger) {
    final Color tone = switch (ledger.verdict) {
      _OverwriteVerdict.green => const Color(0xFF62B074),
      _OverwriteVerdict.amber => const Color(0xFFE0A850),
      _OverwriteVerdict.gray => Colors.white,
      _OverwriteVerdict.red => const Color(0xFFE05C5C),
    };
    final Color fg = switch (ledger.verdict) {
      _OverwriteVerdict.green => const Color(0xFFA9DAB6),
      _OverwriteVerdict.amber => const Color(0xFFE8C98F),
      _OverwriteVerdict.gray => Colors.white.withValues(alpha: 0.65),
      _OverwriteVerdict.red => const Color(0xFFF3B6B6),
    };
    final isGray = ledger.verdict == _OverwriteVerdict.gray;
    final isRed = ledger.verdict == _OverwriteVerdict.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: isGray ? 0.06 : 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tone.withValues(alpha: isGray ? 0.14 : (isRed ? 1.0 : 0.32)),
          width: isRed ? 1.5 : 1,
        ),
      ),
      child: Text(
        ledger.verdictText,
        style: GoogleFonts.firaCode(fontSize: 11.5, height: 1.5, color: fg),
      ),
    );
  }

  /// Segundo diálogo de confirmación — SOLO en el caso peligro (cualquier
  /// stat, salvo dinero actual, empeora al sobrescribir). Reutiliza
  /// `_glassDialogShell`/`_dialogBody`, no un componente nuevo. Aprobado por
  /// mockup 2026-07-29 (opción 3: reusar el patrón existente).
  Future<bool?> _confirmDangerousOverwrite({
    required AppLocalizations l10n,
    required bool uploading,
    required String delta,
    required String target,
  }) {
    const kDangerColor = Color(0xFFE05C5C);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          maxWidth: 340,
          accent: kDangerColor,
          child: _dialogBody(
            title: Text(
              uploading
                  ? l10n.overwriteConfirmTitleUpload
                  : l10n.overwriteConfirmTitleDownload,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.overwriteConfirmBody(delta, target),
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
            actions: [
              ActionBtn(
                label: uploading
                    ? l10n.overwriteConfirmButtonUpload
                    : l10n.overwriteConfirmButtonDownload,
                color: kDangerColor,
                icon: Icons.warning_amber_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Variante de `_confirmDangerousOverwrite` para el diálogo combinado
  /// (D3): nombra el/los destino(s) que retroceden en vez de uno fijo.
  /// Reutiliza `_glassDialogShell`/`_dialogBody` — mismo patrón, texto
  /// distinto (`overwriteConfirmTitleBoth`/`overwriteConfirmBodyBoth`).
  Future<bool?> _confirmDangerousOverwriteBoth({
    required AppLocalizations l10n,
    required String delta,
    required String targets,
  }) {
    const kDangerColor = Color(0xFFE05C5C);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          maxWidth: 340,
          accent: kDangerColor,
          child: _dialogBody(
            title: Text(
              l10n.overwriteConfirmTitleBoth,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              l10n.overwriteConfirmBodyBoth(delta, targets),
              style: GoogleFonts.firaCode(
                fontSize: 12,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
            actions: [
              ActionBtn(
                label: l10n.overwriteConfirmButtonUpload,
                color: kDangerColor,
                icon: Icons.warning_amber_rounded,
                filled: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cabecera de flujo del diálogo combinado (D3, "Diseño visual APROBADO"
  /// punto 1): un origen (ESTE EQUIPO) a la izquierda, los dos destinos
  /// APILADOS a la derecha (gap 16px) — cada uno con su propio color y su
  /// propia píldora "SE SOBRESCRIBE" si retrocede. Punto 3: solo la caja del
  /// destino que retrocede se pinta en rojo, el que no pierde nada conserva
  /// su color normal. Mismo lenguaje visual que `_flowHeader`, adaptado a
  /// dos destinos en vez de uno (no hay forma de reutilizar esa función tal
  /// cual: su contrato es un único remoto).
  Widget _combinedFlowHeader(
    AppLocalizations l10n, {
    required bool showOwn,
    required bool showOwner,
    required bool dangerOwn,
    required bool dangerOwner,
    required String ownerLabel,
  }) {
    const kLocalColor = Color(0xFFE0B850);
    const kDriveColor = Color(0xFF5AA8E0);
    const kOwnerColor = Color(0xFF42D392);
    const kDangerColor = Color(0xFFE05C5C);
    final danger = dangerOwn || dangerOwner;
    final arrowColor = danger ? kDangerColor : kLocalColor;

    Widget destBox({
      required String label,
      required String icon,
      required Color color,
      required bool isDanger,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFF151512),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (isDanger ? kDangerColor : color).withValues(alpha: 0.60),
            width: 1.5,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(top: isDanger ? 6 : 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: GoogleFonts.firaCode(
                        fontSize: 8,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isDanger)
              Positioned(
                top: -17,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: kDangerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.overwriteTagOverwritten,
                    style: GoogleFonts.firaCode(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF1B0E0E),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF151512),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: kLocalColor.withValues(alpha: 0.60),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_localIcon, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(
                    l10n.previewLocalLabel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaCode(
                      fontSize: 8,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      color: kLocalColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: arrowColor.withValues(alpha: 0.16),
                border: Border.all(color: arrowColor, width: 2),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: arrowColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showOwn) ...[
                  destBox(
                    label: l10n.sharedSideMyDrive,
                    icon: '☁️',
                    color: kDriveColor,
                    isDanger: dangerOwn,
                  ),
                  if (showOwner) const SizedBox(height: 16),
                ],
                if (showOwner)
                  destBox(
                    label: ownerLabel,
                    icon: '🔗',
                    color: kOwnerColor,
                    isDanger: dangerOwner,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Cabecera de sección por destino, solo en el diálogo combinado (punto 2
  /// de "Diseño visual APROBADO"): nombre + línea fina del color del
  /// destino. Sustituye al título "QUÉ CAMBIA" cuando hay dos ledgers
  /// completos que separar — la regla de "sin títulos de grupo" aprobada
  /// antes aplica DENTRO de un ledger (habilidades/otras-stats), no entre
  /// dos ledgers enteros.
  Widget _destinationSectionHeader(String label, Color color) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.firaCode(
            fontSize: 8,
            letterSpacing: 0.9,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(height: 1, color: color.withValues(alpha: 0.28)),
        ),
      ],
    );
  }

  /// Diálogo combinado (D3, T815): un origen (local), dos destinos (Mi
  /// Drive + Drive del dueño), cada uno con su propio ledger de diferencias
  /// y su propio veredicto — sus estados son independientes (uno puede ir
  /// por delante y el otro por detrás). `isDanger` global = OR de los dos.
  /// Cancelar no sube a NINGÚN destino (G6): el caller (`_handleSyncBoth`)
  /// solo ejecuta las subidas reales si esto resuelve `true`.
  Future<bool> _confirmUploadToBoth(SharedSaveEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final local = entry.localMatch;
    if (local == null) return false;

    final ownDrive = entry.ownDriveStats;
    final ownerDrive = entry.driveStats;
    final ownerLabel = l10n.sharedSideOwnerDrive(entry.ownerEmail);

    final ledgerOwn = ownDrive == null
        ? null
        : _computeOverwriteLedger(
            l10n,
            current: ownDrive,
            result: local,
            overwrittenSideLabel: l10n.sharedSideMyDrive,
          );
    final ledgerOwner = ownerDrive == null
        ? null
        : _computeOverwriteLedger(
            l10n,
            current: ownerDrive,
            result: local,
            overwrittenSideLabel: ownerLabel,
          );

    final dangerOwn = ledgerOwn?.isDanger ?? false;
    final dangerOwner = ledgerOwner?.isDanger ?? false;
    final danger = dangerOwn || dangerOwner;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _glassDialogShell(
          maxWidth: 460,
          accent: danger ? const Color(0xFFE05C5C) : null,
          child: _dialogBody(
            title: Text(
              l10n.overwriteUploadBoth,
              style: GoogleFonts.bodoniModa(
                color: AppColors.text,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dlgUploadOverwriteDrive(local.farmName),
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.80),
                  ),
                ),
                _combinedFlowHeader(
                  l10n,
                  showOwn: true,
                  showOwner: true,
                  dangerOwn: dangerOwn,
                  dangerOwner: dangerOwner,
                  ownerLabel: ownerLabel,
                ),
                if (ledgerOwn != null) ...[
                  const SizedBox(height: 16),
                  _destinationSectionHeader(
                    l10n.sharedSideMyDrive,
                    const Color(0xFF5AA8E0),
                  ),
                  const SizedBox(height: 8),
                  _ledgerWidget(l10n, ledgerOwn),
                  const SizedBox(height: 12),
                  _verdictBox(ledgerOwn),
                ],
                if (ledgerOwner != null) ...[
                  const SizedBox(height: 16),
                  _destinationSectionHeader(
                    ownerLabel,
                    const Color(0xFF42D392),
                  ),
                  const SizedBox(height: 8),
                  _ledgerWidget(l10n, ledgerOwner),
                  const SizedBox(height: 12),
                  _verdictBox(ledgerOwner),
                ],
              ],
            ),
            actions: [
              ActionBtn(
                label: danger
                    ? l10n.overwriteDangerButtonUpload
                    : l10n.overwriteUploadBoth,
                color: danger
                    ? const Color(0xFFE05C5C)
                    : const Color(0xFFE0B850),
                icon: danger
                    ? Icons.warning_amber_rounded
                    : Icons.cloud_upload_outlined,
                filled: true,
                onTap: () async {
                  if (danger) {
                    final targets = <String>[
                      if (dangerOwn) l10n.sharedTargetOwnDrive,
                      if (dangerOwner) l10n.sharedSyncTargetOwner(entry.ownerEmail),
                    ];
                    final targetsPhrase = targets.length == 2
                        ? l10n.overwriteBothDestinationsLabel(
                            targets[0],
                            targets[1],
                          )
                        : targets.first;
                    // Si los dos retroceden, se muestra el delta del primero
                    // (own) — el spec no define cómo combinar dos deltas
                    // distintos en una sola frase.
                    final delta = dangerOwn
                        ? ledgerOwn!.delta
                        : ledgerOwner!.delta;
                    final confirmed = await _confirmDangerousOverwriteBoth(
                      l10n: l10n,
                      delta: delta,
                      targets: targetsPhrase,
                    );
                    if (confirmed == true && ctx.mounted) {
                      Navigator.pop(ctx, true);
                    }
                  } else {
                    Navigator.pop(ctx, true);
                  }
                },
              ),
              ActionBtn(
                label: l10n.cancel,
                color: Colors.white.withValues(alpha: 0.55),
                filled: false,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        ),
      ),
    );
    return result == true;
  }

  Color get _seasonAccent =>
      SeasonData.data[SeasonController.instance.season.value]!.accentColor;

  String get _localIcon => (Platform.isAndroid || Platform.isIOS) ? '📱' : '💻';

  /// Compara `current` (lo que se sobrescribe) contra `result` (lo que lo
  /// reemplazará) y devuelve el ledger completo: filas cabecera, rejillas de
  /// habilidades/otras-stats, resumen de idénticos, y la clasificación del
  /// veredicto (incluye si dispara el modo peligro).
  ///
  /// Regla del modo peligro (confirmada 2026-07-29): CUALQUIER stat salvo el
  /// dinero actual que empeore activa peligro — el dinero actual queda fuera
  /// a propósito, porque bajar de dinero no es perder progreso real (puede
  /// que te lo hayas gastado), así que solo genera el aviso ámbar informativo.
  OverwriteLedger _computeOverwriteLedger(
    AppLocalizations l10n, {
    required SaveFile current,
    required SaveFile result,
    required String overwrittenSideLabel,
  }) {
    String seasonLabel(String season) => switch (season.toLowerCase()) {
      'spring' => l10n.seasonSpring,
      'summer' => l10n.seasonSummer,
      'fall' => l10n.seasonFall,
      'winter' => l10n.seasonWinter,
      _ => l10n.seasonInitial,
    };
    String dayYear(SaveFile s) =>
        '${seasonLabel(s.currentSeason)} · ${l10n.statDayYear(s.dayOfMonth, s.year)}';
    String preciseDuration(int ms) {
      final d = Duration(milliseconds: ms);
      final h = d.inHours;
      final m = d.inMinutes.remainder(60);
      return m == 0 ? '${h}h' : '${h}h${m.toString().padLeft(2, '0')}m';
    }
    String mineLabel(SaveFile s) => s.deepestMineLevel == 0
        ? l10n.previewColUnexplored
        : 'Nv. ${s.deepestMineLevel}';

    _StatDiff? diff(String label, bool changed, String before, String after, bool worse) =>
        changed ? (label: label, before: before, after: after, worse: worse) : null;

    final headline = <_StatDiff>[];
    final skills = <_StatDiff>[];
    final others = <_StatDiff>[];
    final identical = <String>[];

    final dayDiff = diff(
      l10n.previewColDayYear,
      current.calendarDayOrdinal != result.calendarDayOrdinal,
      dayYear(current),
      dayYear(result),
      result.calendarDayOrdinal < current.calendarDayOrdinal,
    );
    dayDiff != null
        ? headline.add(dayDiff)
        : identical.add(l10n.previewColDayYear.toLowerCase());

    final timeDiff = diff(
      l10n.previewColTime,
      current.millisecondsPlayed != result.millisecondsPlayed,
      preciseDuration(current.millisecondsPlayed),
      preciseDuration(result.millisecondsPlayed),
      result.millisecondsPlayed < current.millisecondsPlayed,
    );
    timeDiff != null
        ? headline.add(timeDiff)
        : identical.add(l10n.previewColTime.toLowerCase());

    final moneyNowDiff = diff(
      l10n.previewColMoney,
      current.currentMoney != result.currentMoney,
      current.currentMoneyLabel,
      result.currentMoneyLabel,
      result.currentMoney < current.currentMoney,
    );
    moneyNowDiff != null
        ? headline.add(moneyNowDiff)
        : identical.add(l10n.previewColMoney.toLowerCase());

    final moneyTotalDiff = diff(
      l10n.previewColTotal,
      current.totalMoneyEarned != result.totalMoneyEarned,
      current.totalMoneyLabel,
      result.totalMoneyLabel,
      result.totalMoneyEarned < current.totalMoneyEarned,
    );
    moneyTotalDiff != null
        ? headline.add(moneyTotalDiff)
        : identical.add(l10n.previewColTotal.toLowerCase());

    void addSkill(String label, int before, int after) {
      final d = diff(label, before != after, '$before', '$after', after < before);
      d != null ? skills.add(d) : identical.add(label.toLowerCase());
    }

    addSkill(l10n.previewColFarming, current.farmingLevel, result.farmingLevel);
    addSkill(l10n.previewColForaging, current.foragingLevel, result.foragingLevel);
    addSkill(l10n.previewColMining, current.miningLevel, result.miningLevel);
    addSkill(l10n.previewColFishing, current.fishingLevel, result.fishingLevel);
    addSkill(l10n.previewColCombat, current.combatLevel, result.combatLevel);

    final friendsDiff = diff(
      l10n.previewColFriends,
      current.goodFriends != result.goodFriends,
      '${current.goodFriends}',
      '${result.goodFriends}',
      result.goodFriends < current.goodFriends,
    );
    friendsDiff != null
        ? others.add(friendsDiff)
        : identical.add(l10n.previewColFriends.toLowerCase());

    final monstersDiff = diff(
      l10n.previewColMonsters,
      current.monstersKilled != result.monstersKilled,
      SaveFile.formatCount(current.monstersKilled),
      SaveFile.formatCount(result.monstersKilled),
      result.monstersKilled < current.monstersKilled,
    );
    monstersDiff != null
        ? others.add(monstersDiff)
        : identical.add(l10n.previewColMonsters.toLowerCase());

    // Desmayos: invertido — MÁS es peor.
    final faintsDiff = diff(
      l10n.previewColFaints,
      current.timesUnconscious != result.timesUnconscious,
      '${current.timesUnconscious}',
      '${result.timesUnconscious}',
      result.timesUnconscious > current.timesUnconscious,
    );
    faintsDiff != null
        ? others.add(faintsDiff)
        : identical.add(l10n.previewColFaints.toLowerCase());

    final mineDiff = diff(
      l10n.previewColMine,
      current.deepestMineLevel != result.deepestMineLevel,
      mineLabel(current),
      mineLabel(result),
      result.deepestMineLevel < current.deepestMineLevel,
    );
    mineDiff != null
        ? others.add(mineDiff)
        : identical.add(l10n.previewColMine.toLowerCase());

    // Peligro: cualquier stat salvo dinero actual que empeore.
    final dangerCandidates = <_StatDiff>[
      ?dayDiff,
      ?timeDiff,
      ?moneyTotalDiff,
      ...skills,
      ...others,
    ];
    final isDanger = dangerCandidates.any((d) => d.worse);

    final dayDeltaAbs =
        (result.calendarDayOrdinal - current.calendarDayOrdinal).abs();
    final timeDeltaMs =
        (result.millisecondsPlayed - current.millisecondsPlayed).abs();
    final timeDeltaAbs = Duration(milliseconds: timeDeltaMs);
    final h = timeDeltaAbs.inHours;
    final m = timeDeltaAbs.inMinutes.remainder(60);
    final timeDeltaLabel = h == 0 ? '${m}m' : '${h}h${m.toString().padLeft(2, '0')}m';
    final delta = l10n.overwriteDeltaPhrase(dayDeltaAbs, timeDeltaLabel);

    final negligible = !isDanger &&
        dayDiff == null &&
        skills.isEmpty &&
        others.isEmpty &&
        timeDeltaAbs.inMinutes < 60;
    final moneyNowWorse = moneyNowDiff?.worse ?? false;

    final _OverwriteVerdict verdict;
    final String verdictText;
    if (isDanger) {
      verdict = _OverwriteVerdict.red;
      verdictText = l10n.overwriteVerdictDanger(delta, overwrittenSideLabel);
    } else if (negligible) {
      verdict = _OverwriteVerdict.gray;
      verdictText = l10n.overwriteVerdictNegligible(delta);
    } else if (moneyNowWorse) {
      verdict = _OverwriteVerdict.amber;
      verdictText = l10n.overwriteVerdictMoneySpent;
    } else {
      verdict = _OverwriteVerdict.green;
      verdictText = l10n.overwriteVerdictAhead(delta);
    }

    return (
      headline: headline,
      skills: skills,
      others: others,
      identicalLabels: identical,
      isDanger: isDanger,
      verdict: verdict,
      verdictText: verdictText,
      delta: delta,
    );
  }

  // ── spec 009 — Capa 2: auto-sync por partida (T920-T922, D6-D9) ─────────
  //
  // Regla de riesgo (no negociable): esta sección NUNCA reimplementa la
  // clasificación verde/ámbar/gris/rojo — siempre llama literalmente a
  // `_computeOverwriteLedger` (arriba) y mira `.verdict`. Solo decide CUÁNDO
  // llamar a los handlers de subida/bajada ya existentes, sin pasar por los
  // diálogos de confirmación (`_confirmUpload`/`_confirmDownload`/
  // `_confirmUploadToBoth`), que son manuales por diseño.

  /// T920 — decide la partida PROPIA (no coop): dirección por `entry.status`
  /// (mismo cálculo que ya usan las cards para mostrar el botón subir/bajar,
  /// `SaveEntry.status`), verdict por `_computeOverwriteLedger` tal cual.
  /// `localOnly`/`driveOnly` (falta un lado) se quedan en `none` a propósito
  /// — sin las dos caras no hay ledger real que calcular, y D6 exige un
  /// veredicto verde, no "no hay nada que perder".
  /// Veredictos que el auto-sync considera "actuable" sin preguntar.
  ///
  /// Verde: vas por delante y no retrocede nada.
  /// Ámbar: SOLO bajó el dinero actual — es decir, jugaste y gastaste. La
  /// regla de peligro ya excluye el dinero actual a propósito, así que
  /// bloquear ámbar era una contradicción: dejaba el auto-sync inútil en el
  /// caso más común (bug real 2026-08-02, partida `Pleyades` con Mi Drive
  /// clavado 18 días atrás porque el jugador había gastado dinero).
  ///
  /// Rojo se queda fuera a propósito: significa que algo DISTINTO del dinero
  /// retrocedió aun yendo el día por delante — las dos copias divergieron —
  /// y una subida sobrescribe Drive sin respaldo previo (a diferencia de las
  /// bajadas, que sí pasan por el auto-backup de `SaveReplaceService`).
  /// Gris queda fuera por inútil: no hay nada que copiar.
  static bool _autoSyncActs(_OverwriteVerdict verdict) =>
      verdict == _OverwriteVerdict.green || verdict == _OverwriteVerdict.amber;

  _AutoSyncAction _decideOwnAutoSync(AppLocalizations l10n, SaveEntry entry) {
    final local = entry.local;
    final drive = entry.drive;
    if (local == null || drive == null) return _AutoSyncAction.none;

    switch (entry.status) {
      case SaveSyncStatus.localAhead:
        final ledger = _computeOverwriteLedger(
          l10n,
          current: drive,
          result: local,
          overwrittenSideLabel: l10n.previewDriveLabel,
        );
        return _autoSyncActs(ledger.verdict)
            ? _AutoSyncAction.upload
            : _AutoSyncAction.none;
      case SaveSyncStatus.driveAhead:
        if (!entry.driveComplete) return _AutoSyncAction.none; // FR-015
        final ledger = _computeOverwriteLedger(
          l10n,
          current: local,
          result: drive,
          overwrittenSideLabel: l10n.previewLocalLabel,
        );
        return _autoSyncActs(ledger.verdict)
            ? _AutoSyncAction.download
            : _AutoSyncAction.none;
      case SaveSyncStatus.synced:
      case SaveSyncStatus.localOnly:
      case SaveSyncStatus.driveOnly:
        return _AutoSyncAction.none;
    }
  }

  /// T922 — plan de una partida coop: qué hacer (si algo) en Mi Drive y en
  /// el Drive del dueño, de forma INDEPENDIENTE. Reutiliza
  /// `SharedSyncState.fromEntry` (spec 008) para la relación de cada lado —
  /// mismo cálculo ya probado que usa el footer para decidir qué botón
  /// mostrar, no una versión nueva.
  ({_AutoSyncAction ownDrive, _AutoSyncAction ownerDrive}) _decideSharedAutoSync(
    AppLocalizations l10n,
    SharedSaveEntry entry,
  ) {
    final local = entry.localMatch;
    if (local == null) {
      return (ownDrive: _AutoSyncAction.none, ownerDrive: _AutoSyncAction.none);
    }

    final state = SharedSyncState.fromEntry(entry);

    _AutoSyncAction forRelation(
      SharedCopyRelation relation,
      SaveFile? remote,
      String remoteLabel,
      bool remoteComplete,
    ) {
      if (remote == null) return _AutoSyncAction.none; // missing: sin ledger que calcular
      switch (relation) {
        case SharedCopyRelation.behind:
          final ledger = _computeOverwriteLedger(
            l10n,
            current: remote,
            result: local,
            overwrittenSideLabel: remoteLabel,
          );
          return _autoSyncActs(ledger.verdict)
              ? _AutoSyncAction.upload
              : _AutoSyncAction.none;
        case SharedCopyRelation.ahead:
          if (!remoteComplete) return _AutoSyncAction.none; // FR-015
          final ledger = _computeOverwriteLedger(
            l10n,
            current: local,
            result: remote,
            overwrittenSideLabel: l10n.previewLocalLabel,
          );
          return _autoSyncActs(ledger.verdict)
              ? _AutoSyncAction.download
              : _AutoSyncAction.none;
        case SharedCopyRelation.synced:
        case SharedCopyRelation.missing:
        case SharedCopyRelation.unavailable:
          return _AutoSyncAction.none;
      }
    }

    final ownAction = forRelation(
      state.ownDriveRelation,
      entry.ownDriveStats,
      l10n.sharedSideMyDrive,
      entry.ownDriveComplete,
    );
    var ownerAction = forRelation(
      state.ownerDriveRelation,
      entry.driveStats,
      l10n.sharedSideOwnerDrive(entry.ownerEmail),
      entry.complete,
    );
    // Subir al Drive del dueño exige rol escritor y acceso no revocado
    // (mismo gate que `uploadTargets` en `SharedSyncState`/`_handleSyncShared`)
    // — bajar SÍ está permitido en modo lector, sin gate de rol (mismo
    // criterio que `_handleDownloadShared`).
    if (ownerAction == _AutoSyncAction.upload && !entry.canSync) {
      ownerAction = _AutoSyncAction.none;
    }
    if (entry.revoked) ownerAction = _AutoSyncAction.none;

    return (ownDrive: ownAction, ownerDrive: ownerAction);
  }

  /// T921 (G11) — snack breve SOLO si la partida quedó realmente
  /// sincronizada tras la acción (comprobado contra `_entries`/
  /// `_sharedEntries` YA refrescados por el `_load(silent: true)` interno de
  /// cada handler). Evita anunciar éxito si el handler ya mostró su propio
  /// snack de error (p. ej. `_uploadToOwnerDrive` ante
  /// `SharedAccessRevokedException`) — no se toca la firma de esos handlers
  /// (siguen siendo `Future<void>`, compartidos con el flujo manual) para no
  /// arriesgar una regresión ahí; en su lugar se relee el estado ya cargado.
  void _snackAutoSyncIfSynced(String folderName, String farmName) {
    if (!mounted) return;
    final own = _entries.where((e) => e.folderName == folderName);
    final ownSynced = own.isNotEmpty && own.first.status == SaveSyncStatus.synced;

    final shared = _sharedEntries.where((e) => e.folderName == folderName);
    var sharedSynced = false;
    if (shared.isNotEmpty) {
      final state = SharedSyncState.fromEntry(shared.first);
      sharedSynced =
          state.ownDriveRelation == SharedCopyRelation.synced ||
          state.ownerDriveRelation == SharedCopyRelation.synced;
    }

    if (ownSynced || sharedSynced) {
      _snack(AppLocalizations.of(context)!.autoSyncSnack(farmName));
    }
  }

  /// T920 (G10) — partida propia: decide y, si toca, actúa DIRECTAMENTE
  /// sobre los handlers ya existentes (sin diálogo).
  Future<void> _runOwnAutoSync(AppLocalizations l10n, SaveEntry entry) async {
    final name = entry.folderName;
    if (_busy.contains(name)) return; // G10
    final action = _decideOwnAutoSync(l10n, entry);
    switch (action) {
      case _AutoSyncAction.upload:
        await _uploadToOwnDrive(entry);
      case _AutoSyncAction.download:
        await _downloadNow(entry);
      case _AutoSyncAction.none:
        return;
    }
    _snackAutoSyncIfSynced(name, entry.primary.farmName);
  }

  /// T920/T922 (G7, G8, G10) — partida coop: hasta dos destinos
  /// independientes. Si SOLO hay subidas elegibles (uno o los dos), se
  /// disparan a la vez (mismo espíritu que `_confirmUploadToBoth` — leen el
  /// mismo local, escriben en destinos distintos, sin conflicto). Una
  /// bajada nunca se combina con nada más en el mismo ciclo: dos bajadas a
  /// la vez escribirían el MISMO destino local desde dos orígenes remotos
  /// distintos (no hay ni diálogo manual equivalente para ese caso — el
  /// selector `_chooseSharedDownloadSource` existe precisamente porque bajar
  /// siempre elige UN origen), y una subida+bajada simultánea leería y
  /// escribiría el mismo local a la vez. ambos casos se dejan para decisión
  /// manual — no es una omisión del spec, es la lectura conservadora de un
  /// caso que el spec no cubre explícitamente (ver informe final).
  Future<void> _runSharedAutoSync(
    AppLocalizations l10n,
    SharedSaveEntry entry,
  ) async {
    final name = entry.folderName;
    if (_busy.contains(name)) return; // G10
    final farmName =
        entry.localMatch?.farmName ?? entry.driveStats?.farmName ?? name;
    final plan = _decideSharedAutoSync(l10n, entry);

    final downloadsFromOwn = plan.ownDrive == _AutoSyncAction.download;
    final downloadsFromOwner = plan.ownerDrive == _AutoSyncAction.download;
    final uploadsToOwn = plan.ownDrive == _AutoSyncAction.upload;
    final uploadsToOwner = plan.ownerDrive == _AutoSyncAction.upload;
    final downloadCount =
        (downloadsFromOwn ? 1 : 0) + (downloadsFromOwner ? 1 : 0);
    final uploadCount = (uploadsToOwn ? 1 : 0) + (uploadsToOwner ? 1 : 0);

    // Dos bajadas a la vez escribirían el MISMO destino local desde dos
    // orígenes remotos distintos: genuinamente ambiguo (por eso el flujo
    // manual tiene `_chooseSharedDownloadSource`). Se deja para manual.
    if (downloadCount > 1) return;

    // Bajada + subida pendientes en el mismo ciclo (caso real 2026-08-02:
    // Drive del dueño por delante y Mi Drive atrasado): NO se hacen a la vez
    // —leerían y escribirían el mismo local—, pero tampoco se abandonan como
    // antes, que dejaba la partida congelada para siempre. Se hace la bajada
    // ahora y la subida sale sola en el ciclo siguiente (30s), ya calculada
    // sobre el local actualizado.
    if (downloadCount == 1) {
      await _downloadNow(downloadsFromOwn ? entry.asOwnEntry : entry.asEntry);
      _snackAutoSyncIfSynced(name, farmName);
      return;
    }

    if (uploadCount == 0) return;
    final futures = <Future<void>>[
      if (uploadsToOwn) _uploadToOwnDrive(entry.asOwnEntry),
      if (uploadsToOwner) _uploadToOwnerDrive(entry),
    ];
    await Future.wait(futures);
    _snackAutoSyncIfSynced(name, farmName);
  }

  /// T913/T920 — punto de entrada del ciclo: reevalúa TODAS las partidas con
  /// el chip activado sobre el estado YA cargado en `_entries`/
  /// `_sharedEntries` (sin I/O extra más allá de la propia acción de
  /// sincronizar). Copia las listas antes de recorrer: cada acción puede
  /// disparar `_load(silent: true)` internamente y reemplazar
  /// `_entries`/`_sharedEntries` a mitad de la vuelta.
  Future<void> _runAutoSyncCycle() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    for (final entry in List<SaveEntry>.from(_entries)) {
      if (!mounted) return;
      if (!_isAutoSyncEnabled(entry.folderName)) continue;
      await _runOwnAutoSync(l10n, entry);
    }
    for (final entry in List<SharedSaveEntry>.from(_sharedEntries)) {
      if (!mounted) return;
      if (!_isAutoSyncEnabled(entry.folderName)) continue;
      await _runSharedAutoSync(l10n, entry);
    }
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
                    showSharedTitle: _showSharedHeader,
                    connectedEmail: _connectedEmail,
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
    final visibleEntries = _entries
        .where((e) => !sharedFolderNames.contains(e.folderName))
        .toList();
    final entriesEmpty = visibleEntries.isEmpty;
    final sharedEmpty =
        !showShared || (_sharedEntries.isEmpty && !_sharedLoading);
    if (entriesEmpty && sharedEmpty) return _buildEmpty();

    final itemCount = visibleEntries.length + (showShared ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _updateSharedHeaderFromScroll(),
          );
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.accent,
        backgroundColor: AppColors.surface,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: itemCount,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (_, i) {
            if (showShared && i == visibleEntries.length) {
              return KeyedSubtree(
                key: _sharedSectionKey,
                child: StaggerItem(
                  key: ValueKey('${_staggerVersion}_shared'),
                  index: i,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: _buildSharedSection(),
                    ),
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
                        LatestBadge(
                          color: visibleEntries[0].primary.seasonColor,
                        ),
                      SaveCard(
                        entry: visibleEntries[i],
                        busy: _busy.contains(visibleEntries[i].folderName),
                        onUpload: () => _handleUpload(visibleEntries[i]),
                        // FR-015: botón atenuado (no solo bloqueado al
                        // tocarlo) cuando la partida está incompleta en
                        // Drive — coincide con el mockup aprobado.
                        onDownload: visibleEntries[i].driveComplete
                            ? () => _handleDownload(visibleEntries[i])
                            : null,
                        onDeleteFromDrive:
                            visibleEntries[i].driveFolderId != null &&
                                widget.drive != null
                            ? () => _handleDelete(
                                visibleEntries[i],
                                location: _DeleteChoice.driveOnly,
                              )
                            : null,
                        onDeleteLocal: visibleEntries[i].local != null
                            ? () => _handleDelete(
                                visibleEntries[i],
                                location: _DeleteChoice.localOnly,
                              )
                            : null,
                        onManageCopies: () => _handleDelete(visibleEntries[i]),
                        // F3 — gate de plataforma centralizado en
                        // `_hostSwapAvailable` (ver F3 v2, 2026-07-15).
                        onMakeHost:
                            _hostSwapAvailable &&
                                visibleEntries[i].local != null
                            ? (target) =>
                                  _handleMakeHost(visibleEntries[i], target)
                            : null,
                        onExport: visibleEntries[i].local != null
                            ? () => _handleExport(visibleEntries[i])
                            : null,
                        onShare:
                            widget.drive != null &&
                                visibleEntries[i].driveFolderId != null
                            ? () => _handleShare(visibleEntries[i])
                            : null,
                        onBackups: visibleEntries[i].local != null
                            ? () => _handleOpenBackups(visibleEntries[i])
                            : null,
                        backupCount:
                            _backupCounts[visibleEntries[i].folderName] ?? 0,
                        autoSyncEnabled: _isAutoSyncEnabled(
                          visibleEntries[i].folderName,
                        ),
                        onToggleAutoSync: () =>
                            _toggleAutoSync(visibleEntries[i].folderName),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
        // El nombre ya ocupa el título principal al llegar a esta sección:
        // no se repite en una píldora secundaria dentro de la lista.
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (_sharedEntries.isNotEmpty)
              PressableScale(
                onTap: _showManageSharedDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        l10n.sharedManageButton,
                        style: GoogleFonts.firaCode(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            PressableScale(
              onTap: _handleAddShared,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0B850).withValues(alpha: 0.16),
                  border: Border.all(
                    color: const Color(0xFFE0B850).withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '+ ${l10n.sharedWithMeAdd}',
                  style: GoogleFonts.firaCode(
                    fontSize: 10.5,
                    color: const Color(0xFFE0B850),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_sharedLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(child: _seasonalLoader()),
          )
        else if (_sharedEntries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              l10n.sharedWithMeEmpty,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
          )
        else
          for (final e in _sharedEntries) ...[
            SharedSaveCard(
              entry: e,
              busy: _busy.contains(e.folderName),
              // FR-015: mismo gate que la lista principal.
              onDownload: e.complete
                  ? () => _handleDownloadShared(e)
                  : null,
              onSync: (e.canSync && e.localMatch != null)
                  ? () => _handleSyncShared(e)
                  : null,
              onDownloadRequested: () => _handleSharedDownloadRequested(e),
              onSyncRequested: e.localMatch != null
                  ? () => _handleSharedSyncRequested(e)
                  : null,
              onRemove: () => _handleRemoveShared(e),
              // F3 — mismo gate que la lista principal
              // (`_hostSwapAvailable`, solo con copia local); la hoja de
              // detalle aplica el resto (coop + jugador visible no-anfitrión).
              onMakeHost: _hostSwapAvailable && e.localMatch != null
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
              // Caso inverso: jugaste en otro equipo y subiste a tu Drive
              // — tráelo de vuelta aquí. Solo si ya hay algo que bajar.
              onDownloadFromOwnDrive: e.ownDriveStats != null
                  ? () => _handleDownload(e.asOwnEntry)
                  : null,
              // T815 (D3): un solo diálogo combinado con las dos
              // comparaciones y una sola confirmación — sustituye la
              // secuencia de dos diálogos separados de antes.
              onSyncBoth:
                  widget.drive != null && e.localMatch != null && e.canSync
                  ? () => _handleSyncBoth(e)
                  : null,
              // Exportar/Backups operan sobre la copia LOCAL — mismo
              // comportamiento que en "Mis partidas", recuperado tras el
              // rediseño de la tarjeta compartida (2026-07-12).
              onExport: e.localMatch != null
                  ? () => _handleExport(e.asEntry)
                  : null,
              onBackups: e.localMatch != null || e.driveStats != null
                  ? () => _handleOpenBackups(
                      e.asEntry,
                      sharedFolderId: e.folderId,
                      canEditShared: e.canSync,
                      sharedOwnerEmail: e.ownerEmail,
                    )
                  : null,
              backupCount: _backupCounts[e.folderName] ?? 0,
              autoSyncEnabled: _isAutoSyncEnabled(e.folderName),
              onToggleAutoSync: () => _toggleAutoSync(e.folderName),
              // Solo puede borrar TU copia local o TU Drive. El Drive del
              // dueño nunca se expone a estas callbacks.
              onDeleteLocal: e.localMatch != null
                  ? () => _handleDelete(
                      e.asOwnEntry,
                      location: _DeleteChoice.localOnly,
                    )
                  : null,
              onDeleteFromOwnDrive:
                  e.ownDriveStats != null && e.ownDriveFolderId != null
                  ? () => _handleDelete(
                      e.asOwnEntry,
                      location: _DeleteChoice.driveOnly,
                    )
                  : null,
              onManageCopies:
                  e.localMatch != null ||
                      (e.ownDriveStats != null && e.ownDriveFolderId != null)
                  ? () => _handleDelete(e.asOwnEntry)
                  : null,
            ),
            const SizedBox(height: 14),
          ],
      ],
    );
  }

  Widget _spinner() => _seasonalLoader();

  Widget _seasonalLoader() => ValueListenableBuilder<SeasonState>(
    valueListenable: SeasonController.instance.season,
    builder: (_, season, _) =>
        SeasonalLoader(key: ValueKey(season), season: season),
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
            style: GoogleFonts.firaCode(
              fontSize: 13,
              color: AppColors.textFaint,
            ),
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
                        Text(
                          badge,
                          style: GoogleFonts.firaCode(
                            fontSize: 8.5,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                            color: recommended ? season : AppColors.textFaint,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: GoogleFonts.firaCode(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: recommended ? season : AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          desc,
                          style: GoogleFonts.firaCode(
                            fontSize: 12,
                            height: 1.5,
                            color: recommended
                                ? Colors.white.withValues(alpha: 0.82)
                                : AppColors.textFaint,
                          ),
                        ),
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
                              color: season.withValues(alpha: 0.30),
                              width: 2,
                            ),
                    ),
                    child: recommended
                        ? const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: Colors.black,
                          )
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
                  const HowItWorksScreen(scrollToSection: 'shizuku'),
            ),
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
                  Icon(
                    Icons.help_outline_rounded,
                    size: 15,
                    color: Colors.white.withValues(alpha: 0.90),
                  ),
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
                running
                    ? l10n.shizukuStatusRunning
                    : l10n.shizukuStatusNotDetected,
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
                        l10n.shizukuGrant,
                        _requestShizukuPermission,
                        _seasonAccent,
                      )
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
                    color: _seasonAccent.withValues(alpha: 0.16),
                  ),
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
                    _guideStep(
                      '1',
                      l10n.shizukuStep1Title,
                      l10n.shizukuStep1DescFull,
                      action: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _smallButton(
                            l10n.btnPlayStore,
                            _openShizukuPlayStore,
                          ),
                          _smallButton(l10n.btnApkGithub, _openShizukuGithub),
                        ],
                      ),
                    ),
                    _guideStep(
                      '2',
                      l10n.shizukuStep2TitleFull,
                      l10n.shizukuStep2DescFull,
                    ),
                    _guideStep(
                      '3',
                      l10n.shizukuStep3TitleFull,
                      l10n.shizukuStep3DescFull,
                      action: _smallButton(
                        l10n.btnOpenAndHighlight,
                        _openWirelessDebug,
                        icon: Icons.open_in_new_rounded,
                      ),
                    ),
                    _guideStep(
                      '4',
                      l10n.shizukuStep4Title,
                      l10n.shizukuStep4Desc,
                      action: _smallButton(
                        l10n.btnOpenShizuku,
                        _openShizukuApp,
                        icon: Icons.open_in_new_rounded,
                      ),
                    ),
                    _guideStep(
                      '5',
                      l10n.shizukuStep5Title,
                      l10n.shizukuStep5Desc,
                      action: _smallButton(
                        l10n.btnShizukuAppInfo,
                        _openShizukuAppInfo,
                        icon: Icons.open_in_new_rounded,
                      ),
                    ),
                    _guideStep(
                      '6',
                      l10n.shizukuStep3Title,
                      running
                          ? l10n.shizukuStep6DescActive
                          : l10n.shizukuStep6DescWaiting,
                      action: running
                          ? _gateButton(
                              l10n.btnGrantPermission,
                              _requestShizukuPermission,
                              filled: true,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    if (!running)
                      _gateButton(
                        l10n.btnCheckShizuku,
                        _checkShizuku,
                        filled: true,
                      ),
                    const SizedBox(height: 10),
                    _gateButton(
                      l10n.bridgeChangeMode,
                      _resetMode,
                      filled: false,
                    ),
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

  Widget _statusRow(
    String label,
    String sublabel,
    bool done, {
    Widget? action,
  }) {
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
    bool hovered = false;
    return StatefulBuilder(
      builder: (_, setState) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        child: GestureDetector(
        onTap: onTap,
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) => setState(() => pressed = false),
        onTapCancel: () => setState(() => pressed = false),
        child: AnimatedScale(
          scale: pressed ? 0.94 : (hovered ? 1.04 : 1.0),
          duration: pressed
              ? const Duration(milliseconds: 100)
              : const Duration(milliseconds: 200),
          curve: const Cubic(0.23, 1, 0.32, 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: tone.withValues(alpha: hovered ? 0.26 : 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: tone.withValues(alpha: hovered ? 0.65 : 0.45)),
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
              border: Border.all(color: _seasonAccent.withValues(alpha: 0.35)),
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
                if (action != null) ...[const SizedBox(height: 9), action],
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
                color: filled
                    ? tone.withValues(alpha: 0.14)
                    : Colors.transparent,
                border: Border.all(
                  color: tone.withValues(alpha: filled ? 0.55 : 0.28),
                ),
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
