# ADR-005 — Image processing & responsive-image strategy

## Context
Project pages are image-heavy (26 `figure` calls, 2 carousels, `featured.*` per bundle). Today Blowfish + the site's overrides do ad-hoc `.Fill`/`.Resize "… webp q75"`. The brief mandates responsive `webp`(/avif) with `srcset`/`sizes`, explicit `width`/`height` (no CLS), lazy + async below the fold, and eager + `fetchpriority=high` for the LCP image. Markdown images should go through a render hook, not per-image shortcodes.

## Options
1. **`_markup/render-image.html` render hook + a shared `_partials/figure.html`** that the `figure` shortcode also calls. One responsive-image implementation, two entry points (markdown `![]()` and `{{< figure >}}`).
2. **Per-image shortcodes only.** Rejected — the brief explicitly prefers render hooks for markdown images.
3. **Raw `<img>` in templates.** Rejected — no responsive processing, CLS risk.

## Decision
**Option 1.** A single `image.html` partial takes a resource + context (eager?, sizes) and emits a `<picture>`/`<img>` with `srcset`, `sizes`, intrinsic `width`/`height`, `decoding="async"`, and `loading` / `fetchpriority` chosen by caller. The markdown render hook and the `figure` shortcode both delegate to it.

- **Formats:** `webp` as the primary processed format with the original as fallback. **AVIF deferred** — it ~doubles image-processing build time for marginal bytes; revisit if Lighthouse needs it (logged, not silently dropped).
- **Breakpoints:** a small ladder (e.g. 480 / 768 / 1200 / 1600 w) clamped to the source width (no upscaling), `q80` WebP.
- **LCP:** the homepage hero portrait and project hero/`featured` image render eager with `fetchpriority="high"` and are **not** lazy; everything else is `loading="lazy"`.
- **`sizes`:** set per context (hero portrait fixed-ish; in-prose figures ≈ content width; cards ≈ column width).

## Consequences
- One code path to get right; consistent output for markdown images and explicit figures.
- `width`/`height` always emitted from the processed resource → zero layout shift.
- Carousel reuses the same processing helper (keeps its current `webp q75` behavior, restyled).
- Slightly more Hugo image-cache usage; CI already caches `hugo_cache` between runs.
