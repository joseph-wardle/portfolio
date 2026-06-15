# Blowfish → Slate migration — discovery audit

Status: **discovery complete, awaiting sign-off (gate 1)**. No production code written yet.
Scope: presentation-layer migration only. Content and IA are (almost) read-only.

---

## 1. Ground truth & environment

| Fact | Value | Source / note |
|---|---|---|
| Local Hugo | `v0.163.1` **standard (NOT extended)** | `hugo version` — no `extended` tag |
| CI Hugo | `0.148.2` **extended** | `.github/workflows/hugo.yaml` env |
| Template system | New (≥0.146) is available on both | Both versions ≥ 0.146 |
| Go available locally | No (`go version` fails) | Matters only for Hugo Modules |
| Deploy host | **GitHub Pages** (Cloudflare in front) | `actions/deploy-pages@v4`, README |
| Build command | `hugo --gc --minify --baseURL … --cacheDir …` | workflow `Build site` step |
| Sass in CI | Dart Sass `1.92.1` installed separately | workflow env + install step |
| Theme wiring | **git submodule** at `themes/blowfish`, selected via `theme = "blowfish"` in `config/_default/hugo.toml` | `.gitmodules`, `hugo.toml` |
| Hugo Modules | **not used** (no `go.mod`, empty `module.toml`) | — |

**Edition consequence:** the local box cannot run Hugo's built-in (libsass) Sass. A migration that depends on `extended` would mean "builds in CI, not locally" — a regression in developer experience. This is the single biggest input to ADR-004.

**Version-mismatch risk:** local `0.163.1` vs CI `0.148.2`. Both run the new template system, but to make "green at every step" meaningful, CI should be pinned to a version the maintainer also runs locally. Flagged in the risk list.

---

## 2. How Blowfish is wired in (theme integration map)

- **Inclusion:** git submodule `themes/blowfish` + `theme = "blowfish"` (line is annotated `# UNCOMMENT THIS LINE`).
- **Config that exists only to drive Blowfish:**
  - `config/_default/params.toml` — almost entirely Blowfish theme options (`colorScheme`, `defaultAppearance`, `autoSwitchAppearance`, `[header]`, `[footer]`, `[homepage]`, `[article]`, `[list]`, `[taxonomy]`, `[term]`, `enableSearch`, `fingerprintAlgorithm`, …). The `[umamiAnalytics]` block is **mis-nested** under `[term]` (indentation bug) — it currently rides along but should move to top level or be dropped.
  - `config/_default/markup.toml` — header comment says "required for the theme to function," but these are real Goldmark settings we must keep (unsafe HTML, passthrough math delimiters, highlight, TOC).
  - `[related]` indices + `[taxonomies]` (tag/category/author/series) in `hugo.toml` — Blowfish-era; the site uses none of these taxonomies in content.
- **Layout overrides of theme partials** (`layouts/`):
  - `partials/header/basic.html` (311 lines) — a near-verbatim copy of the theme header with one change (the `jw.` monogram). Carries a hard maintenance cost: "re-diff after a theme submodule bump."
  - `partials/header/header-option-simple.html`, `header-mobile-option-simple.html` — Resume-as-button override.
  - `partials/home/custom.html` — name-led hero + two track sections; **depends on theme's compiled Tailwind classes and `partial "article-link/card.html"`**.
  - `partials/recent-articles/main.html` — homepage recent list (depends on theme partials).
  - `projects/list.html` — two-track projects index; **depends on `article-link/card.html`**.
- **Theme data consumed:** `themes/blowfish/data/repoColors.json` (language colors for the GitHub shortcode), `data/sharing.json`.
- **i18n:** Blowfish translation strings (`i18n "recent.show_more"`, `i18n "search.*"`, `i18n "a11y.*"`).
- **JS/CSS:** Blowfish ships precompiled Tailwind + its own JS bundle (appearance switch, search, mobile menu, image zoom via `medium-zoom`, code-copy, scroll-to-top). All of `assets/css/custom.css` is written *on top of* that (`jw-*` classes, `--color-*` RGB triples from `schemes/gruvbox.css`).

