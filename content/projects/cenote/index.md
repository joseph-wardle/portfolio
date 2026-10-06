---
title: "Cenote"
date: 2026-07-06
summary: "A GPU path tracer in Rust and Vulkan, built to be fast enough for lookdev. Renders inside usdview and Houdini through its own Hydra delegate."
tags: ["Rendering", "Path Tracing", "Vulkan", "Rust", "Slang", "USD", "Hydra", "C++"]
weight: 10
track: graphics
aliases: ["/projects/realtime_raytracer/"]
---

I wanted to understand what a production renderer is actually doing while a lighter waits on it, so I built one. Cenote is a GPU path tracer written in Rust with Slang kernels on Vulkan ray tracing. I kept it thin on purpose, because I wanted it to be really fast at lookdev and highly greppable.

{{< spec >}}
Language: Rust, Slang, C++23
API: Vulkan ray query (KHR only, any RT-capable GPU)
Materials: OpenPBR
USD: Hydra 2 render delegate (usdview, husk, Houdini 22)
Tested against: pbrt-v4
{{< /spec >}}

{{< figure
  src="featured.png"
  caption="A material chart sweeping OpenPBR roughness (left to right) and metalness (back to front). The mirror-sharp front row is where an energy bug would show up first."
>}}

### The preview is the final frame

Most renderers either give a cheap preview, or a slow, correct final. That's fine, but for a lighter, honest and responsive feedback is critical. Cenote has one estimator. Its focused on extreme performance without sacrifising final frame quality.

That one rule made a lot of other decisions for me. Lookdev is usually one asset on a turntable, so the scene has to fit in VRAM, and Cenote fails loudly if it doesn't instead of paging. Materials are a fixed OpenPBR closure with no shader graphs, because lookdev is dialing a material, not wiring one. And anything biased is off the table, since a shortcut in the preview breaks the whole point.

{{< figure
  src="figures/convergence.png"
  caption="1, 8, 64, and 512 samples per pixel. Same estimator the whole way; the noise just goes away."
>}}

### OpenPBR, and keeping energy honest

Cenote implements the full OpenPBR closure: base, specular, coat, fuzz, and glass. Microfacet models lose energy at high roughness, because light that bounces more than once between microfacets just isn't counted. Rough metals come out darker than they should. Cenote compensates using baked lookup tables, and I check that with white furnace tests: put a perfectly white material in a uniform white environment, and it should disappear. If any lobe gains or loses energy, it shows up as a visible sphere. The furnace closes through every lobe.

### Rendering inside usdview and Houdini

A renderer that only runs in its own viewer isn't very useful to a studio, so Cenote has a Hydra 2 render delegate, `hdCenote`, written in C++23. It renders live in `usdview`, and in batch through `usdrecord` and `husk`, and it builds against the USD that ships in Houdini 22. It picks up every UsdLux light, instancing, material bindings, and render settings authored on the stage.

The delegate doesn't link the renderer directly. Inspired by the much larger DreamWork's Arras, it talks to a separate `cenote-server` process over a small change-set protocol on loopback TCP, and reads finished frames out of shared memory. The protocol is defined on both sides, in Rust and in C++, and a test holds the two byte-for-byte identical so they can't drift apart.

### ReSTIR, and taking it back out

ReSTIR has been the talk of the town for the past 6 years, and I started this project wanting to show it could be applied to offline rendering in feature animation contexts. I implemented ReSTIR, the reservoir resampling technique for scenes with lots of lights. I did spatial and temporal reuse, then path reservoirs. Per sample it was better. Then I measured it at equal wall-clock time, and the plain path tracer won by 2.6 to 4.8×. A ReSTIR sample cost five to six times more than it saved.

So I took it out. The implementation and the measurements that retired it live on the [`restir-archive`](https://github.com/joseph-wardle/cenote/tree/restir-archive) branch. It was a lot of work to delete, but the measurement taught me more than the implementation did.

### Testing a renderer

Renderers are hard to test because a wrong image still looks like an image. Cenote leans on a few layers:

- **Perceptual goldens.** Reference renders compared with NVIDIA's [FLIP](https://github.com/NVlabs/flip) metric, which tolerates the tiny floating-point differences a driver update causes but still catches a real regression. A failure writes out a heatmap of where the images differ.
- **An outside opinion.** Comparing Cenote against Cenote will never catch a scene it misreads the same way every time. So for curves, a script renders the same scenes in pbrt-v4 and compares them.
- **Byte-identical sweeps.** Renders are deterministic per build, so before a release I re-render a 19-scene research corpus and compare it byte for byte. One different byte means something moved.

I build with AI coding agents, and this is a big part of why. I can let an agent move fast because the tests will tell me when it's wrong.

### Next to pbrt-v4

The importer reads pbrt-v4 scenes, which gave me the rendering literature's test scenes for free: the Bistro, San Miguel, Veach's ajar door, and more. Each one is checked side by side against pbrt-v4, and anywhere they disagree is written down as a known gap.

Each pair below got about a quarter second on one RTX 4070 Ti SUPER. Cenote is on the left, pbrt-v4's GPU backend on the right. Drag to compare the noise.

{{< compare
  before="figures/equal-time/cornell-cenote.png"
  after="figures/equal-time/cornell-pbrt.png"
  labels="Cenote · 46 spp|pbrt-v4 · 12 spp"
  caption="Cornell box at equal time."
>}}

{{< compare
  before="figures/equal-time/veach-cenote.png"
  after="figures/equal-time/veach-pbrt.png"
  labels="Cenote · 96 spp|pbrt-v4 · 33 spp"
  caption="Veach's multiple importance sampling scene at equal time."
>}}

{{< compare
  before="figures/equal-time/teapot-cenote.png"
  after="figures/equal-time/teapot-pbrt.png"
  labels="Cenote · 31 spp|pbrt-v4 · 11 spp"
  caption="Glass teapot at equal time. The teapot pours clear glass in Cenote because the importer doesn't carry pbrt's absorbing medium over yet."
>}}

| Scene | pbrt-v4 | Cenote | per sample |
|---|---|---|---|
| Cornell box | 21.7 ms/spp | 5.5 ms/spp | 3.9× |
| Veach MIS | 7.6 ms/spp | 2.6 ms/spp | 2.9× |
| Glass teapot | 23.0 ms/spp | 8.0 ms/spp | 2.9× |

### Also in there

- Random-walk subsurface scattering, with textured parameters. The pbrt head scan lands within a percent of the reference.
- Nested dielectrics, so glass can sit inside glass, with a priority system for overlapping solids.
- NanoVDB volumes, including emission for fire.
- Hair and curves.
- Open Image Denoise on the GPU, running directly on the renderer's own buffers. It's a view of the image, never a replacement for it.
- A wavefront architecture: each bounce is a chain of GPU kernels fed by queues, with no CPU readbacks mid-frame.

{{< github repo="joseph-wardle/cenote" >}}
