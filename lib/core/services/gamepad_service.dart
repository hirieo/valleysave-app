import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gamepads/gamepads.dart';

import '../../shared/utils/app_page_route.dart';

/// Marca visual del botón "seleccionar" cuando se conoce el mando conectado
/// (leído del nombre que reporta el driver — no es un ID de hardware, así
/// que si el texto no coincide con ninguna marca se cae a [neutral], nunca a
/// una marca equivocada). Ver mockup aprobado 2026-08: sin texto, un
/// punto/glifo de color basta — evita traducir esto a los 14 idiomas.
enum GamepadBrand { neutral, xbox, playStation, nintendo }

GamepadBrand _brandFromName(String name) {
  final n = name.toLowerCase();
  if (n.contains('xbox')) return GamepadBrand.xbox;
  if (n.contains('dualsense') ||
      n.contains('dualshock') ||
      n.contains('playstation') ||
      n.contains('sony')) {
    return GamepadBrand.playStation;
  }
  if (n.contains('nintendo') ||
      n.contains('switch') ||
      n.contains('joy-con') ||
      n.contains('pro controller')) {
    return GamepadBrand.nintendo;
  }
  return GamepadBrand.neutral;
}

/// Un botón registrable por nombre estable (p. ej. `'topbar-settings'`),
/// para que LB/RB/View/Start puedan enfocarlo o activarlo directamente sin
/// depender de dónde esté el foco en ese momento — a diferencia del D-pad/
/// stick, que siempre se mueven relativos al foco actual.
class GamepadTarget {
  const GamepadTarget({required this.focusNode, required this.onTap});
  final FocusNode focusNode;
  final VoidCallback onTap;
}

/// Recuerda la última pantalla push-eada con [AppPageRoute] y, si se
/// cierra, la última cerrada — para que RT pueda "deshacer" un LT/pop y
/// reabrir justo esa pantalla. Un solo nivel (no una pila completa): solo
/// hace falta volver a donde se estaba, no un historial largo. Cualquier
/// push NUEVO (no el propio redo de RT) invalida lo pendiente — igual que
/// el "adelante" de un navegador se borra al visitar una página distinta.
class _GamepadNavObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is AppPageRoute) {
      GamepadService.instance._lastPoppedBuilder = route.builder;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    GamepadService.instance._lastPoppedBuilder = null;
  }
}

/// Puente entre mandos físicos (vía `package:gamepads`, que ya normaliza
/// D-pad/stick/botones a la disposición Xbox en las 6 plataformas — ver
/// `GamepadButton`/`GamepadAxis`/`Gamepads.normalizedEvents`, verificado
/// contra el código fuente del paquete, no adivinado) y el sistema de
/// foco/Actions que Flutter ya trae de serie para teclado.
///
/// No se reinventa la navegación: el mando solo alimenta las mismas
/// `Intent`s (`focusInDirection`, `ActivateIntent`, `DismissIntent`) que ya
/// funcionarían con Tab/Enter/Esc en cualquier widget que ya sea
/// `Focus`-consciente (`FocusableActionDetector`).
///
/// Singleton de proceso — un solo listener para toda la app, arrancar una
/// vez desde `main.dart`.
class GamepadService {
  GamepadService._();
  static final instance = GamepadService._();

  final ValueNotifier<GamepadBrand> brand = ValueNotifier(GamepadBrand.neutral);
  final ValueNotifier<bool> connected = ValueNotifier(false);

  /// Distinto de [connected]: un mando puede estar enchufado (p. ej. de
  /// fábrica, cargándose por USB) sin que nadie lo esté usando. `active`
  /// solo pasa a `true` la primera vez que llega un botón o movimiento de
  /// stick REAL — decisión del usuario 2026-08: nada relacionado con el
  /// mando (el glifo flotante) debe aparecer por el simple hecho de que
  /// haya uno conectado sin tocar.
  final ValueNotifier<bool> active = ValueNotifier(false);

  /// Observador que engancha en `MaterialApp.navigatorObservers` — necesario
  /// para que RT sepa qué pantalla reabrir.
  final NavigatorObserver navObserver = _GamepadNavObserver();

  StreamSubscription<NormalizedGamepadEvent>? _sub;
  Timer? _repeatTimer;
  Timer? _pollTimer;
  TraversalDirection? _heldDirection;
  double _pendingH = 0;
  double _pendingV = 0;

  static const _deadzone = 0.5;
  static const _repeatDelay = Duration(milliseconds: 220);
  static const _firstRepeatDelay = Duration(milliseconds: 420);

