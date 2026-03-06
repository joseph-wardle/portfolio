---
title: "Real-Time Ray Tracer"
date: 2025-08-15
summary: "A real-time ray tracer built in Vulkan and C++23, with area lights, LTC soft shadows, physically based materials, and a custom denoising pipeline."
tags: ["Rendering", "Ray Tracing", "Vulkan", "C++"]
weight: 2
---

{{< carousel images="gallery/*" interval="3000" >}}

This is a fully ray-traced renderer built in **Vulkan** and **C++23**, developed as a three-person team project over ten weeks. It renders scenes in real time with physically based materials, textured models, area lights with soft shadows via Linearly Transformed Cosines, and a post-process denoising pass.

This was a genuine team effort. I focused on the foundational Vulkan infrastructure: device and context initialization, custom memory allocators, descriptor management, and pipeline setup.

---

{{< youtubeLite id="-KWMoVI1ow4" label="Realtime Raytracer demo" >}}

---

## Core Architecture

The engine is built on extensible C++ wrapper classes organized as **C++20 modules**, using **Vulkan-Hpp** for type-safe API calls. Notable components include:

- **Device & Queue Management:** Abstracts GPU selection and logical device creation, setting up compute and present queues with full ray tracing (`VK_KHR_ray_tracing_pipeline`) and bindless descriptor indexing (`VK_EXT_descriptor_indexing`) support.
- **Memory System:** Custom allocators manage GPU memory for buffers, images, and acceleration structures, with explicit barrier handling for safe memory transfers.
- **Surface & Swapchain:** A robust swapchain manager handles surface creation, format selection, and resize events. Per-frame synchronization via fences and semaphores keeps presentation smooth.
- **Command Buffers:** A wrapper over command pools and buffers simplifies allocation, recording, and submission. Single-use buffers handle setup tasks like data transfers and acceleration structure builds; persistent buffers drive the render loop.
- **Descriptor Sets:** A flexible pool and layout system allocates and updates descriptor sets per frame. Resources are bound with intelligent reuse to avoid overhead — descriptor sets are only reallocated when bindings actually change.
- **Pipeline Abstractions:** High-level classes wrap Vulkan ray tracing and compute pipelines, handling shader module linking, shader binding table setup, and push/specialization constant configuration with a few clean calls.

## Geometry and Instancing

Models are loaded from **OBJ** files with **MTL** materials. Each unique mesh gets its own **Bottom-Level Acceleration Structure (BLAS)** on the GPU. When a mesh appears multiple times, it's instanced in the **Top-Level Acceleration Structure (TLAS)** rather than duplicated — this significantly reduces memory usage and build time for scenes with many repeated objects.

Textures are managed through a shared pool: if multiple objects reference the same texture, it's uploaded once and shared. UV tiling is handled per-instance via material parameters, so the same texture can tile differently across different objects.

## Animated Transforms

All scene objects and lights support time-varying transforms through a lightweight keyframe animation system. Each frame, the CPU updates a host-visible GPU buffer with the latest transform matrices for every entity. Lights use the same system as objects, so animated lights just work.

## Custom Shaped Lights

Beyond standard point lights, the engine treats arbitrary mesh geometries as light sources, sampling emission uniformly across their surface area. Both one-sided and two-sided emission are supported — useful for thin objects like lampshades. The same keyframe system drives light transforms, so lights can move and rotate like any other object in the scene.

## Ray Tracing Pipeline

The pipeline is built on Vulkan's `VK_KHR_ray_tracing_pipeline` and `VK_KHR_acceleration_structure` extensions. Each frame traces two types of rays:

- **Primary Rays:** Cast from the camera per pixel to find visible surfaces and compute direct shading using a Cook–Torrance BRDF.
- **Shadow Rays:** Spawned from hit points toward light sources to determine visibility for soft shadows.

Area light shading uses **Linearly Transformed Cosines (LTC)**, which produces high-quality soft lighting analytically — no need for dozens of shadow samples. Shadow rays are traced in parallel with surface shading, so both results are available together for the denoiser.

## Denoising and Post-Processing

A **compute shader** denoiser runs after ray tracing to clean up shadow noise. It applies a convolution filter with a bias correction estimator, followed by gamma correction and tone mapping.

## Camera and Interaction

The viewer uses GLFW for windowing and input, with a free-fly camera modeled after Unreal Engine navigation: WASD movement, mouse look, and speed toggling.

## Performance and Future Work

The engine runs at real-time frame rates on modern GPUs. It uses fast-build flags for acceleration structures and allows TLAS updates for moving objects. Full BLAS refitting for dynamic geometry is a natural next step, along with:

- Specular reflection rays
- Path-traced indirect lighting
- Multiple importance sampling (MIS)
- Deferred/tile-based ray scheduling
- USD support

Models provided by [Khronos Group](https://github.com/KhronosGroup/glTF-Sample-Assets/blob/main/Models/Sponza/README.md)

{{< github repo="DallinClark/RealTimeRaytracer" showThumbnail=false >}}
