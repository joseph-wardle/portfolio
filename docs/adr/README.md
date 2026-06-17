# Architecture Decision Records — Slate migration

Short, append-only records for the Blowfish → Slate presentation-layer migration.
Format: context → options → decision → consequences. See `MIGRATION_AUDIT.md` (repo root) for the discovery that feeds these.

| ADR | Title | Decision |
|---|---|---|
| [001](001-theme-less-root-layouts.md) | Theme-less root `layouts/` vs `themes/slate` module | Theme-less root layouts |
| [002](002-track-param-vs-taxonomy.md) | `track` as taxonomy vs front-matter param | Keep front-matter param |
| [003](003-dark-only.md) | Dark-only vs light/dark toggle | Dark-only |
| [004](004-asset-pipeline-and-fonts.md) | Plain CSS vs Hugo Sass; font self-hosting | Plain CSS; subset OFL woff2 |
| [005](005-image-pipeline.md) | Responsive image strategy | Render hook + shared figure partial, webp `srcset` |
| [006](006-js-strategy.md) | JS strategy | Vanilla, deferred, per-component; CSS-only where possible |

Status of all: **Accepted** (maintainer sign-off at gate 2 — see migration plan at end of `006`/the plan section below).