  final Map<String, GamepadTarget> _targets = {};

  /// Nombres estables — compartidos con `saves_top_bar.dart`, que es quien
  /// registra los botones reales bajo estas claves.
  static const kTopbarBack = 'topbar-back';
  static const kTopbarSettings = 'topbar-settings';
  static const kTopbarLaunch = 'topbar-launch';

  /// Registra un botón bajo [key] — se sobrescribe en cada rebuild, así que
  /// el `onTap` vigente es siempre el último que registró el widget.
  void registerTarget(
    String key, {
    required FocusNode focusNode,
    required VoidCallback onTap,
  }) {
    _targets[key] = GamepadTarget(focusNode: focusNode, onTap: onTap);
  }

  void unregisterTarget(String key) => _targets.remove(key);

  WidgetBuilder? _lastPoppedBuilder;
  bool _leftTriggerDown = false;
  bool _rightTriggerDown = false;
  static const _triggerThreshold = 0.5;

  Future<void> start() async {
    if (_sub != null) return; // ya arrancado
    await _refreshBrand();
    _sub = Gamepads.normalizedEvents.listen(_onEvent, onError: (_) {});
    // El paquete no expone un stream de conectar/desconectar mando —
    // se relee la lista cada pocos segundos, barato y suficiente solo
    // para saber qué glifo pintar (no es la ruta de input en sí).
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _refreshBrand());
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _repeatTimer?.cancel();
    _pollTimer?.cancel();
  }

  Future<void> _refreshBrand() async {
    try {
      final list = await Gamepads.list();
      connected.value = list.isNotEmpty;
      brand.value =
          list.isEmpty ? GamepadBrand.neutral : _brandFromName(list.first.name);
    } catch (_) {
      // Sin mando, o plataforma sin implementación todavía — no es un
      // error que deba interrumpir nada, simplemente no hay glifo que pintar.
    }
  }

  void _onEvent(NormalizedGamepadEvent event) {
    final button = event.button;
    if (button != null) {
      _onButton(button, event.value);
      return;
    }
    final axis = event.axis;
    if (axis == GamepadAxis.leftStickX) {
      _onAxis(horizontal: event.value);
    } else if (axis == GamepadAxis.leftStickY) {
      _onAxis(vertical: event.value);
    } else if (axis == GamepadAxis.leftTrigger) {
      // En Windows (GameInput/XInput) los gatillos llegan como EJE
      // analógico, nunca como `GamepadButton.leftTrigger` — verificado en
      // el mapeo del paquete (`windows_mapping.dart`: "leftTrigger,
      // rightTrigger: 0.0 to 1.0" está en la sección de ejes, no de
      // botones). Sin este caso, LT/RT no dispararían nunca en Windows.
      _onTriggerAxis(left: true, value: event.value);
    } else if (axis == GamepadAxis.rightTrigger) {
      _onTriggerAxis(left: false, value: event.value);
    }
  }

  void _onButton(GamepadButton button, double value) {
    if (value == 0) return; // solo el flanco de "pulsado"
    switch (button) {
      case GamepadButton.a:
        _activate();
      case GamepadButton.b:
        _dismiss();
      case GamepadButton.dpadUp:
        _moveOnce(TraversalDirection.up);
      case GamepadButton.dpadDown:
        _moveOnce(TraversalDirection.down);
      case GamepadButton.dpadLeft:
        _moveOnce(TraversalDirection.left);
      case GamepadButton.dpadRight:
        _moveOnce(TraversalDirection.right);
      case GamepadButton.leftBumper:
        _focusTarget(kTopbarBack);
      case GamepadButton.rightBumper:
        _focusTarget(kTopbarSettings);
      case GamepadButton.back:
        // View/Select — abre Opciones directo, sin pasar por el foco.
        _invokeTarget(kTopbarSettings);
      case GamepadButton.start:
        _invokeTarget(kTopbarLaunch);
      case GamepadButton.leftTrigger:
        // Otras plataformas (no Windows) pueden reportar el gatillo como
        // botón digital en vez de eje — se cubre igual aquí.
        _triggerBack();
      case GamepadButton.rightTrigger:
        _triggerForward();
      default:
      // El resto de botones (X, Y, home, clics de stick, touchpad...) no
      // tienen significado de navegación todavía.
    }
  }

  void _onTriggerAxis({required bool left, required double value}) {
    final down = value > _triggerThreshold;
    final wasDown = left ? _leftTriggerDown : _rightTriggerDown;
    if (down == wasDown) return; // solo el flanco, como con los botones
    if (left) {
      _leftTriggerDown = down;
    } else {
      _rightTriggerDown = down;
    }
    if (!down) return; // solo al PULSAR, no al soltar
    if (left) {
      _triggerBack();
    } else {
      _triggerForward();
    }
  }

  void _focusTarget(String key) {
    active.value = true;
    _targets[key]?.focusNode.requestFocus();
  }

  void _invokeTarget(String key) {
    active.value = true;
    _targets[key]?.onTap();
  }

  void _triggerBack() {
    active.value = true;
    final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
    if (context == null) return;
    Navigator.of(context).maybePop();
  }

  void _triggerForward() {
    active.value = true;
    final builder = _lastPoppedBuilder;
    if (builder == null) return;
    final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
    if (context == null) return;
    _lastPoppedBuilder = null; // de un solo uso hasta el próximo pop
    Navigator.of(context).push(AppPageRoute(builder: builder));
  }

  /// Ejercita el MISMO despacho que un evento real de mando — sin esto no
  /// hay forma de probar LB/RB/LT/RT/View/Start en tests, ya que
  /// `Gamepads.normalizedEvents` es un stream de plataforma que no se puede
  /// simular ahí. Es un singleton de proceso: los tests que lo usan deben
  /// llamar a [debugReset] en `setUp` para no arrastrar estado entre casos.
  @visibleForTesting
  void debugHandleButton(GamepadButton button, double value) =>
      _onButton(button, value);

  @visibleForTesting
  void debugHandleTriggerAxis({required bool left, required double value}) =>
      _onTriggerAxis(left: left, value: value);

  @visibleForTesting
  void debugReset() {
    _targets.clear();
    _lastPoppedBuilder = null;
    _leftTriggerDown = false;
    _rightTriggerDown = false;
    active.value = false;
  }

  void _onAxis({double? horizontal, double? vertical}) {
    if (horizontal != null) _pendingH = horizontal;
    if (vertical != null) _pendingV = vertical;

    TraversalDirection? dir;
    if (_pendingH.abs() > _pendingV.abs()) {
      if (_pendingH > _deadzone) dir = TraversalDirection.right;
      if (_pendingH < -_deadzone) dir = TraversalDirection.left;
    } else {
      if (_pendingV > _deadzone) dir = TraversalDirection.up;
      if (_pendingV < -_deadzone) dir = TraversalDirection.down;
    }

    if (dir == null) {
      _heldDirection = null;
      _repeatTimer?.cancel();
      return;
    }
    if (dir == _heldDirection) return; // ya en marcha, el timer se repite solo
    _heldDirection = dir;
    _moveOnce(dir);
    _repeatTimer?.cancel();
    _repeatTimer = Timer(_firstRepeatDelay, () => _startRepeating(dir!));
  }

  void _startRepeating(TraversalDirection dir) {
    _repeatTimer = Timer.periodic(_repeatDelay, (_) {
      if (_heldDirection == dir) {
        _moveOnce(dir);
      } else {
        _repeatTimer?.cancel();
      }
    });
  }

  void _moveOnce(TraversalDirection dir) {
    active.value = true;
    // Antes llamaba directo a `focusInDirection`, saltándose `Actions`/
    // `Shortcuts` por completo — el teclado SÍ pasa por ahí (las flechas
    // están ligadas a `DirectionalFocusIntent` por defecto en
    // `WidgetsApp`), así que un widget que quisiera interceptar "arriba/
    // abajo" localmente (p. ej. `CardFocusFrame`, selección de partida a
    // dos niveles) funcionaría con teclado pero NO con mando. Despachando
    // por `Actions.invoke` en vez de por la API de bajo nivel, mando y
    // teclado vuelven a acabar en el mismo sitio — el `Action` por defecto
    // (`DirectionalFocusAction`, registrado en la raíz por `WidgetsApp`)
    // hace exactamente `primaryFocus!.focusInDirection(direction)`, así
    // que en cualquier sitio SIN interceptor el comportamiento es idéntico
    // al de antes.
    final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
    if (context != null) {
      Actions.maybeInvoke(context, DirectionalFocusIntent(dir));
      return;
    }
    // Sin foco activo todavía (p. ej. justo al arrancar la app) — no hay
    // contexto desde el que despachar; mismo fallback directo de siempre.
    FocusManager.instance.rootScope.focusInDirection(dir);
  }

  void _activate() {
    active.value = true;
    final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
    if (context != null) Actions.maybeInvoke(context, const ActivateIntent());
  }

  void _dismiss() {
    active.value = true;
    final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
    if (context != null) Actions.maybeInvoke(context, const DismissIntent());
  }
}
