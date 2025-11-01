---
title: "Honey Business Pipeline"
date: 2025-06-18
summary: "Physically modivated film grain synthesis"
tags: ["WGPU", "Rust"]
weight: 1
---

This project is a custom DCC-agnostic production pipeline I helped build for the short film *Honey Business* by the BYU Center for Animation. It buildes upon [Scott Milner's](https://www.linkedin.com/in/sdmilner/) work for the short film's *Student Accomplice* and *Love and Gold*. Go read Scott's [pipeline overview](https://scottdmilner.github.io/code-projects/dungeon-pipeline/) for an in depth summary of the core systems design. The fantastic [Dallin Clark](https://www.linkedin.com/in/dallin-clark1/) contributed heavily to the pipeline as well. I was brought in to work on the last half of production.

The pipeline is affectionately known as "Bobo" within the studio. It is a full production framework built around **USD** and **ShotGrid**, designed to streamline asset management, publishing, and scene assembly. It's purpose is to standardize workflows across **Maya**, **Houdini**, **Nuke**, and **Substance Painter/Designer**, enabling artists to focus on creativity while ensuring consistency and efficiency throughout the production pipeline.

This is a summary of the systems and tools I helped build and improve!


TEMPT SUMMARY OF THE PROJECT

**Workflow & Architecture**
- Launchers hand off to the CLI entry point, dynamically loading the requested DCC implementation via `find_implementation` and passing along CLI logging controls.
- OS-specific paths and executable locations are centralized, making the pipeline relocatable across lab Linux and Windows machines; sitecustomize ensures vendored Python packages in `.venv` are available when artists launch from shortcuts.
- The `pipe` package autoloads the appropriate DCC submodule based on the `DCC` environment variable, then configures shared logging so UI scripts can rely on a common stdout/stderr signature.
- ShotGrid is treated as the source of truth: `SGaaDB` wraps the official API, caches per-entity snapshots, and refreshes them in a background thread while exposing strongly typed entity classes for the rest of the tools.
- UI surface area is unified through lightweight Qt helpers and extensible file/version managers, enabling consistent dialogs regardless of host application.
- USD-first publishing is reinforced by shared texture conversion and playblast infrastructure: FFmpeg-based presets for editorial turnovers and an OpenImageIO/txmake/sbsrender pipeline to emit render-ready tex or preview atlases.

**Maya Toolkit**
- The Maya launcher injects USD libraries, OCIO config, module paths, and shelf locations before copying curated shelves to a temp directory for every session.
- `userSetup` auto-enables MayaUSD, sets the studio workspace, wires in timeline markers, and registers the custom USD export chaser that downstream tools expect.
- `MShotFileManager` opens shots through ShotGrid metadata, sets the edit target to a per-shot override layer, brings in cameras/layouts, and rebuilds timeline color markers automatically.
- The publishing framework layers specialized dialogs atop a reusable exporter: assets run a model checker with optional overrides that notify Pipebot, rigs version existing USDs, animation exports drive a Houdini post-process pass, and camera exports capture frame ranges from SG.
- Layout tools mirror the Houdini workflow by authoring USD Xform groups and referencing assets pulled from ShotGrid, keeping Maya layout in lockstep with Solaris conventions.
- Playblast options wrap Mayacapture with HUD templating, camera/depth-of-field toggles, and FFmpeg encoding to studio codecs, giving anim directors consistent deliveries out of box.

**Houdini Toolkit**
- The Houdini launcher asserts OCIO, JOB, Tractor, and USD plugin paths, keeps the RenderMan toolchain reachable, and mirrors the asset gallery database into a per-session SQLite copy that is reconciled back to production under a file lock.
- hsite customizations set trusted desktops, lock asset gallery vars, and run start-up scripts that tag embedded asset context and track scene changes.
- The Houdini shot file manager prompts for department context, wires USD Load Layer HDAs with muted departments, seeds publish nodes, and exports sensible frame ranges per ShotGrid record.
- Solaris automations extend Maya publishes: the animation exporter immediately drives a Houdini hython session that rebuilds load-layer stacks, executes the post-process HDA, and appends the result as a sublayer to the shot’s USD.

**Nuke Toolkit**
- Nuke sessions inherit OCIO, tool search paths, and Nukex defaults through the launcher, aligning color management with the rest of the pipeline.
- The Bobuke menu seeds commonly used gizmos and templates, plus buttons for auto read/write, render layer imports, USD cameras, and project setup so compositors start with standardized graphs.
- Auto-read tools scan the latest date/version folders, derive cadence-aware frame expressions, and build clean Read nodes while adjusting the project frame range to actual plates.
- The write node script tags slates, looks up departmental shot versions from shared JSON, and queries ShotGrid for cut ranges to enforce correct handles when publishing plates.

**Substance Tools**
- Substance Painter launches with OCIO, plugin search paths, and logs piped back into the shared logger; Designer is preconfigured with project settings via a studio .sbscfg.
- Startup plugins add “Bobo — Publish Textures” to the Painter UI, presenting a multi-asset export wizard that cross-references ShotGrid assets and captures export settings per texture set.
- The exporter writes JSON material descriptors, calls the Substance API, then converts results into RenderMan-friendly `.tex` and preview atlases while handling UDIM mosaics and normal-to-height conversion when required.
- Shelf management hooks the project’s painter assets into the app automatically so lookdev artists always see the latest shared resources.
