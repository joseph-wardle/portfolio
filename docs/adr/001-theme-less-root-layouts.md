# ADR-001 — Theme-less root `layouts/` vs `themes/slate/` module

## Context
Blowfish is a git submodule selected via `theme = "blowfish"`. We are removing it and own the entire presentation layer for a single personal site. Hugo can resolve templates either from root `layouts/` (no theme) or from a `themes/slate/` directory / Hugo Module.

## Options
1. **Root `layouts/`, no theme.** Delete `theme =` and the submodule; all templates live at repo root.
2. **`themes/slate/` local theme.** Keep theme indirection; our code lives under `themes/slate/`.
3. **Hugo Module.** Publish slate as a module and import it. Requires Go toolchain (absent locally) and `go.mod`.

## Decision
**Option 1 — theme-less root `layouts/`.** This is the brief's default recommendation and the idiomatic choice for a single site that will never share its theme.

## Consequences
- Simpler mental model: one place for templates, no `themes/` lookup order to reason about.
- Removes the submodule (`.gitmodules`, `themes/blowfish`) and the `submodules: recursive` need in CI.
- No `go.mod` / module graph; local builds need no Go.
- If the design is ever reused on another site, we'd refactor into a module then — not a cost we pay now.
- New-template-system layout root: `layouts/baseof.html`, `home.html`, `page.html`, `section.html`, with `layouts/_partials/`, `layouts/_shortcodes/`, `layouts/_markup/`.
