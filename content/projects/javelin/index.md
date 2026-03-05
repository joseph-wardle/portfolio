---
title: "Javelin Physics Engine"
date: 2025-10-01
summary: "A real-time rigid body simulator in C++23 — dual-BVH broad phase, persistent manifolds, warm-started PGS contacts, sleep/wake islands, and XPBD distance constraints."
tags: ["C++23", "Physics", "Simulation", "OpenGL", "Rendering", "Tracy"]
weight: 2
---

Javelin is a real-time rigid body physics engine written from scratch in **C++23**, using named modules throughout. It handles spheres and oriented boxes, resolves contacts with a warm-started projected Gauss-Seidel solver, supports XPBD-style distance constraints, and uses sleep/wake island management for stable large stacks. Broad phase uses a dual-BVH design with deterministic parallel dispatch, and a custom OpenGL renderer provides both scene output and deep debug overlays. A text scene format (`.jvscene`) keeps authoring and inspection simple without editor tooling.

{{< figure
  src="demo/5k_bodies.png"
  caption="Large-scale rigid body scene rendered from an offline deterministic capture run."
>}}

{{< youtubeLite id="YOUR_DEMO_VIDEO_ID" label="Javelin simulation demo" >}}

---

### Architecture

The engine runs a fixed 60 Hz physics loop on a dedicated `std::jthread`. The render thread reads simulation state through a triple-buffered **pose channel**: physics writes authoritative transforms once per tick, then publishes atomic buffer indices; render samples previous/current snapshots for interpolation without blocking physics.

Each physics tick follows a strict staged pipeline:

1. **Force integration** — gravity applied to awake dynamic bodies; per-body AABBs rebuilt.
2. **Broad phase** — candidate pairs generated from dynamic/static BVHs with deterministic parallel chunk dispatch.
3. **Narrow phase** — contact manifolds built for each candidate pair with stable manifold/point feature IDs.
4. **Persistence refresh** — next-frame contact points matched against prior manifolds and warm-start caches transferred.
5. **Solve + stabilize** — contact velocity solve, positional correction, distance constraints, damping, resting clamp, sleep/wake updates.
6. **Publish** — transforms and debug channels (contacts, AABBs) published for rendering.

---

### Broad Phase

The broad phase uses two BVHs: a **dynamic BVH** for dynamic bodies and a **static BVH** for static bodies. Dynamic leaves are fattened so small motions avoid remove/reinsert churn; updates are skipped when the fat bounds still contain the new tight AABB.

Queries use an incremental policy: by default only **moved awake** bodies query; if movement ratio is high, it falls back to a full awake-body query. Previous manifold pairs can be carried forward and revalidated for overlap to avoid missing persistent contacts in moved-only frames.

Parallel dispatch uses a persistent worker pool with contiguous chunks and deterministic merge order. Candidate pairs are canonicalized (`min_id, max_id`), sorted, and deduplicated before narrow phase.

Dedicated benchmarks cover dynamic BVH microperformance and broad-phase dispatch tuning under controlled workloads.

{{< figure
  src="broad_phase/bvh_debug.png"
  caption="BVH node visualization. Leaf nodes correspond to individual bodies; internal nodes span the union of their children."
>}}

---

### Narrow Phase

For each candidate pair from the broad phase, the narrow phase generates a **contact manifold** — a contact normal, up to four contact points, penetration depth, and per-point local anchor offsets in each body's frame.

Supported shape pairs:
- **Sphere–sphere**: direct closest-point test.
- **Sphere–box**: closest-point-on-OBB test in box-local space (with inside fallback handling).
- **Box–box**: Separating Axis Theorem with axis hysteresis to suppress normal flip-flop. Face-face contacts produce up to four clipped points; edge-edge contacts produce one.
- **Box–ground** / **Sphere–ground**: implicit infinite ground plane.

Every contact point carries a **feature ID** and each manifold carries a manifold-level feature key. These stable IDs drive deterministic sorting and cross-frame persistence matching.

{{< figure
  src="narrow_phase/contact_manifold.png"
  caption="Contact manifold for a box resting on a plane, showing four contact points at the bottom face vertices and their local anchors."
>}}

---

### Manifold Persistence and Warm Starting

A naive solver that discards contact history every tick converges slowly and jitters in resting stacks.

