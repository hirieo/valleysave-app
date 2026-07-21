import 'package:flutter_test/flutter_test.dart';
import 'package:valleysave/core/services/update_service.dart';

void main() {
  group('UpdateService.isNewer', () {
    test('detecta versión más nueva por patch', () {
      expect(UpdateService.isNewer('0.1.15', '0.1.14'), isTrue);
    });

    test('detecta versión más nueva por minor', () {
      expect(UpdateService.isNewer('0.2.0', '0.1.14'), isTrue);
    });

    test('detecta versión más nueva por major', () {
      expect(UpdateService.isNewer('1.0.0', '0.9.9'), isTrue);
    });

    test('devuelve false si son iguales', () {
      expect(UpdateService.isNewer('0.1.15', '0.1.15'), isFalse);
    });

    test('devuelve false si la remota es más vieja', () {
      expect(UpdateService.isNewer('0.1.14', '0.1.15'), isFalse);
    });

    test('trata las partes de versión que faltan como cero', () {
      expect(UpdateService.isNewer('0.2', '0.1.15'), isTrue);
    });
  });

  group('UpdateService.selectAssetUrls', () {
    test(
      'no confunde el zip de macOS con el de Windows aunque venga después '
      '(2026-07-21, regresión: antes el último .zip del array ganaba, sin '
      'mirar la plataforma)',
      () {
        final urls = UpdateService.selectAssetUrls([
          {
            'name': 'valleysave-macos.zip',
            'browser_download_url': 'https://example.com/macos.zip',
          },
          {
            'name': 'ValleySave-v0.3.0-windows.zip',
            'browser_download_url': 'https://example.com/windows.zip',
          },
        ]);

        expect(urls.windows, 'https://example.com/windows.zip');
      },
    );

    test('tampoco importa si el zip de macOS viene después', () {
      final urls = UpdateService.selectAssetUrls([
        {
          'name': 'ValleySave-v0.3.0-windows.zip',
          'browser_download_url': 'https://example.com/windows.zip',
        },
        {
          'name': 'valleysave-macos.zip',
          'browser_download_url': 'https://example.com/macos.zip',
        },
      ]);

      expect(urls.windows, 'https://example.com/windows.zip');
    });

    test('selecciona el único .apk sin confundirlo con otros assets', () {
      final urls = UpdateService.selectAssetUrls([
        {
          'name': 'valleysave_0.3.0_amd64.deb',
          'browser_download_url': 'https://example.com/x.deb',
        },
        {
          'name': 'ValleySave-v0.3.0.apk',
          'browser_download_url': 'https://example.com/x.apk',
        },
      ]);

      expect(urls.android, 'https://example.com/x.apk');
    });

    test('el instalador .exe nunca se confunde con el zip portable', () {
      final urls = UpdateService.selectAssetUrls([
        {
          'name': 'ValleySave-Setup-v0.3.0.exe',
          'browser_download_url': 'https://example.com/setup.exe',
        },
        {
          'name': 'ValleySave-v0.3.0-windows.zip',
          'browser_download_url': 'https://example.com/windows.zip',
        },
      ]);

      expect(urls.windows, 'https://example.com/windows.zip');
    });

    test(
      'selecciona el tarball de Linux — antes no había NINGÚN campo linux '
      '(2026-07-21, regresión: installUpdate no hacía nada en Linux)',
      () {
        final urls = UpdateService.selectAssetUrls([
          {
            'name': 'valleysave-linux-x64.tar.gz',
            'browser_download_url': 'https://example.com/linux.tar.gz',
          },
        ]);

        expect(urls.linux, 'https://example.com/linux.tar.gz');
      },
    );

    test('el .deb de Linux NUNCA se selecciona como asset autoactualizable', () {
      final urls = UpdateService.selectAssetUrls([
        {
          'name': 'valleysave_0.3.0_amd64.deb',
          'browser_download_url': 'https://example.com/x.deb',
        },
        {
          'name': 'valleysave-linux-x64.tar.gz',
          'browser_download_url': 'https://example.com/linux.tar.gz',
        },
      ]);

      expect(urls.linux, 'https://example.com/linux.tar.gz');
    });
  });
}
