---
title: "Film Grain Synthesis"
date: 2025-06-18
summary: "Physically based film grain in Rust, on CPU and GPU. Multithreaded, it's a median 72× faster than the reference C implementation."
tags: ["Rust", "WGPU", "Rendering"]
weight: 50
track: graphics
---

{{< katex >}}

Real film grain is unfortunately way cooler than random noise laid over a picture. It comes from tiny silver crystals scattered through the film, each with its own size and position. [Newson et al. (2017)](https://www.ipol.im/pub/art/2017/192/) model this statistically and give two ways to render it. I reimplemented both in Rust, multithreaded on the CPU with Rayon and as compute shaders on the GPU with wgpu, then benchmarked the whole thing against the paper's C code.

{{< carousel images="gallery/*" interval="3000" >}}

{{< github repo="joseph-wardle/film_grain" showThumbnail=false >}}

### Two ways to draw grain

The **grain-wise** algorithm goes through the image, scatters grains, and stamps each one onto the pixels it covers. Its cost depends on how many grains there are. The **pixel-wise** algorithm goes through every output pixel and asks whether any grain could reach it. Its cost depends on how many pixels and samples there are.

In my grain-wise version, each output pixel keeps a bitset with one bit per Monte Carlo sample. Stamping a grain sets bits, and at the end the pixel's value is just the number of set bits divided by the sample count \(N\). The GPU version does the same thing in two passes, one to stamp grains and one to count bits.

Both algorithms share the same random number layout, so the CPU and GPU produce statistically matching grain from the same seed. Set the mode to `auto` and the tool picks an algorithm from the grain size, its variance, and the sample count.

### Benchmarking it

I wanted to know which algorithm and which device actually win, and where, so a Python harness swept resolution, sample count, grain size, size variance, zoom, and image content. That's about 7,200 configurations and around 56,000 renders across the C reference and three Rust backends, using the median of three runs each.

Here's the speedup over the C reference, per configuration:

| Rust backend / algorithm | Median vs C | Middle half |
|---|--:|--:|
| CPU, multithreaded / grain | 72.5× | 42.6–160× |
| CPU, multithreaded / pixel | 5.8× | 5.0–7.2× |
| GPU / grain | 21.1× | 7.5–40.3× |
| GPU / pixel | 7.2× | 1.4–31.8× |
| CPU, single thread / grain | 21× | 5.9–55.7× |
| CPU, single thread / pixel | 0.55× | 0.46–0.68× |

That last row is honest: my single-threaded pixel-wise code is about half the speed of the C version.

### What I learned from the numbers

**On the CPU, grain-wise is the default now.** In the C reference, pixel-wise wins about two thirds of the time, which matches the paper. In Rust, grain-wise wins about 90% of the time. The bitset and Rayon move the crossover point about two orders of magnitude toward smaller jobs.

**The GPU is a scaling tool, not an automatic win.** Every GPU job pays a fixed cost for dispatch and transfers, so on small jobs it loses to the multithreaded CPU. It only pulls ahead past roughly \(10^5\) to \(10^6\) total samples. For the largest pixel-wise jobs, it's about 7–8× faster than the multithreaded CPU. For grain-wise, it almost never beats it.

**Algorithm choice barely matters on the GPU.** Both kernels end up limited by memory bandwidth and move about the same amount of data, so their times land close together across the whole grid.

So the tool's default is grain-wise on the multithreaded CPU, and it switches to pixel-wise on the GPU for very large, high-quality renders.

As fun as this project was, since I finished it, the much cooler [Spektrafilm](https://github.com/andreavolpato/spektrafilm). I learned a lot on this project, and I still believe this shows my skills in GPU compute and image processing, but I reccomend anyone actually hoping to generate film grain use Spektrafilm instead. It is a truely incredible project.
