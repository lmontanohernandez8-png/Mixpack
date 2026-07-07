#!/bin/bash
set -e

NOMBRE=$1
VERSION=$2
ARCH=$3
CARPETA=$4

BUILDDIR="dist/${NOMBRE}_${VERSION}_${ARCH}"
mkdir -p "$BUILDDIR/DEBIAN"
mkdir -p "$BUILDDIR/data/data/com.mixmatrix/files/usr/bin"

for archivo in "$CARPETA"/*; do
  if [ -f "$archivo" ] && [ -x "$archivo" ]; then
    cp "$archivo" "$BUILDDIR/data/data/com.mixmatrix/files/usr/bin/"
  fi
done

chmod -R 755 "$BUILDDIR/data/data/com.mixmatrix/files/usr/bin/"

cat > "$BUILDDIR/DEBIAN/control" << EOF
Package: $NOMBRE
Version: $VERSION
Architecture: $ARCH
Maintainer: MixMatrix Project
Description: $NOMBRE compilado para entorno MixMatrix (Android ARM64)
EOF

dpkg-deb --build --root-owner-group "$BUILDDIR" "dist/${NOMBRE}_${VERSION}_${ARCH}.deb"

echo "SHA256 generado:"
sha256sum "dist/${NOMBRE}_${VERSION}_${ARCH}.deb"
