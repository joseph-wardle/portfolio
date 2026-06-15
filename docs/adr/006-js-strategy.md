# ADR-006 — JS strategy and the CSS-only-where-possible rule

## Context
Blowfish shipped a sizable JS bundle (appearance switch, Fuse search, medium-zoom, TW Elements carousel, code-copy, scroll-to-top, jQuery in one override). The brief sets a hard budget: no client-side framework, total shipped JS small (< ~5 KB), deferred, per-component, never render-blocking; anything that can be CSS-only must be. Gate-1 decisions remove search (drop) and the appearance toggle (dark-only).

## Options
1. **Vanilla, per-component, deferred** `<script>`s, loaded only on pages/components that need them; CSS-only for anything achievable without JS.
2. **One small bundled `slate.js`** always loaded.
3. **A micro-framework (Alpine/htmx).** Rejected — violates "no framework," adds weight.

## Decision
**Option 1.** Each interactive component owns a tiny vanilla script, `defer`red, ideally emitted only when the component is present on the page.

Component-by-component:
- **Carousel** — CSS scroll-snap does the scrolling/layout (CSS-only core). ~0.4 KB JS only for prev/next buttons + dot sync; fully usable without JS (native scroll).
- **Before/after `compare`** — `<input type=range>` + `clip-path` driven by a CSS var; ~0.2 KB JS sets `--pos` on input. Keyboard-operable for free (range input).
- **YouTube facade (`youtubeLite`)** — click-to-load; ~0.3 KB swaps the poster button for the iframe on click. No third-party JS until the user clicks.
- **`gameboy`** — keep its existing self-contained module loader (WASM); already framework-free and token-aligned.
- **`figure`/images** — **no JS** (drop medium-zoom lightbox; static portfolio doesn't need it — risk R8 accepted).
- **No** appearance toggle, **no** search, **no** scroll-to-top, **no** jQuery.

## Consequences
- Total first-party JS well under the 5 KB budget; most pages ship ~0 KB (home, about) or one tiny script.
- Everything degrades gracefully without JS (carousel scrolls, compare shows the "after" image, video has native controls).
- Accessibility: carousel nav buttons and dots are real `<button>`s with labels; compare uses a labeled range input; both keyboard-operable. `prefers-reduced-motion` honored in CSS.
- Scripts are component-scoped partials included by the shortcode, so a page with no carousel ships no carousel JS.