**Implication:** every custom layout we have is coupled to Blowfish's Tailwind class names and `article-link/card.html`. None of it survives theme removal as-is; all of it must be reimplemented against the new system. Good news: it's a small, well-understood surface.

---

## 3. Shortcode usage census

Grep of `content/` (`{{< … >}}`), with a resolution plan for each:

| Shortcode | Count | Source today | Params actually used | Plan |
|---|---:|---|---|---|
| `figure` | 26 | Blowfish | `src`, `caption` | **Reimplement** as a slate `figure` shortcode (mono uppercase caption, hairline frame). Also drives the markdown image render hook. |
| `github` | 6 | Blowfish | `repo`, `showThumbnail=false` | **Reimplement** as the slate GitHub card. Keep `repo`/`showThumbnail` param names. Needs language-color data (see repoColors) + live `resources.GetRemote` at build. |
| `carousel` | 2 | **site override** (`layouts/shortcodes/carousel.html`, TW Elements / `data-twe-*`) | `images`, `interval` | **Reimplement** as the CSS scroll-snap slate carousel (drops the TW Elements JS dependency). Keep `images`/`interval` (or accept + ignore `interval`). |
| `video` | 0 in content | **site override** (already clean, framework-free) | documented: `src`,`caption`,`poster`,`autoplay`,`loop`,`muted`,`controls` | **Reimplement/restyle** to slate. Not currently used in any committed content but documented in README and part of the 7 slate components. |
| `youtubeLite` | 1 | Blowfish | `id`, `label` | **Reimplement** as the slate YouTube click-to-load facade. **Keep the name `youtubeLite` and params `id`/`label`** (mockup calls it `youtube id/caption`; content is read-only, so we adapt the implementation, not the call). |
| `katex` | 1 | Blowfish | none | **Reimplement** (load KaTeX CSS/JS on pages that opt in). Passthrough math delimiters already configured in `markup.toml`. |
| `gameboy` | 1 | **site override** (self-contained, inline `<style>`/`<script>`, no theme deps) | none | **Keep ~as-is**; fold its inline CSS into the shortcode-scoped styles, retune to slate tokens (already gruvbox-ish). WASM still supplied by CI. |

Slate components in the preview with **no current content usage** that the brief still asks for: **before/after `compare` slider**, **`spec` (at-a-glance) list**, **`callout`**. These are net-new shortcodes — build them, document them, but they touch no existing content. Flag: building three unused shortcodes is mild scope growth justified explicitly by the brief's "seven shortcodes" requirement.

No raw `{{<` will be left unresolved as long as every name above has a layout in the new `_shortcodes/` dir.

---

## 4. Page-kind & section inventory

- **Home** (`/`): rendered by the home template → `home/custom.html`. **There is no `content/_index.md`** — the homepage hero/lede text lives in templates + `params.toml`, not content. (`displayName`/`headline`/`bio`/`links` under `[params.author]`, plus the hero copy duplicated in `home/custom.html`.)
- **Section `projects`** (`/projects/`): `content/projects/_index.md` (title, description, `cascade.showDateOnlyInArticle`). Rendered by `projects/list.html`, grouped by `track`.
- **Project pages** (`/projects/<slug>/`): 7 page bundles — `bobo_pipeline`, `film_grain`, `javelin`, `realtime_raytracer`, `rgb`, `sandwich_pipeline` + each with `featured.{png,jpg}` and nested image dirs.
- **Standalone page `about`** (`/about/`): `content/about.md`.
- **Taxonomies:** declared (`tags`, `categories`, `authors`, `series`) but **only `tags` is populated** in some front matter; no taxonomy/term pages are linked or needed. Currently excluded from sitemap (`[sitemap] excludedKinds`).

Content-bundle conventions in use:
- `index.md` per project; `summary` (card line), `track` (`pipeline`|`graphics`), `weight` (ordering), `tags`, `date`.
- `featured.{png,jpg}` — card/social image (Blowfish auto-discovers `featured.*`).
- Nested resource dirs (`unified_publish/…`, `gallery/…`) referenced by `figure`/`carousel` via page-relative paths.

---

