import 'dart:async';
import 'dart:io';

/// spec 009 (Capa 1, D1) — envoltorio de bajo nivel sobre
/// `Directory.watch(recursive: true)` para detectar cambios en la carpeta de
/// Saves del juego sin sondeo. Sin lógica de negocio dentro: solo dispara
/// [onChange] con debounce; qué hacer con ese aviso (recargar en silencio)
/// es decisión del caller (`saves_screen.dart`).
///
/// Debounce ~800ms (por defecto): Stardew Valley escribe varios archivos por
/// guardado — sin debounce, un solo guardado dispararía varias recargas
/// seguidas (G1).
class LocalSaveWatcher {
  LocalSaveWatcher({
    required this.path,
    required this.onChange,
    this.debounce = const Duration(milliseconds: 800),
  });

  final String path;
  final void Function() onChange;
  final Duration debounce;

  StreamSubscription<FileSystemEvent>? _sub;
  Timer? _debounceTimer;

  bool get isActive => _sub != null;

  /// Empieza a escuchar. Si la carpeta no existe o la plataforma no soporta
  /// `Directory.watch` (poco común, algunos sistemas de archivos de red),
  /// falla en silencio — D1 es solo comodidad/batería, el sondeo de Drive y
  /// el botón manual de refrescar siguen funcionando igual.
  void start() {
    stop();
    final dir = Directory(path);
    if (!dir.existsSync()) return;
    try {
      _sub = dir.watch(recursive: true).listen(
        (_) => _scheduleChange(),
        onError: (_) {},
        cancelOnError: false,
      );
    } catch (_) {
      // Sin soporte de watch en esta plataforma/ruta — se ignora.
    }
  }

  void _scheduleChange() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, onChange);
  }

  /// Cancela el watcher y cualquier debounce pendiente. Idempotente.
  void stop() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _sub?.cancel();
    _sub = null;
  }

  void dispose() => stop();
}
