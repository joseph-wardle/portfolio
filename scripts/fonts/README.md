# Font subsetting

`subset.sh` regenerates the self-hosted woff2 in `static/fonts/` from the OFL
originals (ADR-004). It is a **dev-only, offline step** — the committed woff2 are
what ship; CI never runs this.

## Regenerate

```bash
pip install "fonttools[woff]" brotli
# fetch the OFL originals into /tmp/fonts-src (see header of subset.sh for paths):
#   Bricolage Grotesque (variable), Spectral {Regular,Medium,Italic}, IBM Plex Mono {Regular,Medium}
bash scripts/fonts/subset.sh /tmp/fonts-src static/fonts
```

Edit `UNICODES` in `subset.sh` if the site starts using glyphs outside the
current Latin + punctuation + arrows/shapes coverage, then re-run and commit.
Keep the matching `@font-face` block in `assets/css/slate.css` in sync with the
weights produced here.