## 5. Invisible dependencies on Blowfish (parity requirements)

Each of these is silently provided today and becomes a rebuild requirement:

- **`<head>` SEO:** title/description, **OpenGraph + Twitter card** (uses `defaultSocialImage`/`featured.*`), **canonical** URL.
- **JSON-LD:** Blowfish emits structured data (person/article). Parity: reproduce or consciously drop (note in ADR).
- **Feeds & robots:** `sitemap.xml` (custom `changefreq`/`priority`, `excludedKinds=[taxonomy,term]`), **RSS `index.xml`** (home output includes `RSS`), **`robots.txt`** (`enableRobotsTXT=true`), home **`JSON`** output (Blowfish search index — see search).
- **Pagination:** `pagerSize=100` (effectively "show all").
- **Taxonomy/term pages:** currently render but unused/unlinked; safe to drop with sign-off (no inbound URLs).
- **Image handling:** `figure` render + Blowfish image optimization (`disableImageOptimization=false`), markdown image render hook, `medium-zoom` lightbox (`nozoom` opt-out class appears in templates).
- **Syntax highlighting:** `markup.toml` `[highlight] noClasses=false` → class-based Chroma CSS the theme supplies; we must ship a Chroma stylesheet.
- **Dark mode:** `defaultAppearance="dark"`, `autoSwitchAppearance=true` + appearance switcher button + localStorage. (ADR-003 decides whether we keep a toggle.)
- **Search:** `enableSearch=true` + home `JSON` output + Fuse.js UI. **Decision needed** — the slate design ships no search; dropping it removes the `JSON` output and search UI. Flag for sign-off.
- **Math:** KaTeX via `katex` shortcode + passthrough delimiters.
- **Code copy / scroll-to-top / reading time / TOC:** theme niceties, mostly disabled in `params.toml` already (`enableCodeCopy=false`, `showReadingTime=false`, `showTableOfContents=false`).
- **Analytics:** `[umamiAnalytics]` (self-hosted Umami at `stats.josephwardle.com`) — currently mis-nested under `[term]`. Decision needed (keep Umami / privacy-friendly / none).

---

## 6. Existing custom CSS / params to preserve or fold in

- `assets/css/custom.css` (220 lines) — hero, CTA buttons, `jw.` monogram, Resume button, role/lede typography. All `jw-*`; conceptually maps 1:1 onto slate components but is written against `--color-*` RGB triples. **Rewrite against slate tokens**, don't port.
- `assets/css/schemes/gruvbox.css` — the gruvbox palette as `--color-*` triples for Blowfish/Tailwind. The slate token set is the spiritual successor (same gruvbox family, different accents: orange `#fe8019` / aqua `#8ec07c` instead of yellow/aqua). Replace, don't keep.
- Hero copy currently lives in **three** places (template `home/custom.html`, `[params.author].headline`, `content/about.md`). The rebuild should pick one source of truth for the homepage hero (template or a `content/_index.md`) and note the others as stale. Additive only; no copy rewrites without sign-off.

---

## 7. Asset & font reality

