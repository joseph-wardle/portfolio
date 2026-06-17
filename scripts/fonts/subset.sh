#!/usr/bin/env bash
# Subset + convert the three slate OFL faces to self-hosted woff2 (ADR-004).
#
# One-time/offline build step — the resulting *.woff2 are committed; CI never
# runs this. Re-run only to change weights or glyph coverage. Requires:
#   pip install "fonttools[woff]" brotli
#
# Sources (OFL): github.com/google/fonts
#   ofl/bricolagegrotesque/BricolageGrotesque[opsz,wdth,wght].ttf  (variable)
#   ofl/spectral/Spectral-{Regular,Medium,Italic}.ttf
#   ofl/ibmplexmono/IBMPlexMono-{Regular,Medium}.ttf
#
# Glyph coverage: Basic Latin + Latin-1, General Punctuation (curly quotes,
# en/em dash, ellipsis, bullet, dagger), arrows (↓ → ⟷), geometric shapes
# (▸ ●), star ★, ×, ·, ©, ™.  Adjust UNICODES if the site gains new glyphs.
set -euo pipefail

# Usage (from repo root):  bash scripts/fonts/subset.sh [SRC_DIR] [OUT_DIR]
SRC="${1:-/tmp/fonts-src}"        # dir holding the downloaded .ttf originals
OUT="${2:-static/fonts}"          # where the published woff2 land
UNICODES="U+0020-007E,U+00A0-00FF,U+2010-2027,U+2030-205E,U+20AC,U+2122,U+2190-2199,U+21A9,U+25A0-25FF,U+2605,U+27F6-27FF"
FLAGS=(--flavor=woff2 --layout-features='*' --unicodes="$UNICODES" --desubroutinize)

instance() { # in.ttf  out.ttf  axis=loc...
  local in="$1" out="$2"; shift 2
  python3 -m fontTools.varLib.instancer "$in" "$@" -o "$out" >/dev/null
}
sub() { # in.ttf  out.woff2
  pyftsubset "$1" --output-file="$OUT/$2" "${FLAGS[@]}"
  printf '  %-32s %6s B\n' "$2" "$(wc -c <"$OUT/$2")"
}

echo "Bricolage Grotesque — instancing static weights (opsz=40, wdth=100):"
instance "$SRC/bricolage-var.ttf" "$SRC/bricolage-700.ttf" opsz=40 wght=700 wdth=100
instance "$SRC/bricolage-var.ttf" "$SRC/bricolage-800.ttf" opsz=40 wght=800 wdth=100
sub "$SRC/bricolage-700.ttf" bricolage-grotesque-700.woff2
sub "$SRC/bricolage-800.ttf" bricolage-grotesque-800.woff2

echo "Spectral:"
sub "$SRC/Spectral-Regular.ttf" spectral-400.woff2
sub "$SRC/Spectral-Medium.ttf"  spectral-500.woff2
sub "$SRC/Spectral-Italic.ttf"  spectral-400-italic.woff2

echo "IBM Plex Mono:"
sub "$SRC/IBMPlexMono-Regular.ttf" ibm-plex-mono-400.woff2
sub "$SRC/IBMPlexMono-Medium.ttf"  ibm-plex-mono-500.woff2

# License files (OFL requires bundling)
cp "$SRC/OFL-Bricolage.txt"   "$OUT/OFL-BricolageGrotesque.txt"
cp "$SRC/OFL-Spectral.txt"    "$OUT/OFL-Spectral.txt"
cp "$SRC/OFL-IBMPlexMono.txt" "$OUT/OFL-IBMPlexMono.txt"
echo "Done."
