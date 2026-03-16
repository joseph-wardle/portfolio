---
title: "Honey Business Pipeline"
date: 2025-11-07
summary: "USD-based pipeline contributions for the BYU animated short Honey Business — unified Maya publishing, multi-environment support, and automated viewport proxies."
tags: ["USD", "TD", "Pipeline", "ShotGrid", "Maya", "Houdini", "Nuke", "Substance"]
weight: 10
---

This project is a custom DCC-agnostic production pipeline I helped build for the short film *Honey Business* by the BYU Center for Animation. It builds upon [Scott Milner's](https://www.linkedin.com/in/sdmilner/) work from [*Student Accomplice*](https://youtu.be/mM5pBgfEhP4?si=76aHx6uTfAjYnhK5) and *Love and Gold* — go read Scott's [pipeline overview](https://scottdmilner.github.io/code-projects/dungeon-pipeline/) for a deep dive into the core systems design. The fantastic [Dallin Clark](https://www.linkedin.com/in/dallin-clark1/) maintained the pipeline solo from October 2024 until I joined in late 2025. You can read about his contributions on his [portfolio](https://dallinclark.com/).

The pipeline is a full production framework built around **USD** and **ShotGrid**, standardizing workflows across **Maya**, **Houdini**, **Nuke**, and **Substance Painter/Designer**. Below is a summary of the systems I built and improved.

---

### Unified Publication

Houdini is at the core of the pipeline — its first-class USD support is powerful and flexible. Many USD layers are generated directly in Houdini, which historically meant Maya assets had to be published twice: once from Maya, then again from Houdini to assemble the final USD structure. I eliminated that second step.

I refactored the Maya publishing framework to construct the expected Houdini asset structure directly from Maya. When an asset is published from Maya, it generates the necessary USD files and directory structure that Houdini expects — no Houdini session required. If artists need to edit the asset in Houdini afterward, this publish step also generates a `.hipnc` file alongside the USD files for that purpose.

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_01.png"
  caption="Maya asset publish tool."
>}}

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_02.png"
  caption="Publication verification."
>}}

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_03.png"
  caption="Generated Houdini node network."
>}}

---

### Multiple Environment Support

*Honey Business* takes place in a single massive outdoor environment, but that environment has distinct areas worked on by different artists. To keep iteration clean and responsibility clear, we split it into independently workable pieces — but the existing pipeline assumed a single environment per shot.

I extended the shot file manager to recognize and load multiple environment assets per shot, and updated the publishing tools to handle environment-specific data correctly. Artists can now work on different parts of the environment in parallel without stepping on each other, while the full scene still assembles correctly.

{{< figure
  src="multi_environment/nodes.png"
  caption="Houdini node network loading multiple environment layers."
>}}

{{< figure
  src="multi_environment/example.png"
  caption="An example shot with one environment in the foreground and another in the background."
>}}

---

### Environmental Proxy Assets

*Honey Business* has a dense outdoor environment — lots of foliage, rocks, and natural elements, much of it generated with point instancers and then scattered throughout the scene. When a bush contains thousands of leaves, simply proxying the leaves wasn't enough to stop viewport performance from tanking.

The fix was to replace point instancers with automatically generated mesh proxies. The process — consuming render geometry, converting to a VDB, then generating a low-res mesh from that VDB — is now fully automated. Animators and layout artists work with frame times improved by **70×** or more in most environments. USD geometry purposes handle the switch transparently: the proxy is used in the viewport, the full-resolution geometry at render time.

{{< figure
  src="proxies/fern_render.png"
  caption="A fern asset rendered in high quality."
>}}

{{< figure
  src="proxies/fern_proxy.png"
  caption="The same fern asset with an automatically generated LOD proxy."
>}}

{{< figure
  src="proxies/forest_render.png"
  caption="A forest environment at full resolution — 6 seconds per frame."
>}}

{{< figure
  src="proxies/forest_proxy.png"
  caption="The same environment with proxy assets — 30 fps."
>}}

{{< github repo="joseph-wardle/bobo-pipeline" showThumbnail=false >}}
