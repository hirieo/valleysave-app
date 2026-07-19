#!/usr/bin/env bash
# Empaqueta el bundle de `flutter build linux --release` como .deb nativo,
# con integración de icono/menú vía .desktop (ver linux/packaging/valleysave.desktop).
# El tarball genérico (desktop-builds.yml) sigue existiendo aparte para
# distros no basadas en Debian/Ubuntu.
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUNDLE_DIR="${1:-$PROJECT_ROOT/build/linux/x64/release/bundle}"
OUT_DIR="${2:-$PROJECT_ROOT}"

if [ ! -d "$BUNDLE_DIR" ]; then
  echo "No existe el bundle en $BUNDLE_DIR — corre 'flutter build linux --release' primero." >&2
  exit 1
fi

VERSION="$(grep '^version:' "$PROJECT_ROOT/pubspec.yaml" | sed 's/version: *//' | cut -d+ -f1)"
ARCH="$(dpkg --print-architecture)"
PKG_NAME="valleysave"
DEB_FILE="$OUT_DIR/${PKG_NAME}_${VERSION}_${ARCH}.deb"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

PKG_ROOT="$WORK_DIR/pkg"
mkdir -p \
  "$PKG_ROOT/DEBIAN" \
  "$PKG_ROOT/usr/lib/valleysave" \
  "$PKG_ROOT/usr/share/applications" \
  "$PKG_ROOT/usr/share/icons/hicolor/512x512/apps"

cp -r "$BUNDLE_DIR"/. "$PKG_ROOT/usr/lib/valleysave/"
cp "$PROJECT_ROOT/linux/packaging/valleysave.desktop" "$PKG_ROOT/usr/share/applications/valleysave.desktop"
cp "$PROJECT_ROOT/assets/icons/icon.png" "$PKG_ROOT/usr/share/icons/hicolor/512x512/apps/valleysave.png"
mkdir -p "$PKG_ROOT/usr/bin"
ln -s /usr/lib/valleysave/valleysave "$PKG_ROOT/usr/bin/valleysave"

cat > "$PKG_ROOT/DEBIAN/control" <<EOF
Package: $PKG_NAME
Version: $VERSION
Section: games
Priority: optional
Architecture: $ARCH
Maintainer: ValleySave
Depends: libgtk-3-0, libsecret-1-0
Description: Sincroniza tus partidas de Stardew Valley vía Google Drive
 ValleySave copia tus saves de Stardew Valley entre dispositivos usando
 tu propio Google Drive, sin servidores intermediarios.
EOF

dpkg-deb --root-owner-group --build "$PKG_ROOT" "$DEB_FILE"
echo "Generado: $DEB_FILE"
