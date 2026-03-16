---
title: "Game Boy Emulator"
date: 2026-03-15
summary: "A cycle-accurate DMG emulator written in Rust — with a WebAssembly build you can play right here in the browser."
tags: ["Rust", "WebAssembly", "Emulation", "wgpu"]
weight: 1
---

**rgb** is a cycle-accurate DMG emulator written in **Rust**. Pick a `.gb` ROM below to try it out.

{{< gameboy >}}

{{< github repo="joseph-wardle/rgb" showThumbnail=false >}}

---

## How the hardware works

The DMG is built around four subsystems:

- **CPU** — a Sharp LR35902, related to the Z80 family, clocked at 4,194,304 Hz. It fetches, decodes, and executes instructions using an internal register set (A, B, C, D, E, H, L, F, SP, PC) and a set of condition flags.
- **PPU** — the pixel processing unit. It renders the 160×144 screen one scanline at a time over 70,224 T-cycles per frame (~59.7 Hz), mixing a background layer, a window layer, and up to ten sprites per line, all controlled by memory-mapped registers.
- **APU** — four audio channels: two square-wave pulse generators with configurable duty cycle and envelope, a wavetable channel, and a linear feedback shift register for noise. All four mix to stereo output.
- **Memory bus** — the arbiter that connects everything. Every memory read and write passes through it, including cartridge ROM and RAM, the PPU's tile and attribute tables, OAM (sprite data), and all hardware registers.

---

## The accuracy challenge

The obvious approach to emulation is to run a complete CPU instruction, then catch up the PPU and APU to match. It works for most games. But some games write to PPU registers mid-scanline, change the scroll position between lines, or read hardware registers at a cycle-specific moment, and they depend on that window being exact.

rgb steps the CPU **one M-cycle at a time** (four T-cycles, the smallest schedulable unit), advancing the PPU and APU in lockstep with every micro-operation. Memory accesses happen at the exact cycle they would on real hardware. The bus interleaving is accurate enough to pass Blargg's `cpu_instrs` and `instr_timing` test ROMs and to handle games that rely on mid-scanline effects.

---

## Architecture

The codebase is split into three crates with a strict dependency hierarchy:

**`rgb_core`** is the pure emulator. It contains the CPU, PPU, APU, memory bus, and cartridge mapper implementations (ROM-only, MBC1, MBC3, MBC5). It has no platform dependencies whatsoever — no windowing, no audio, no filesystem. Everything goes in, everything comes out through a clean API.

**`rgb_frontend`** is the rendering and windowing layer shared across platforms. It uses **winit** for the window and event loop, and the **pixels** crate (wgpu-backed) for GPU-accelerated display. Frame pacing, input mapping, palette conversion, and an `AudioSink` trait that platform crates implement all live here. Native and web builds share the same loop structure; only a handful of `#[cfg(target_arch = "wasm32")]` guards handle the differences.

**`rgb_web`** is a thin `cdylib` that wires `rgb_frontend` to the browser via **wasm-bindgen**. It implements `AudioSink` using the Web Audio API's `ScriptProcessorNode`, and provides the single exported `start(rom: &[u8])` function that JavaScript calls after the user picks a ROM file.

This separation means `rgb_core` is trivially testable in isolation and has no exposure to platform quirks. The frontend knows nothing about cartridge formats; the core knows nothing about canvases.

---

## Rendering pipeline

The PPU writes shade indices (values 0–3, one per pixel, for the four DMG grey levels) into a 160×144 framebuffer as it processes each scanline. After `step_frame()` completes, the frontend converts these to RGBA using a configurable four-colour palette and writes them into a wgpu texture via the pixels crate, which handles GPU-accelerated scaling and letterboxing to the window size. The classic green LCD palette is the default.

On native, a `FramePacer` sleeps the thread for whatever remains of the 16.743 ms frame budget after each frame. On the web, `requestAnimationFrame` fires at the monitor's refresh rate — potentially 60, 120, or 144 Hz — so the pacer instead checks elapsed time using `js_sys::Date::now()` and skips emulation when a full frame period hasn't passed yet, keeping the emulator at the correct speed regardless of display Hz.

---

## WebAssembly

The web build compiles to a WASM module via `wasm-pack`. Most of the work was in handling the constraints that don't exist on native:

- **No `std::time::Instant`** — the browser sandbox doesn't expose a monotonic clock. The frame pacer switches to `js_sys::Date::now()` for wall-clock timing.
- **No synchronous GPU init** — `Pixels::new()` blocks on native but is unavailable on WASM. The GPU surface is created with `Pixels::new_async()`, awaited inside a `spawn_local` microtask that fires from winit's `resumed()` callback.
- **AudioContext autoplay policy** — browsers block audio until a user gesture. The Web Audio context is opened inside the file-picker's `change` event, which satisfies the gesture requirement.
- **Canvas placement** — rather than letting winit append a new canvas to `document.body`, the shortcode pre-places a `<canvas id="rgb-canvas">` at the right spot in the article, and winit attaches to it by ID.

The result is the same Rust emulator code running in the browser at native speed, with no plugins required.
