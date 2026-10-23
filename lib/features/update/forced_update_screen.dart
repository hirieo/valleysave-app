import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/models/season_state.dart';
import '../../core/services/season_controller.dart';
import '../../core/services/update_service.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/app_localizations.dart';
import '../../shared/widgets/valley_canvas_widget.dart';

enum _Phase { checking, downloading, installing, androidConfirm, failed }

/// Actualización obligatoria (release puente 0.4.3, mockup aprobado
/// 2026-10-23): se abre y se actualiza sola, sin opciones. Si falla, solo
/// "Reintentar". No se puede salir de esta pantalla.
class ForcedUpdateScreen extends StatefulWidget {
  const ForcedUpdateScreen({super.key});

  @override
  State<ForcedUpdateScreen> createState() => _ForcedUpdateScreenState();
}

class _ForcedUpdateScreenState extends State<ForcedUpdateScreen>
    with WidgetsBindingObserver {
  _Phase _phase = _Phase.checking;
  double _progress = 0;
  String _installed = '';
  String _target = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Android: si el usuario cancela el instalador del sistema, al volver a la
  /// app se reintenta (no hay forma de usarla sin actualizar).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _phase == _Phase.androidConfirm) {
      _start();
    }
  }

  Future<void> _start() async {
    setState(() {
      _phase = _Phase.checking;
      _progress = 0;
      _error = null;
    });
    _installed = (await PackageInfo.fromPlatform()).version;
    final result = await UpdateService.checkForUpdate();
    if (!mounted) return;
    if (!result.hasUpdate) {
      // Nunca se trata un fallo como "al día" (regla del autoactualizador).
      _fail(result.failureReason ?? 'release no encontrada');
      return;
    }
    final info = result.info!;
    if (Platform.isMacOS) {
      // macOS no tiene instalador automático: se informa y se reintenta.
      _fail('macOS');
      return;
    }
    setState(() {
      _target = info.version;
      _phase = _Phase.downloading;
    });
    await UpdateService.installUpdate(
      info,
      onProgress: (p) {
        if (!mounted) return;
        setState(() {
          _progress = p;
          if (p >= 1) {
            _phase = Platform.isAndroid
                ? _Phase.androidConfirm
                : _Phase.installing;
          }
        });
      },
      onError: _fail,
      onNeedsPermission: () {
        if (mounted) setState(() => _phase = _Phase.androidConfirm);
      },
    );
  }

  void _fail(String reason) {
    if (!mounted) return;
    setState(() {
      _phase = _Phase.failed;
      _error = reason;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: ValueListenableBuilder<SeasonState>(
          valueListenable: SeasonController.instance.season,
          builder: (_, season, _) {
            final accent = SeasonData.data[season]!.accentColor;
            return Stack(
              children: [
                Positioned.fill(child: ValleyCanvasWidget(season: season)),
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
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: _content(l10n, accent),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _content(AppLocalizations l10n, Color accent) {
    final title = switch (_phase) {
      _Phase.checking || _Phase.downloading => l10n.forcedUpdateTitle,
      _Phase.installing => l10n.forcedUpdateInstalling,
      _Phase.androidConfirm => l10n.forcedUpdateAlmostDone,
      _Phase.failed => l10n.forcedUpdateFailedTitle,
    };
    final body = TextStyle(
      fontFamily: GoogleFonts.firaCode().fontFamily,
      fontSize: 12,
      height: 1.6,
      color: Colors.white.withValues(alpha: 0.82),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset('assets/icons/icon.png', width: 64, height: 64),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.bodoniModa(
            fontSize: 26,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 14),
        if (_target.isNotEmpty && _phase != _Phase.failed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              border: Border.all(color: accent.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$_installed → $_target',
              style: GoogleFonts.firaCode(
                fontSize: 10,
                letterSpacing: 1,
                color: accent,
              ),
            ),
          ),
        const SizedBox(height: 16),
        switch (_phase) {
          _Phase.checking => SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: accent),
          ),
          _Phase.downloading => Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  color: accent,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              const SizedBox(height: 8),
              Text('${(_progress * 100).round()} %', style: body),
            ],
          ),
          _Phase.installing => Text(
            l10n.forcedUpdateInstallingBody,
            textAlign: TextAlign.center,
            style: body,
          ),
          _Phase.androidConfirm => Text(
            l10n.forcedUpdateAndroidConfirm,
            textAlign: TextAlign.center,
            style: body,
          ),
          _Phase.failed => Column(
            children: [
              Text(
                _error ?? '',
                textAlign: TextAlign.center,
                style: body.copyWith(color: AppColors.statusErr),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.forcedUpdateFailedBody,
                textAlign: TextAlign.center,
                style: body,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _start,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: const Color(0xFF14110A),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l10n.forcedUpdateRetry,
                    style: GoogleFonts.firaCode(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        },
        if (_phase != _Phase.failed) ...[
          const SizedBox(height: 18),
          Text(
            l10n.forcedUpdateSafe,
            textAlign: TextAlign.center,
            style: GoogleFonts.firaCode(
              fontSize: 10,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
