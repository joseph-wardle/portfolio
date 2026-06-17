# ADR-002 — `track` as a taxonomy vs a front-matter param

## Context
Projects are grouped into two tracks, `pipeline` and `graphics`, shown as the two homepage/section groups, ordered by `weight`. Today `track` is a plain front-matter string, queried with `where .Pages "Params.track" "<key>"`. It could instead be a Hugo taxonomy (`tracks`), which would auto-generate `/tracks/pipeline/` term pages.

## Options
1. **Front-matter param (status quo).** Two known keys, queried in templates.
2. **Taxonomy `tracks`.** Hugo builds term lists + `/tracks/<key>/` pages and a `/tracks/` list.

## Decision
**Option 1 — keep the front-matter param.** Add nothing to content.

## Consequences
- No new URLs to design, secure, or SEO (`/tracks/*` term pages would be net-new surface for a 2-value field).
- Ordering stays `weight`-based and fully under template control; taxonomies order by count/title, not weight, without extra work.
- Homepage and `projects` section share one `where … "Params.track"` query; an "untracked" catch-all section guarantees no project is silently dropped (preserved from current `projects/list.html`).
- The existing `[taxonomies]` (tags/categories/authors/series) and `[related]` config — all Blowfish-era and largely unused — get pruned to just what we keep (likely `tags` only, or none). Tracked as a content-adjacent cleanup, additive/removal only, no front-matter rewrites.
