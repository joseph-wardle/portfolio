---
title: "Real-Time Ray Tracer"
date: 2025-08-15
summary: "Vulkan RT in C++"
tags: ["Rendering", "Ray Tracing", "Vulkan", "C++"]
weight: 1
---

{{< carousel images="gallery/*" interval="3000" >}}

This project is a custom **Vulkan**-based ray tracing renderer built from scratch in modern **C++23** (using the **Vulkan-Hpp** C++ bindings), designed to render fully ray-traced 3D scenes in real time. The engine’s features include real-time soft shadows, physically based materials, textured models, area lights, and a basic denoising pipeline. We undertook this project to deepen our knowledge of modern C++ and Vulkan’s hardware-accelerated ray tracing, while exploring current graphics techniques in real-time rendering.

I developed this project as part of a three-person team over a 10-week span. This was truly a team effort with no rigidly defined roles—each of us contributed to all aspects of the engine. I implemented many of the foundational Vulkan systems (device/context initialization, custom memory allocators, descriptor management, and pipeline setup) to establish a solid low-level infrastructure. I also collaborated on higher-level features like the ray tracing shaders and denoising, ensuring that all components integrated smoothly.

Read more about how I did it below!

---

{{< youtubeLite id="-KWMoVI1ow4" label="Realtime Raytracer demo" >}}

---

# Details

This project is a fully custom real-time ray tracer built from the ground up in **Vulkan**, featuring modern GPU acceleration and physically-based rendering components.

Every layer of the pipeline, from device initialization to final frame presentation, is built with extensible wrapper classes and **Vulkan-Hpp**. The system operates with dynamic scene support, real-time lighting, and interactive controls using **GLFW**.

## Core Architecture

The engine is built upon extensible C++ classes (organized as **C++20 modules**). We leveraged **Vulkan-Hpp** for type-safe Vulkan calls and created wrapper classes to manage Vulkan objects more easily. Notable components include:

- **Device & Queue Management:** Abstracted selection of the physical GPU and creation of the logical device with all required extensions. This system sets up compute and present queues with full ray tracing (`VK_KHR_ray_tracing_pipeline`) and bindless descriptor indexing (`VK_EXT_descriptor_indexing`) support.
- **Memory System:** Custom allocators manage GPU memory for buffers, images, and acceleration structures. We handle Vulkan memory requirements explicitly and use appropriate barriers for safe memory transfers.
- **Surface & Swapchain:** A robust swapchain manager deals with the Vulkan surface, swapchain creation, and resizing. It automatically chooses optimal surface formats and present modes and recreates the swapchain on window resizes. Per-frame synchronization (fences/semaphores) is handled to ensure smooth presentation.
- **Command Buffers:** A wrapper for command pools and buffers simplifies command buffer allocation, recording, and submission. We use a single-use command buffer pattern for setup tasks (like transferring data or building acceleration structures) and persistent command buffers for the rendering loop.
- **Descriptor Sets:** A flexible descriptor pool and layout system allows us to allocate and update descriptor sets per frame. Resources (buffers, images, acceleration structures) are bound through this system with intelligent re-use and caching. For example, we update uniform buffers and descriptor sets each frame for the latest camera and transform data, and reuse descriptor sets when possible to avoid overhead.
- **Pipeline Abstractions:** We created high-level classes for Vulkan ray tracing pipelines and compute pipelines. This encapsulation allows us to configure raygen, miss, and hit shaders (for ray tracing) or post-processing compute shaders with just a few calls, keeping pipeline creation code manageable. The pipeline classes also handle linking shader modules, setting up shader binding tables, and configuring push constants and specialization constants as needed.

## Geometry & Instancing

We support loading of multiple models from **OBJ** files along with their **MTL** materials. For each unique mesh, the engine builds a **Bottom-Level Acceleration Structure (BLAS)** on the GPU. If a mesh appears multiple times in the scene,  the engine will instance that mesh in the **Top-Level Acceleration Structure (TLAS)**, drastically reducing memory usage and acceleration structure build time when many copies are present.

