---
title: "Game Boy Emulator"
date: 2026-03-15
summary: "A Game Boy emulator in Rust that steps the hardware one machine cycle at a time. You can play it right here in your browser."
tags: ["Rust", "WebAssembly", "Emulation", "wgpu"]
weight: 25
track: graphics
---

**rgb** is a Game Boy (DMG) emulator written in Rust. Pick a `.gb` ROM below and try it.

{{< gameboy >}}

{{< github repo="joseph-wardle/rgb" showThumbnail=false >}}

### What's inside a Game Boy

There are four main pieces. The **CPU** is a Sharp SM83, a cousin of the Z80, running at about 4.19 MHz. The **PPU** draws the 160×144 screen one line at a time, mixing a background, a window, and up to ten sprites per line. The **APU** makes sound from two square waves, a wavetable, and a noise channel. And the **memory bus** connects all of it: every read and write goes through it, whether it's hitting the cartridge, video memory, or a hardware register. Its also the hardest part to model elegantly.

### Getting the timing right

I first wrote this system assuming you can run one CPU instruction, then let the PPU and APU catch up. That works for most games. But a lot of hardware behavior depends on exactly when a read or write lands, and catching up after the fact gets it wrong.

Rgb steps everything one machine cycle (four clock ticks) at a time. Every memory access inside an instruction ticks the rest of the hardware forward before the next one happens, so reads and writes land on the same cycle they would on a real Game Boy.

Because the emulation community is fantastic, there are many hardware test ROMs available. Rgb passes all of Blargg's `cpu_instrs`, `instr_timing`, and `mem_timing` tests, and 49 of the 65 Mooneye acceptance tests. Most of the rest need the PPU timed below the level of a whole scanline, which I haven't built yet, so games that change the scroll in the middle of a line won't look right. That's the next thing on the list.

### Three crates

- **`rgb_core`** is the emulator and nothing else: CPU, PPU, APU, bus, and cartridge mappers (MBC1, MBC3, MBC5). No windows, audio, or files, so it's easy to test on its own.
- **`rgb_frontend`** handles the window, input, palette, and frame pacing, and draws the screen through wgpu. Native and web share the same loop.
- **`rgb_web`** is a thin WebAssembly wrapper that connects the frontend to the browser.

### Running in the browser

Most of the web work was dealing with things the browser doesn't let you do. There's no `std::time::Instant`, so frame pacing uses the browser's clock instead. GPU setup can't block, so it's created asynchronously once the window is ready. Browsers won't play audio until the user does something, so audio starts when you pick a ROM. And since a 144 Hz monitor would otherwise run the game more than twice as fast, the emulator skips frames until a real Game Boy frame's worth of time has passed.
