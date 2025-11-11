---
title: "Film Grain Synthesis"
date: 2025-06-18
summary: "Physically modivated film grain synthesis"
tags: ["WGPU", "Rust"]
weight: 5
---

{{< katex >}}

This project is a **WGPU**-based implementation of the physically modivated film grain renderer presented in [Newson et al. (2017)](https://www.ipol.im/pub/art/2017/192/).

It supports both a grain-wise and a pixel-wise algorithm, the more efficient of which are selected automatically based on imput parameters. Importantly, it can run on the **CPU** using **rayon for multithreading**, or on **GPU** using **WGPU compute shaders**, allowing users to pick the best device for their workload.

Across ~7.6k parameter configurations and ~56k total renders, the Rust code outperforms the original C reference almost everywhere: up to **160×** faster on CPU for grain-wise rendering and **68×** faster on GPU for large pixel-wise jobs.

Here are some renders in both black and white as well as color, run on verious [Usplash](https://unsplash.com) images:

{{< carousel images="gallery/*" interval="3000" >}}

{{< github repo="joseph-wardle/film_grain" showThumbnail=false >}}

---

# Details

## 1. Explination of the algorithms

The renderer follows Newson et al.’s pipeline:

1. Load each color plane, normalize to \([0,1]\), and convert to an activity field \(\lambda(x, y)\).
2. From user parameters, derive:
   * Mean radius \(\mu_r\), standard deviation \(\sigma_r\), log-normal parameters when needed.
   * A maximum radius \(r_m\) (absolute or quantile-based).
   * A cell size \(\delta\) for the pixel-wise algorithm.
   * Precomputed Gaussian filter constants and Poisson offsets in output and input space.
3. Share these derived quantities across all backends so that CPU, GPU, grain-wise, and pixel-wise see the same statistical model.

Sampling is reproducible: a splitmix64-style hash takes `(global_seed, stream_id, i, j)` to seed per-cell or per-pixel RNGs, with separate streams for grain centers and cell sampling. Given the same CLI parameters, CPU and GPU produce statistically consistent noise.

### Algorithms

* **Grain-wise CPU**

  For each input pixel with \(\lambda_{ij} > 0\), a Poisson number of grains is drawn; each grain’s footprint in the output is splatted into a bitset:

  * Each output pixel has `lanes = ceil(N / 64)` atomic `u64`s.
  * If a grain covers a pixel in sample `k`, the bit `k % 64` is set in lane `k / 64`.
  * After all splats, bit counts per pixel are divided by `N`.

  The work therefore scales with “number of active grains × footprint”, not with total output pixels.

* **Pixel-wise CPU**

  Work is split by output rows. For each pixel, for each precomputed offset in input space, the code:

  * Finds grid cells whose grains could reach the pixel (using `r_m` and `δ`).
  * For each cell, samples a Poisson number of grains and tests whether any lie within distance `r` of the current pixel, exiting early on the first hit.

  Cost is closer to “total_samples = pixels × \(N\)”, matching the analysis in the original paper.

* **GPU (wgpu)**

  Both algorithms are implemented as WGSL compute shaders:

  * Pixel-wise is a single pass over output pixels (`16×16` workgroups).
  * Grain-wise is a two-pass pipeline: one shader splats grains into a lane-packed bitset, the second reduces bitsets to coverage probabilities.

  Buffers are zeroed on the host, kernels are dispatched, and results are read back through a staging buffer.

### Automatic selection

At the CLI layer, users can force `grain` or `pixel`, or choose `auto`. The selector uses simple thresholds on:

* `sigma_ratio = σ_r / μ_r`
* `rm_ratio = r_m / μ_r`
* sample count `N`

to steer small, low-variance grains to pixel-wise and large or high-variance cases to grain-wise. The benchmark results below effectively validate those thresholds.

### Benchmark grid

A Python harness sweeps:

* Resolutions: \(128^2\), \(256^2\), \(512^2\), \(1024^2\)
* Samples: \(N \in {1,2,4,8,16}\)
* Mean radii: \(\mu_r \in {0.05, 0.1, 0.2, 0.5, 1.0, 2.0}\) pixels
* Variance ratios: \(\sigma_r / \mu_r \in {0, 0.25, 0.5, 0.75, 1.0}\)
* Zoom: \(s \in {1,2,4,8}\)
* Intensity patterns: constant, step, ramp, and natural

Each unique combination is a base configuration. For each base config, every supported `(algorithm, backend)` pair is rendered three times; the median runtime is used. Single-threaded runs cap Rayon at one worker, GPU runs are serialized.

In total this produces about **7,200 base configurations** and **~56,000 individual runs** across:

* C reference
* Rust CPU (single-threaded)
* Rust CPU (multi-threaded)
* Rust GPU

---

## 2. Data and Metrics

For each rendered `(impl, algo, config)` the analysis tooling:

* Builds a unique `config_id` from algorithm, resolution, zoom, grain stats, and intensity pattern.
* Derives:

  * `pixels = width × height`
  * `total_samples = pixels × N`
  * `sec_per_pixel = runtime / pixels`
  * `sec_per_sample = runtime / total_samples`
* Tags size/radius/variance regimes so that scaling trends can be compared.

After cleaning, there are roughly **12k** per-config medians for the C reference and **15k** per Rust variant. That’s enough density to make meaningful scatterplots and to reproduce the grain-vs-pixel regime maps from the paper.

A useful high-level summary is:

| Impl / Algo             | Configs | Median runtime | Median sec / pixel | Median sec / sample |
| ----------------------- | ------- | -------------- | ------------------ | ------------------- |
| C (grain)               | 6 000   | 8.17 s         | 31.8 µs            | 8.0 ns              |
| C (pixel)               | 6 000   | 1.96 s         | 15.4 µs            | 3.8 ns              |
| Rust CPU single (grain) | 7 074   | 0.16 s         | 1.3 µs             | 0.41 ns             |
| Rust CPU multi (grain)  | 7 600   | 0.046 s        | 0.43 µs            | 0.10 ns             |
| Rust GPU (grain)        | 7 560   | 0.25 s         | 3.3 µs             | 0.66 ns             |
| Rust CPU single (pixel) | 7 071   | 3.45 s         | 31.1 µs            | 8.6 ns              |
| Rust CPU multi (pixel)  | 7 599   | 0.37 s         | 2.9 µs             | 0.76 ns             |
| Rust GPU (pixel)        | 7 560   | 0.26 s         | 3.3 µs             | 0.66 ns             |

On log-scale boxplots, the C runs sit 1–2 orders of magnitude slower than Rust CPU for grain-wise rendering. Pixel-wise is more nuanced: multi-threaded CPU and GPU are clear wins, while Rust single-threaded shows a large, slow tail.

---

## 3. Rust vs C Reference

Three scatter plots compare C runtime (x-axis) to Rust runtime (y-axis) for the same configuration, colored by `log10(total_samples)`:

* **Rust CPU single** points cluster near the diagonal for small grain-wise jobs, then fall below it as jobs get larger. For pixel-wise, many points sit above the diagonal: this implementation is often slower than C for that algorithm.
* **Rust CPU multi** sits far below the diagonal almost everywhere. C jobs that take hundreds of seconds drop into the sub-second range.
* **Rust GPU** forms a horizontal band from ~0.2–1 s across three orders of magnitude in C runtime, highlighting a substantial fixed overhead for kernel dispatch and buffer transfers.

Aggregating per-config speedups:

| Impl / Algo             | Median speedup vs C | IQR (q25–q75) |    Min–Max |
| ----------------------- | ------------------: | ------------: | ---------: |
| Rust CPU single / grain |                 21× |     5.9–55.7× |  0.15–386× |
| Rust CPU single / pixel |               0.55× |    0.46–0.68× | 0.34–1.63× |
| Rust CPU multi / grain  |               72.5× |     42.6–160× |   2.1–814× |
| Rust CPU multi / pixel  |                5.8× |      5.0–7.2× |   0.52–16× |
| Rust GPU / grain        |               21.1× |     7.5–40.3× |   1.9–387× |
| Rust GPU / pixel        |                7.2× |     1.4–31.8× |  0.01–810× |

The message is simple:

* Rust **dramatically outperforms** the C reference for grain-wise rendering on both CPU and GPU.
* For pixel-wise, the multi-threaded CPU and GPU implementations are clear wins, but the single-threaded Rust version is slower than C and is best treated as a baseline rather than a target.

Scaling plots (runtime vs `total_samples` on log–log axes) show:

* CPU curves have slopes near 1 for pixel-wise (O(total_samples)) and sub-linear for grain-wise, since grain-wise loops over active grains rather than all pixels.
* GPU curves are almost flat until `total_samples` is large enough to amortize launch/transfer costs; once saturated, they grow slowly with additional work.

---

## 4. Grain-Wise vs Pixel-Wise

For each implementation, I compare algorithms by the per-config ratio

$$
\text{ratio} = \frac{T_\text{grain}}{T_\text{pixel}}
$$

Values >1 mean pixel-wise is faster; <1 means grain-wise is faster.

Across all configs:

* **C reference**: pixel-wise wins in ~66% of cases.
* **Rust CPU (single + multi)**: grain-wise wins in ~89–90% of cases.
* **Rust GPU**: neither dominates; grain-wise wins in ~66%, but ratios cluster close to 1.

When mapped over \((\mu_r, \sigma_r / \mu_r)\) space:

* The **C map** reproduces the regime described in Newson et al.: pixel-wise dominates for small, low-variance grains, and grain-wise becomes preferable only when radii or variance are large.
* The **Rust CPU maps** push the grain-friendly region dramatically downward: with the bitset design and Rayon, grain-wise is already superior around \(\mu_r≈0.1\) with modest variance, and can be 20× faster or more in high-variance regimes.
* The **GPU map** hovers near unity across the grid: both GPU kernels are bandwidth-heavy and end up moving similar amounts of data, so algorithm choice matters less.

Plotting the crossover against `total_samples`:

* C switches from pixel- to grain-dominant around \(10^{6.7}–10^{7}\) samples.
* Rust CPU multi crosses near \(10^{4.5}–10^{4.8}\) samples—about two orders of magnitude earlier.
* GPU crosses roughly at \(10^{4.8}–10^{5}\) samples.

On modern hardware, grain-wise is therefore the **right default** on CPU, and pixel-wise becomes a niche tool for small, low-variance cases or for GPU-heavy workloads.

---

## 5. CPU vs GPU in Rust

To compare backends within Rust I use:

* `speedup_multi_vs_single = T_single / T_multi`
* `speedup_gpu_vs_single = T_single / T_gpu`
* `speedup_gpu_vs_multi = T_multi / T_gpu`

Group medians by size regime:

### Grain-wise

| Size regime | Multi vs single | GPU vs single | GPU vs multi |
| ----------: | --------------: | ------------: | -----------: |
|       Small |            2.8× |         0.22× |        0.06× |
|      Medium |            4.6× |         0.86× |        0.22× |
|       Large |            4.4× |          1.7× |        0.51× |

* Multi-threading buys a solid **3–5×** across the board.
* GPU is almost always slower than CPU multi, and only modestly faster than single-threaded for the largest jobs.
* CPU multi is the fastest grain-wise backend for ~90% of all grain configs.

### Pixel-wise

| Size regime | Multi vs single | GPU vs single | GPU vs multi |
| ----------: | --------------: | ------------: | -----------: |
|       Small |           11.3× |          4.0× |        0.37× |
|      Medium |           12.0× |         18.7× |        1.71× |
|       Large |           12.6× |         67.9× |         7.8× |

* Multi-threading scales almost ideally (11–13×) over the single-threaded version.
* GPU is slower than CPU multi for the smallest pixel-wise jobs, but quickly takes over:

  * Wins ~30% of small configs, ~63% of medium, and ~87% of large.
  * For the biggest jobs, GPU is typically **7–8×** faster than multi-threaded CPU and nearly **70×** faster than single-thread.

Empirically, GPU only becomes clearly worthwhile once `total_samples` exceeds roughly \(10^{5}–10^{6}\). Below that, the overhead-heavy GPU path is beaten by a well-tuned CPU kernel.

---

## 6. Takeaways

**For performance:**

* Rust’s CPU implementation turns the reference C code into a **baseline**, not a competitor:

  * 40–160× faster for grain-wise rendering on typical workloads.
  * 5–7× faster for pixel-wise on multi-threaded CPU and GPU.
* On CPU, **grain-wise rendering is the workhorse**:

  * Faster than pixel-wise in ~90% of configurations.
  * Extends the grain-dominant regime roughly two orders of magnitude toward smaller images compared to the original implementation.
* GPU is a **scaling tool**, not a universal win:

  * Great for very large pixel-wise jobs (up to 68× vs single-threaded CPU).
  * Rarely beats a well-parallelized CPU for grain-wise rendering.

**For design decisions:**

* The bitset-based grain-wise kernel and Rayon parallelism are the main contributors to CPU speedups.
* The wgpu backend shares the same statistical model and RNG layout, so differences come from hardware and memory traffic, not math changes.
* A simple heuristic selector (`choose.rs`) that looks at `σ_r / μ_r`, `r_m / μ_r`, and `N` is enough to choose sensible algorithms and devices in practice:

  * Default: **grain-wise + multi-threaded CPU**.
  * Switch to **pixel-wise + GPU** for very large, high-quality renders.

As a whole, this project shows how to take a physically-based model from the literature, re-express it in modern Rust, and then use systematic benchmarking to reshape both algorithm and device choices around what actually performs well on current hardware.