Textures are efficiently managed through a shared texture pool. If multiple objects use the same texture, it is loaded into GPU memory only once and referenced by all relevant materials. We also support texture repetition (UV tiling) via per-instance material parameters (each instance can scale UVs differently). 

## Animated Transforms

All scene objects and lights can be animated with time-varying transforms. We implemented a lightweight keyframe animation system to drive translations, rotations, and scaling for any entity. Each frame, the CPU updates a host-visible GPU buffer with the latest transform matrices for every object and light. 

## Custom Shaped Lights

In addition to standard point or directional lights, our engine allows arbitrary mesh geometries to act as light sources. We sample light emission uniformly across the surface area of these meshes. The renderer supports both one-sided emission (light only emits from the front face of polygons) and two-sided emission (light emits from both sides of a polygon surface), which is useful for thin objects like lampshades. Animated lights are handled seamlessly by the same transform and keyframe system used for objects, so lights can move or change over time during the rendering.

## Ray Tracing Pipeline

Our rendering pipeline is fully ray-traced, built on Vulkan’s `VK_KHR_ray_tracing_pipeline` and `VK_KHR_acceleration_structure` extensions. The ray tracer handles two types of rays in each frame:

- **Primary Rays:** Cast from the camera for each pixel to determine visible surfaces and perform shading (direct lighting calculation on hit surfaces).
- **Shadow Rays:** Secondary rays spawned from hit points toward light sources to determine lighting visibility and produce soft shadows.

To efficiently shade area lights, we implemented **Linearly Transformed Cosines (LTC)**. Using LTC, our area lights produce high-quality soft lighting without requiring dozens of shadow samples.

Notably, we trace shadow rays in parallel with computing the surface shading (which uses a Cook–Torrance BRDF for materials). By doing so, we can combine the shadow information with the material shader and prepare it for a denoising step.

## Denoising and Postprocessing

A simple denoising **compute shader** runs after ray tracing to clean up the output. Our denoiser uses a **basic convolution filter** combined with a **bias correction estimator** to reduce shadow noise. We also apply **gamma correction** and **tone mapping** at this point.

## Camera & Interaction

The viewer uses GLFW for windowing and input, with a responsive free-fly camera system modeled after Unreal Engine navigation. Controls include WASD movement, mouse look, and speed toggling, enabling full exploration of real-time ray-traced scenes.

## Performance & Future Work

Even with all rays and shading computed on the fly, the engine runs at real-time frame rates on modern GPUs. We take advantage of GPU acceleration structure build features (using fast build flags and allowing updates), and in the future we plan to use refitting for moving objects to avoid full rebuilds where possible. We’re also exploring partial rebuilds of BLAS for truly dynamic geometry (if any objects deform or change topology).

Looking forward, there are several features and optimizations we identified to push the project further:

- Specular Reflection Rays
- Path-Traced Indirect Lighting
- Multiple Importance Sampling (MIS)
- Deferred/Tile-Based Ray Scheduling:
- USD Support

## Conclusion

Building this real-time ray tracer was a challenging but rewarding experience that gave me full-stack exposure to graphics engine development. Completing this project significantly deepened my understanding of Vulkan’s API and modern rendering methods, especially the intricacies of GPU ray tracing and how to optimize it for interactive performance.

We successfully created a flexible graphics engine that demonstrates advanced lighting and rendering techniques in real time. The project served as an invaluable learning platform: I gained hands-on experience with low-level GPU programming, learned to integrate complex subsystems (like windowing, input, and asset loading) into a cohesive application, and improved my ability to collaborate in a team on a large codebase. This ray tracer provides a solid foundation for me to continue experimenting with cutting-edge real-time rendering features in the future.


Models provided by [Khronos Group](https://github.com/KhronosGroup/glTF-Sample-Assets/blob/main/Models/Sponza/README.md) 

{{< github repo="DallinClark/RealTimeRaytracer" showThumbnail=false >}}
