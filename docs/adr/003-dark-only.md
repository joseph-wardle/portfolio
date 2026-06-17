# ADR-003 — Color scheme: dark-only vs light/dark toggle

## Context
The site is dark-default today with Blowfish's appearance switcher (`defaultAppearance="dark"`, `autoSwitchAppearance=true`, localStorage + a toggle button). The slate palette and both mockups are designed dark. Maintainer decision at gate 1: **dark-only**.

## Options
1. **Dark-only.** One palette; no toggle.
2. **Light/dark toggle.** Parallel light palette + toggle + anti-flash inline script.

## Decision
**Option 1 — dark-only.**

## Consequences
- Color tokens are a single `:root` set (slate gruvbox-dark). No `.dark`/`.light` duplication, no `prefers-color-scheme` branching, no FOUC-prevention JS.
- `<meta name="color-scheme" content="dark">` set so form controls/scrollbars render dark; `<html>` needs no theme class.
- Removes the appearance-switcher button, its JS, and the `autoSwitchAppearance` param.
- If a light mode is ever wanted, it's a clean additive follow-up (add tokens under a media query / class) — not blocked by this decision.
- Accessibility: must still verify AA contrast for `--dim` (#a89984) and `--faint` (#7c6f64) on `--bg` (#1d2021); faint is reserved for non-essential labels/metadata, never body text.
