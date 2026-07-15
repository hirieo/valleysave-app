import 'dart:convert';
import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'drive_service.dart';

export 'package:googleapis_auth/auth_io.dart' show AuthClient;

// Scope completo (no drive.file): "Compartidas conmigo" necesita leer
// contenido de carpetas ajenas compartidas, y el modo coop necesita
// escribir en ellas — drive.file no da acceso recursivo a hijos de una
// carpeta que no es tuya, ni aunque el dueño te la comparta (ver research
// 2026-07-12, picker de Google mostraba "No items in this folder" incluso
// dentro del propio selector oficial).
const _scopes = ['https://www.googleapis.com/auth/drive'];
const _storageKey = 'google_auth_credentials';

bool hasRequiredDriveScopes(Iterable<String> grantedScopes) {
  final granted = grantedScopes.toSet();
  return _scopes.every(granted.contains);
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _storage = const FlutterSecureStorage();
  GoogleSignIn? _googleSignIn;
  AuthClient? _client;

  bool get isSignedIn => _client != null;
  AuthClient? get client => _client;

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<AuthClient?> signIn() async {
    if (Platform.isAndroid || Platform.isIOS) return _signInMobile();
    return _signInDesktop();
  }

  Future<void> signOut() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _googleSignIn?.signOut();
    }
    _client?.close();
    _client = null;
    await _storage.delete(key: _storageKey);
    // Este dispositivo puede volver a conectarse con OTRA cuenta Google —
    // "Compartidas conmigo" es un registro de la cuenta anterior, no del
    // dispositivo (a diferencia de idioma/ruta del juego/estación, que sí
    // son del dispositivo y se quedan). Sin esto, la cuenta nueva hereda
    // entradas ajenas (2026-07-15, detectado probando con 2 cuentas).
    await DriveService.clearAccountScopedCache();
  }

  /// Intenta restaurar la sesión anterior sin mostrar UI.
  Future<AuthClient?> tryRestore() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) return _tryRestoreMobile();
      return _tryRestoreDesktop();
    } catch (_) {
      return null;
    }
  }

  // ── Mobile (Android / iOS) ─────────────────────────────────────────────────

  GoogleSignIn _getGoogleSignIn() {
    _googleSignIn ??= GoogleSignIn(scopes: _scopes);
    return _googleSignIn!;
  }

  Future<AuthClient?> _signInMobile() async {
    final gsi = _getGoogleSignIn();
    final account = await gsi.signIn();
    if (account == null) return null;
    final granted = await gsi.requestScopes(_scopes);
    if (!granted) throw Exception('Drive scope not granted');
    _client = await gsi.authenticatedClient();
    return _client;
  }

  Future<AuthClient?> _tryRestoreMobile() async {
    final gsi = _getGoogleSignIn();
    final account = await gsi.signInSilently();
    if (account == null) return null;
    if (!await gsi.canAccessScopes(_scopes)) {
      final granted = await gsi.requestScopes(_scopes);
      if (!granted) return null;
    }
    _client = await gsi.authenticatedClient();
    return _client;
  }

  // ── Desktop (Windows / macOS / Linux) ──────────────────────────────────────

  ClientId _desktopClientId() {
    final id = dotenv.env['GOOGLE_CLIENT_ID'];
    final secret = dotenv.env['GOOGLE_CLIENT_SECRET'];
    assert(id != null && id.isNotEmpty, 'GOOGLE_CLIENT_ID no está en .env');
    assert(
      secret != null && secret.isNotEmpty,
      'GOOGLE_CLIENT_SECRET no está en .env',
    );
    return ClientId(id!, secret!);
  }

  Future<AuthClient?> _signInDesktop() async {
    final clientId = _desktopClientId();
    final authClient = await clientViaUserConsent(
      clientId,
      _scopes,
      (url) async =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    );
    await _persistCredentials(authClient.credentials);
    _client = authClient;
    return authClient;
  }

  Future<AuthClient?> _tryRestoreDesktop() async {
    final stored = await _storage.read(key: _storageKey);
    if (stored == null) return null;

    final json = jsonDecode(stored) as Map<String, dynamic>;
    final creds = _credentialsFromJson(json);
    if (creds == null) {
      await _storage.delete(key: _storageKey);
      return null;
    }
    if (!hasRequiredDriveScopes(creds.scopes)) {
      await _storage.delete(key: _storageKey);
      return null;
    }

    final clientId = _desktopClientId();
    final base = http.Client();
    final authClient = autoRefreshingClient(clientId, creds, base);
    _client = authClient;
    return authClient;
  }

  // ── Persistence ────────────────────────────────────────────────────────────

  Future<void> _persistCredentials(AccessCredentials creds) async {
    final json = {
      'tokenType': creds.accessToken.type,
      'accessToken': creds.accessToken.data,
      'expiry': creds.accessToken.expiry.toIso8601String(),
      'refreshToken': creds.refreshToken,
      'idToken': creds.idToken,
      'scopes': creds.scopes,
    };
    await _storage.write(key: _storageKey, value: jsonEncode(json));
  }

  AccessCredentials? _credentialsFromJson(Map<String, dynamic> json) {
    try {
      return AccessCredentials(
        AccessToken(
          json['tokenType'] as String? ?? 'Bearer',
          json['accessToken'] as String,
          DateTime.parse(json['expiry'] as String),
        ),
        json['refreshToken'] as String?,
        (json['scopes'] as List).cast<String>(),
        idToken: json['idToken'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}