Javelin persists manifolds across frames. At the start of each tick, contact points in the new manifolds are matched against their counterparts from the previous frame. Matching uses feature IDs first (a point with the same edge or face feature is the same contact point), then falls back to minimum local-anchor distance. A matched point inherits the previous frame's accumulated normal and friction impulses, which are applied as a **warm start** at the beginning of the solve.

Cached points are dropped when anchor drift, normal drift, or tangential drift exceed thresholds. Entire manifold caches are invalidated when selected manifold axis/normal changes too much between frames. The system tracks match rate, dropped points, axis-flip count, and cache invalidations in Tracy plots.

{{< figure
  src="persistence/warm_start_match_rate.png"
  caption="Tracy plot showing warm-start match rate across a large simulation. High match rates mean the solver converges faster; drops correspond to objects entering or leaving contact."
>}}

---

### Solver

Contact solving uses two passes:

**Velocity pass (projected Gauss-Seidel):** Each point solves normal + two tangent directions with Coulomb friction, penetration bias, restitution thresholding, and warm-started accumulated impulses. The default cap is 16 iterations, with adaptive early-out and higher caps for complex islands/contact sets.

**Position pass (4 iterations):** Residual penetration is corrected through direct positional/orientational correction, preventing long-term sinking.

Distance constraints are solved after contacts with an XPBD-style compliant formulation (`compliance = 0` behaves like a rigid link). Resting-contact velocity clamping and sleep timers then suppress residual jitter while preserving genuine low-speed motion.

---

### Sleeping and Constraints

The engine tracks connected dynamic components (contacts + constraints) and maintains persistent **sleep islands**. Wake propagation occurs across active edges; sleeping occurs island-wide only after velocity/timer criteria are met. This avoids one-body wake/sleep thrash in constrained structures and stacked piles.

Distance constraints are authored directly in `.jvscene` files and support local anchors, rest length, and compliance for rigid or softened links. This enables scenes like Newton's cradle and pendulum-driven destruction setups without adding a full joint stack.

---

### Rendering

The renderer is an OpenGL 4.6 rasterizer with a fixed pass pipeline:

1. **GeometryPass**
2. **WorldGridPass**
3. **SleepDebugPass**
4. **ContactDebugPass**
5. **AabbDebugPass**
6. **ConstraintDebugPass**
7. **VelocityDebugPass**
8. **DisplayPass**

Geometry is instanced (sphere/cube primitives) using streamed per-instance transform, scale, orientation, and material data from the latest pose snapshot. Debug overlays are individually toggleable from the ImGui runtime UI.

Final display uses an OCIO-generated ACEScg-to-sRGB transform shader + LUTs, with a bypass option for raw scene color. Tracy GPU zones instrument each pass and present stage.

{{< figure
  src="rendering/grid_boxes.png"
  caption="A 3D grid scene. The world grid provides spatial reference and debug overlays can be layered over live simulation data."
>}}

---

### Scene Tooling and Capture

Scenes are authored in a strict, grep-friendly text format (`.jvscene`) with:
- `physics_material` records (restitution, friction, density),
- sphere/box shapes,
- static/dynamic bodies,
- distance constraints (anchors, rest length, compliance).

The project includes:
- `scene_tool` for normalization and deterministic round-trip verification,
- `scene_capture` for deterministic offline capture with asynchronous readback/writer pipelines and manifest output,
- procedural scene generation scripts for large reproducible stress scenes.

---

### C++23 Modules and Codebase Structure

The entire codebase uses C++23 **named modules** (`export module javelin.physics.solver;`, `import javelin.physics.types;`) rather than headers. This enforces clean separation of interface from implementation, eliminates include-order dependencies, and keeps compile times predictable as the codebase grows. It also means every module boundary is an explicit contract.

The math library (`vec2`, `vec3`, `vec4`, `mat3`, `mat4`, `quat`) is implemented from scratch in the same module system. Quaternion integration uses the derivative form `q' = 0.5 * ω * q` for correct orientation stepping.

The repository also ships focused benchmarks (dynamic BVH, contact solver kernel, manifold persistence, sleep-aware collision, island sleep/wake, broad-phase dispatch tuning), plus a performance harness for before/after drift gating with benchmark JSON and Tracy CSV exports.

---

{{< github repo="joseph-wardle/javelin" showThumbnail=false >}}
