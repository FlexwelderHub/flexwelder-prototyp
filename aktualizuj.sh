#!/usr/bin/env bash
# Aktualizuje opublikowany prototyp: kopiuje index.html ze źródła, pokazuje zmiany, robi commit z datą i push.
set -euo pipefail

SRC="$HOME/Projects/FlexWelder/makiety-poprawione/publikacja/index.html"
cd "$(dirname "$0")"

if [ ! -f "$SRC" ]; then
  echo "Brak pliku źródłowego: $SRC" >&2
  exit 1
fi

# Strona jest publiczna: nie publikuj, jeśli w pliku są prawdziwe dane ośrodka.
if grep -niE "e0c|leszek" "$SRC"; then
  echo "Znaleziono zakazane ciągi (wyżej). Przerywam, nic nie opublikowano." >&2
  exit 1
fi

cp "$SRC" index.html

if git diff --quiet -- index.html; then
  echo "Brak zmian w index.html, nie ma czego publikować."
  exit 0
fi

git diff --stat -- index.html
git add index.html
git commit -q -m "Aktualizacja prototypu $(date +%F)"
git push origin main
echo "Wypchnięto. Strona odświeży się po buildzie GitHub Pages (zwykle do 1 min)."
