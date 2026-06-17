# ADR-004 — Asset pipeline: plain CSS vs Hugo Sass; font self-hosting & subsetting

## Context
Blowfish shipped precompiled Tailwind. We must ship our own styling. Key constraint from the audit: **local Hugo is standard (not extended); CI is extended.** A pipeline that needs `extended` (libsass) builds in CI but not locally. The brief forbids new Node/PostCSS/Tailwind deps without justification and forbids CDN fonts. Maintainer decision at gate 1: **subset the three OFL faces from originals.**

## Options — styling
1. **Plain CSS**, assembled/minified/fingerprinted by Hugo's built-in `resources` (no edition requirement).
2. **Hugo built-in Sass (libsass)** — needs `extended`; fails locally.
3. **Dart Sass** (external binary) — edition-independent but adds a toolchain install locally + in CI.
4. **Node + PostCSS/Tailwind** — heaviest; rejected by brief without strong justification.

## Decision — styling
**Option 1 — plain CSS.** One hand-authored stylesheet (logically split via CSS `@import`-free concatenation through `resources.Concat`, or a single file), piped through `resources.Minify` + `resources.Fingerprint` with **SRI**. Critical CSS inlined only if measurement later justifies it.

Rationale: edition-independent (resolves risk R1), zero new dependencies, and the slate design is small and flat enough that Sass nesting/variables buy little over CSS custom properties (which we already use for tokens). `hugo --gc --minify` then succeeds identically on standard and extended.

## Decision — fonts
- Self-host **Bricolage Grotesque** (display, 700/800 + variable opsz if cheap), **Spectral** (body, 400/500 + 400 italic), **IBM Plex Mono** (mono, 400/500). All OFL.
- **Subset** to the glyph coverage the site uses (Latin + needed punctuation/arrows like ↓ ▸ ⟷, the em-dash, ×) and convert to **woff2**. Commit under `assets/fonts/` with `OFL.txt` per family.
- `@font-face` with `font-display: swap`; **preload** only the display weight used in the LCP (hero `h1`).
- No Google Fonts / no CDN (the mockups' `fonts.googleapis.com` links are dropped).

## Consequences
- Pin one Hugo version for CI **and** local (TODO(maintainer) #7); extended becomes optional, not required.
- Subsetting is a one-time build step done outside Hugo (e.g. `fonttools`/`pyftsubset` or `glyphhanger`), with the resulting woff2 committed — no build-time font tooling in CI. The subsetting recipe is documented in `assets/fonts/README.md`.
- Single fingerprinted CSS file = one cacheable, integrity-checked request; easy to keep lean and audit for unused rules.
- Self-hosted subset woff2 is the largest Lighthouse perf lever (no third-party render-blocking requests; preloaded LCP face).
