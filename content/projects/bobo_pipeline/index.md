---
title: "Honey Business Pipeline"
date: 2025-11-07
summary: "Pipeline work on a forest full of point-instanced foliage. Swapping whole collections for proxies got animators up to 70× faster viewports."
tags: ["USD", "Pipeline", "ShotGrid", "Maya", "Houdini", "Python"]
weight: 15
track: pipeline
---

*Honey Business* is a BYU Center for Animation short, and it was my first time working on a real production pipeline. The pipeline itself has a long history. It builds on [Scott Milner's](https://www.linkedin.com/in/sdmilner/) work from [*Student Accomplice*](https://youtu.be/mM5pBgfEhP4?si=76aHx6uTfAjYnhK5) and *Love and Gold* (his [pipeline overview](https://scottdmilner.github.io/code-projects/dungeon-pipeline/) is a great read), and the fantastic [Dallin Clark](https://www.linkedin.com/in/dallin-clark1/) kept it running solo from October 2024 until I joined in late 2025. You can read about his work at [his portfolio website](https://dallinclark.com/). I was solely responsible for it starting in January of 2026.

It's built around USD and ShotGrid, across Maya, Houdini, Nuke, and Substance. 

### A forest you can actually animate in

The film takes place in a dense forest: ferns, bushes, rocks, and a lot of leaves, most of it scattered with point instancers. A single bush can hold thousands of leaves, and once a few hundred bushes landed in a shot, the viewport wasn't particularly pleased. Proxying the individual leaves didn't solve the issue.

After much testing, hmming and haaing, the answer was to stop proxying the pieces and replace the whole collection. Each asset's render geometry gets converted to a VDB, and a low-res mesh is built from that, so one simple proxy stands in for the entire bush. That cut draw calls dramatically. USD purposes do the switching, so the proxy shows in the viewport and the full geometry shows up at render time, and nobody has to think about it. It's fully automatic, and animators and layout artists were blessed with frame times up to 70× faster in most environments.

{{< compare
  before="proxies/fern_render.png"
  after="proxies/fern_proxy.png"
  labels="Full resolution|Proxy"
  caption="A fern and its generated proxy. Drag to compare."
>}}

{{< figure
  src="proxies/forest_render.png"
  caption="A forest environment at full resolution: about 6 seconds a frame."
>}}

{{< figure
  src="proxies/forest_proxy.png"
  caption="The same environment with proxies: 30 fps."
>}}

### Publishing once instead of twice

Houdini is the heart of this pipeline, and a lot of the USD gets built there. That meant Maya assets had to be published twice: once from Maya, then again from Houdini to assemble the final USD. The double publish step required artists open pultiple heavy pieces of software, and remember to publish both versions.

I reworked the Maya publisher to build the structure Houdini expects directly, without a Houdini session. It writes the USD files and folders, plus a `.hipnc` alongside them in case an artist wants to open the asset in Houdini afterward.

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_01.png"
  caption="The Maya asset publish tool."
>}}

{{< figure
  src="maya_publish_asset_tool/maya_publish_asset_tool_03.png"
  caption="The Houdini network it generates."
>}}

### More than one environment per shot

The forest is one huge environment, but different artists own different parts of it. To let them work in parallel, we split it into pieces, and then found out the pipeline assumed one environment per shot. I taught the shot file manager to load several environments at once and updated the publish tools to match, so each artist can work on their corner of the forest and the shot still assembles the whole thing.

{{< figure
  src="multi_environment/example.png"
  caption="A shot with one environment in the foreground and another behind it."
>}}

{{< github repo="DallinClark/bobo-pipeline" showThumbnail=false >}}