- **Fonts today:** none self-hosted; Blowfish loads its own (system/Tailwind stack). `custom.css` uses `system-ui` + a mono stack. The slate target needs **three self-hosted, subset woff2 faces**: Bricolage Grotesque (display), Spectral (body), IBM Plex Mono (mono). **The two mockups load these from Google Fonts** — explicitly *not* allowed in the target (no CDN). Acquiring/subsetting these is a `TODO(maintainer)` input (§9).
- **Images:** Hugo image processing already in use (`.Fill`, `.Resize "… webp q75"` in hero/carousel). `[imaging] anchor=Center`. Path forward: a markdown image render hook + `figure` shortcode emitting responsive `webp`/`srcset` with `width`/`height`.
- **JS in play today:** Blowfish bundle (jQuery referenced in `basic.html`'s `highlightCurrentMenuArea` block!), TW Elements carousel, `medium-zoom`, Fuse search, KaTeX, plus our self-contained `gameboy` WASM loader and `video`. Target budget: < ~5 KB of our own deferred JS, per-component.
- **Static:** `static/resume.pdf` (public, linked from nav + hero — **keep path**), `static/roms/*.gb` (gameboy), `static/emulator/*` (CI-built WASM, gitignored locally).

---

## 8. URL surface (baseline for the no-broken-URLs guarantee)

No `public/sitemap.xml` checked in (gitignored), so the baseline must be **generated from the current Blowfish build** before removal and diffed against the new build. Expected published URL set (to be confirmed by building `main` once):

```
/                         (home)
/about/
/projects/
/projects/bobo_pipeline/
/projects/film_grain/
/projects/javelin/
/projects/realtime_raytracer/
/projects/rgb/
/projects/sandwich_pipeline/
/sitemap.xml  /index.xml  /robots.txt
+ tags/* term pages (currently generated, unlinked)  + home index.json (search)
```

Plan: capture the real sitemap from a clean Blowfish build as the frozen baseline artifact, then assert new build ⊇ baseline. Any intentional drop (taxonomy/term, search JSON) is listed explicitly and signed off; any changed path gets an `alias`.

---

## 9. Inputs only the maintainer can provide (`TODO(maintainer)`)

1. **Fonts.** Approved source + license for Bricolage Grotesque, Spectral, IBM Plex Mono (all OFL — self-hostable), or confirmation to subset from the OFL originals. Without these, slate typography can't ship and we cannot honor "no CDN."
2. **Search.** Keep site search, or drop it (slate design omits it)?
3. **Analytics.** Keep Umami (`stats.josephwardle.com`), switch to none, or other?
4. **Dark/light.** Dark-only, or a real toggle? (See ADR-003.)
5. **`track` model.** Front-matter param (today) vs taxonomy (ADR-002)?
6. **Contact email.** `joseph.m.wardle@gmail.com` appears in config and content in cleartext (not obfuscated here); confirm it can stay cleartext in the new footer/hero.
7. **Hugo pin.** Agree the Hugo version to pin in CI **and** run locally (recommend bumping CI to a recent version the maintainer has, e.g. align on `0.163.x`, extended-optional per ADR-004).
8. **CI sequencing.** The emulator-WASM step and submodule checkout in `hugo.yaml` must be updated when the submodule is removed — confirm no other consumer of `themes/blowfish`.

---

## 10. Risk list

| # | Risk | Likelihood | Mitigation |
|---|---|---|---|
| R1 | Local (standard) vs CI (extended) Hugo divergence hides build failures | High | Plain CSS (ADR-004) so neither edition matters; pin one version for both. |
| R2 | Dropping taxonomy/term + search JSON silently removes URLs | Med | Explicit baseline-sitemap diff; list intentional drops; sign-off. |
| R3 | `github` card loses `repoColors` data on theme removal | Med | Vendor a small `data/repoColors.json` (or compute a sane default) before deleting the submodule. |
| R4 | OG/Twitter/canonical/JSON-LD regressions are invisible until shared | Med | Snapshot current `<head>` per page-kind; assert parity. |
| R5 | CI `hugo.yaml` still does `submodules: recursive` after removal → fails or no-ops | Low | Update workflow in the removal commit. |
| R6 | Font subsetting/licensing blocks the whole type system | Med | `TODO(maintainer)` #1 is a hard gate before the type pass. |
| R7 | Hero copy lives in 3 places; rebuild could desync them | Low | Pick one source of truth, mark others stale (no rewrite). |
| R8 | `medium-zoom` lightbox removal changes figure UX | Low | Decide consciously (likely drop; static portfolio); note in ADR-006. |

---

## 11. Recommended implementation path

Theme-less **root `layouts/`** (no `themes/slate` module) with **plain, fingerprinted CSS** (no Node/PostCSS/Tailwind, no required `extended`), **vanilla per-component deferred JS**, Hugo image processing behind a **markdown render hook + `figure`**, dark-only palette, and `track` kept as a **front-matter param**. Build Blowfish and slate in parallel until parity, capture the sitemap baseline, then excise the submodule in one green commit. Full rationale per decision in the six ADRs (next deliverable, gate 2).

This audit ends gate 1. Requesting sign-off before writing ADRs.
