#!/bin/bash
set -e

NOMBRE=$1
VERSION=$2
ARCH=$3

DEB_FILE="${NOMBRE}_${VERSION}_${ARCH}.deb"
DEB_PATH="repo/packages/${DEB_FILE}"
INDEX="repo/packages.json"

SHA=$(sha256sum "$DEB_PATH" | cut -d' ' -f1)
URL="https://raw.githubusercontent.com/lmontanohernandez8-png/Packe-mixmatrix/main/repo/packages/${DEB_FILE}"

if [ ! -f "$INDEX" ]; then
  echo '{"packages": []}' > "$INDEX"
fi

python3 << EOF
import json

with open("$INDEX", "r") as f:
    data = json.load(f)

nuevo_paquete = {
    "nombre": "$NOMBRE",
    "version": "$VERSION",
    "sha256": "$SHA",
    "url": "$URL"
}

data["packages"] = [p for p in data["packages"] if p["nombre"] != "$NOMBRE"]
data["packages"].append(nuevo_paquete)

with open("$INDEX", "w") as f:
    json.dump(data, f, indent=2)
EOF

echo "Índice actualizado:"
cat "$INDEX"
