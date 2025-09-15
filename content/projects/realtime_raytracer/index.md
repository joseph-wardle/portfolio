---
title: "Real-Time Ray Tracer"
date: 2025-08-15
summary: "Vulkan RT in C++"
tags: ["Rendering", "Ray Tracing", "Vulkan", "C++"]
weight: 1
---

{{< carousel images="gallery/*" interval="3000" >}}

This project is a **Vulkan**-based renderer I developed as part of a three man team in 10 weeks. We built it from the ground up using **C++23** and **Vulkan-Hpp**, with the goal to render fully raytraced scenes in real time.

It supports real-time shadow rays, physically based materials, area lights, denoising, multiple OBJ models with textures, and more. We built this to learn more about C++, hardware accelerated raytracing, Vulkan, and current graphics techniques.

Read more about how I did it below!

---

{{< youtubeLite id="-KWMoVI1ow4" label="Realtime Raytracer demo" >}}

---

# Details

This project is a fully custom real-time ray tracer built from the ground up in **Vulkan**, featuring modern GPU acceleration and physically-based rendering components.

Every layer of the pipeline, from device initialization to final frame presentation, is built with extensible wrapper classes and **Vulkan-Hpp**. The system operates with dynamic scene support, real-time lighting, and interactive controls using **GLFW**.

## Core Architecture

The engine is built around a series of **C++20 modules** that abstract and manage all Vulkan primitives:

- **Device and Queue Management:** Wrapper classes handle physical device selection, logical device creation, and queue family setup with full ray tracing and descriptor indexing support.
- **Memory System:** Custom allocators manage GPU memory for buffers, images, and acceleration structures using Vulkan's dedicated memory requirements and barriers.
- **Swapchain and Surface:** A robust swapchain class handles resizing, re-creation, and per-frame synchronization with optimal present modes and VSync settings.
- **Command Buffers:** A Command pool wrapper deals with command buffer creation and submission.
- **Descriptor Set System:** A flexible descriptor pool and layout manager binds resource sets per frame with intelligent caching and automatic updates.
- **Pipelines:** Custom wrappers for raytracing and compute pipelines, allowing them to be made with a single command.

## Geometry & Instancing

The renderer supports static and instanced geometry loaded directly from .obj and .mtl files. A bottom-level acceleration structure (**BLAS**) is constructed for each unique geometry mesh. If identical geometry is reused multiple times in the scene, the system intelligently instances it at the top level (**TLAS**), reducing memory usage and build time.

Textures are shared across instances using a reference-based texture pool. Repeat textures (UV tiling) are supported natively via per-instance material data, and all loaded textures are managed in VRAM with staging upload on first use.

## Animated Transforms

Objects and lights both support time-varying transforms, including animated translation, scaling, and rotation. These are encoded per frame and updated in Host-visible storage buffers for efficient access during ray traversal and shading. All transform animation is driven by a lightweight keyframe system for flexibility and performance.

## Custom Shaped Lights

Light sources can be defined using any arbitrary mesh loaded from .obj files. Emissive geometry is sampled uniformly across its surface area, and the renderer supports both one-sided and two-sided emission models. Animated lights are handled with the same transform system used for scene objects.

## Ray Tracing Pipeline

The pipeline is fully ray-tracing enabled, using Vulkan’s `KHR_ray_tracing_pipeline` extension. It includes:
- **Primary rays** for visibility and shading
- **Shadow rays** for soft shadow approximation

**Linearly Transformed Cosines (LTCs)** are implemented for area light shading with high efficiency and good visual fidelity. Shadow rays are processed alongside Cook-Torrance shading to allow for biased shadow densoising.

## Denoising and Postprocessing

In a **compute shader**, shadow noise is mitigated using a **bias estimator** and a **basic convolution filter**, providing temporal stability in direct lighting. **Gamma correction and tone-mapping** allow for color to come through. Temporal Anti-Aliasing (TAA) is currently in development to improve motion stability and resolve flickering in high-frequency regions.

## Camera & Interaction

The viewer uses GLFW for windowing and input, with a responsive free-fly c amera system modeled after Unreal Engine navigation. Controls include WASD movement, mouse look, and speed toggling, enabling full exploration of real-time ray-traced scenes.

## Performance & Future Work

The engine currently runs in real time with full per-frame rebuilds of TLAS for animated content, a nd selective updates to BLAS for dynamic geometry are being explored. Future features include:

- Specular reflection rays
- Path-traced indirect lighting
- Multiple importance sampling for emissive geometry
- Deferred or tile-based ray scheduling
- Scene graph editor and USD scene import

## Conclusion

This project demonstrates full-stack Vulkan development with real-time ray tracing, including memory management, descriptor binding, GPU acceleration structures, and physically-based shading. It combines technical depth with rendering accuracy and serves as a flexible platform for experimentation in real-time advanced lighting techniques.

Models provided by [Khronos Group](https://github.com/KhronosGroup/glTF-Sample-Assets/blob/main/Models/Sponza/README.md) 

{{< github repo="DallinClark/RealTimeRaytracer" showThumbnail=false >}}

