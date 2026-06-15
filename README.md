# josephwardle.com

Portfolio site for Joseph Wardle — pipeline TD / graphics programmer. Built with [Hugo](https://gohugo.io) using a self-contained, theme-less "slate" presentation layer (one fingerprinted stylesheet, per-component vanilla JS, no framework), deployed to GitHub Pages via `.github/workflows/hugo.yaml` (Cloudflare in front).

## Layout

- `content/projects/<slug>/` — one page bundle per project; images and clips live alongside `index.md`.
- `content/projects/<slug>/index.md` front matter conventions:
  - `summary` — one line rendered on the project card: scope + role + concrete hook.
  - `track` — `pipeline` or `graphics`; controls which section of the projects index the card appears in (`layouts/section.html` → `_partials/tracks.html`). Every project needs one.
  - `weight` — ordering within a track (lower = first, importance not date). Also orders the homepage grid.
- `layouts/` — the entire presentation layer. Hugo's new template system: root `baseof.html`/`home.html`/`page.html`/`section.html`, plus `_partials/`, `_shortcodes/`, and `_markup/` render hooks. No theme.
- `static/resume.pdf` — the public resume linked from the nav and hero. Replace the file, keep the path.
- `resumes/` — Typst sources and tailored exports; not published.

## Video convention

Workflow demos are short (30–45 s) captioned clips embedded with the `video` shortcode:

```
{{< video src="unified_publish/publish_demo.mp4" caption="One-click publish: Maya → headless Houdini → ShotGrid." >}}
```

- Clips under ~20 MB: commit them in the project's page bundle next to `index.md`.
- Anything longer: host externally (YouTube) and embed with the `youtubeLite` shortcode instead (click-to-load facade, no third-party JS until played).
- Encode for web: H.264 MP4, 1080p max, no audio track needed. Videos render muted, looped, `playsinline`, with controls and metadata-only preload by default; pass `autoplay="true"` for hero clips.

## Building

```
hugo --gc --minify
```

Local preview: `hugo server`. The Game Boy emulator WASM (`static/emulator/`) is built in CI from the separate [rgb](https://github.com/joseph-wardle/rgb) repo; locally that page just won't have the emulator unless you copy the artifacts in.
