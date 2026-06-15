# Slate migration — plan & increment order

Feeds from `MIGRATION_AUDIT.md` (gate 1) and `docs/adr/*` (gate 2). Work on branch **`slate-theme`**; never commit to `main`. Build green (`hugo --gc --minify`, no ERROR/WARN about missing layouts) at every commit. Each increment ends with: change summary, build status, open `TODO(maintainer)`, next step.

## Locked decisions (gate 1 + ADRs)
- Theme-less root `layouts/` (ADR-001) · `track` stays a front-matter param (ADR-002) · dark-only (ADR-003).
- Plain fingerprinted CSS, no Node/Sass/extended requirement; subset OFL woff2, self-hosted (ADR-004).
- Render-hook + shared figure partial for responsive webp images (ADR-005).
- Vanilla per-component deferred JS, CSS-only where possible (ADR-006).
- **Drop:** site search, appearance toggle, medium-zoom lightbox, jQuery.
- **Keep:** Umami analytics (re-added correctly, deferred), resume at `/resume.pdf`, all current URLs, `figure`/`github`/`carousel`/`video`/`youtubeLite`/`katex`/`gameboy` shortcodes (+ net-new `compare`/`spec`/`callout`).

## Parity checklist (carried from audit §5/§8)
SEO: title, description, OG, Twitter, canonical, JSON-LD · feeds: `sitemap.xml` (changefreq/priority), RSS `index.xml`, `robots.txt` · Chroma syntax highlighting CSS · KaTeX on opt-in pages · responsive images with width/height · all §8 URLs (new ⊇ baseline; aliases for any change).

## Increment order
1. **Discovery** → `MIGRATION_AUDIT.md`. ✅ (gate 1 signed off)
2. **Plan + ADRs** → this doc + `docs/adr/`. ✅ (gate 2 — requesting sign-off)
3. **Baseline capture + scaffold.** Branch `slate-theme`. Build current Blowfish site once, freeze `sitemap.xml` + per-page `<head>` snapshots as `docs/baseline/`. Then: `baseof.html` + head/header/footer partials + CSS/JS/font asset pipeline + tokens, with **one page (home) rendering green while Blowfish still present in parallel** (slate templates take precedence from root `layouts/`).
4. **Templates.** `home`, `page`, `section`; `_markup/` render hooks (image + link); the two-track homepage and project pages reach visual parity with the slate mockup. Card partial, hero, section rules, footer.
5. **Shortcodes.** Reimplement the seven slate components against real content: `figure`, `github` (vendor `data/repoColors.json` first), `carousel`, `video`, `youtubeLite`, `katex`, `gameboy` retune + net-new `compare`, `spec`, `callout`.
6. **Remove Blowfish.** Only after parity: drop submodule (`.gitmodules`, `themes/blowfish`), `theme =`, Blowfish-only params/config, update `.github/workflows/hugo.yaml` (no `submodules: recursive`, pin Hugo). `grep -ri blowfish` clean. Rebuild green.
7. **Perf & a11y pass.** Responsive images everywhere, font preload, JS trim, Chroma CSS, skip-link, focus-visible, contrast checks, Lighthouse to targets (Perf ≥95 mobile; A11y/BP/SEO =100). Attach results.
8. **Final verification** against brief §7 + short migration summary; remove `temp/`.

## Open `TODO(maintainer)`
- Confirm Hugo pin for CI+local (recommend `0.163.x`, extended optional).
- Confirm `joseph.m.wardle@gmail.com` may stay cleartext in footer/hero.
- Confirm OK to prune unused taxonomies (`categories`/`authors`/`series`; keep `tags`?) and drop unlinked taxonomy/term pages from the URL set.
- Provide nothing for fonts (I subset from OFL) — but confirm weights beyond those listed if any are wanted.
