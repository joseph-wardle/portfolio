---
title: "Honey Business Pipeline"
date: 2025-11-07
summary: "USD based pipeline solution for Honey Business"
tags: ["USD", "TD", "Pipeline", "ShotGrid", "Maya", "Houdini", "Nuke", "Substance"]
weight: 1
---

This project is a custom DCC-agnostic production pipeline I helped build for the short film *Honey Business* by the BYU Center for Animation. It buildes upon [Scott Milner's](https://www.linkedin.com/in/sdmilner/) work for the short film's [*Student Accomplice*](https://youtu.be/mM5pBgfEhP4?si=76aHx6uTfAjYnhK5) and *Love and Gold*. Go read Scott's [pipeline overview](https://scottdmilner.github.io/code-projects/dungeon-pipeline/) for an in depth summary of the core systems design. Development of *Honey Business* began in October 2024. The fantastic [Dallin Clark](https://www.linkedin.com/in/dallin-clark1/) was solely responsible for maintaining the pipeline until I was brought in late October of 2025. You can read about his contributions to this project on his [portfolio](https://dallinclark.com/).

The pipeline is a full production framework built around **USD** and **ShotGrid**, designed to streamline asset management, publishing, and scene assembly. It's purpose is to standardize workflows across **Maya**, **Houdini**, **Nuke**, and **Substance Painter/Designer**, enabling artists to focus on creativity while ensuring consistency and efficiency throughout the production pipeline.

This is a summary of the systems and tools I helped build and improve!

### Unified publication

The core of the pipeline revolves around Houdini, as its first class support for USD is powerful, flexible, and approacable. Many of the USD layers are exported directly from Houdini. However, this required assets from Maya to be published twice, once from Maya and once from Houdini. But no longer! I refactored the Maya publishing framework to construct the expected Houdini asset structure directly from Maya. Now, when an asset is published from Maya, it generates the necessary USD files and directory structure that Houdini expects. This eliminates the need for a second publish step in Houdini, streamlining the workflow and reducing potential errors or inconsistencies between the two DCCs. If artists need to edit the asset in Houdini, they can still do so; this publish step generates a `.hipnc` file alongside the USD files for that purpose.

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_01.png"
  caption="Maya asset publish tool"
>}}

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_02.png"
  caption="Publication verification"
>}}

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_03.png"
  caption="Generated Houdini node network"
>}}

### Multiple Environment Support

However, *Honey Business* takes place in a single, massive outdoor environment. This environment does have distinct areas, however. To make iteration and responsibility more clear across production, we split this environment into multiple pieces that can be worked on independantly. However, our existing pipeline assumed a single environment per shot. I extended the pipeline to support multiple environments per shot. This involved updating the shot file manager to recognize and load multiple environment assets, as well as modifying the publishing tools to handle environment-specific data correctly. Now, artists can work on different parts of the environment without interfering with each other, while still maintaining a cohesive overall scene.

{{< figure
  src="multi_environment/nodes.png"
  caption="Houdini node network loading multiple environment layers"
>}}

{{< figure
  src="multi_environment/example.png"
  caption="An example shot with one environment in the foreground and another in the background"
>}}

### Environmental Proxy Assets

*Honey Business* has a massive outdoor environment with a lot of foliage, rocks, and other natural elements. Much of *Honey Business*'s environment contains folaige generated with point instancers, that are then point instanced throughout the scene. When a bush contains thousands of leaves, merely proxying the leaves wasn't enough to stop viewport performance from tanking. Good news: replacing point instancers with automatic proxies is now a thing! Consuming the render geometry, converting to a VDB, then generating a low-res mesh proxy from that VDB is now fully automated. Now animators and layout artists can work with frametimes improved by **70x** or more in most environments. USD geometry purposes make this switch seamless between viewport and render.

{{< figure
  src="proxies/fern_render.png"
  caption="A fern asset rendered in high quality"
>}}

{{< figure
  src="proxies/fern_proxy.png"
  caption="A fern asset with an automatic lod"
>}}

{{< figure
  src="proxies/forest_render.png"
  caption="A forest environment running at a boiling 6 seconds per frame"
>}}

{{< figure
  src="proxies/forest_proxy.png"
  caption="A proxy forest environment running at a cool 30 fps."
>}}


{{< github repo="joseph-wardle/bobo-pipeline" showThumbnail=false >}}
