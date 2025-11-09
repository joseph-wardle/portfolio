---
title: "Film Grain Synthesis"
date: 2025-06-18
summary: "Physically modivated film grain synthesis"
tags: ["WGPU", "Rust"]
weight: 5
---

{{< carousel images="gallery/*" interval="3000" >}}

This project is a **WGPU**-based implementation of the physically modivated film grain renderer presented in [Newson et al. (2017)](https://www.ipol.im/pub/art/2017/192/).

It supports both a grain-wise and a pixel-wise algorithm, the more efficient of which are selected automatically based on imput parameters.

Read more about how I did it below!

---

{{< youtubeLite id="-KWMoVI1ow4" label="Realtime Raytracer demo" >}}

---

# Details
