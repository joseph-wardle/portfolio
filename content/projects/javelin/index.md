---
title: "Javelin Physics Engine"
date: 2026-03-10
summary: "A rigid-body physics engine in C++23, with a warm-started solver, two BVHs for broad phase, and deterministic capture."
tags: ["C++23", "Physics", "Simulation", "OpenGL", "Tracy"]
weight: 20
track: graphics
---

Javelin is a rigid-body physics engine I wrote from scratch in C++23. It does spheres and boxes, Wioth many piddly bits like distance constraints for things like Newton's cradle. I mostly built it because I wanted a challanging multithreaded project to improve my synchronization skills.

{{< figure
  src="demo/5k_bodies.png"
  caption="A 5,000-body scene."
>}}

{{< spec >}}
Language: C++23, named modules throughout
Solver: Projected Gauss-Seidel, warm-started
Broad phase: Dynamic + static BVH
Rendering: OpenGL 4.6, ImGui, OCIO display transform
Profiling: Tracy
{{< /spec >}}

### How a tick works

Physics runs at a fixed 60 Hz on its own thread. A fixed timestep keeps the simulation reproducible. The pipeline works in simple steps: integrate forces, find pairs that might be touching (broad phase), build the actual contacts (narrow phase), match them against last tick's contacts, solve, and publish the new transforms.

The renderer reads those transforms through a triple buffer. Physics writes a new snapshot every tick, and the renderer blends between the last two without ever waiting on physics.

### Finding pairs

Checking every body against every other is a textbook bad idea, so the broad phase uses two BVHs: one for moving bodies and one for the static world. Moving bodies get slightly padded bounds, so a small nudge doesn't force them to be pulled out of the tree and reinserted. Only bodies that actually moved ask the static tree for pairs. The work is split across a thread pool, and the results get sorted and deduplicated, so the output is the same no matter how the threads finished.

{{< figure
  src="broad_phase/bvh_debug.png"
  caption="The BVH, drawn over the scene. Leaves are bodies; each parent wraps its children."
>}}

### Contacts that remember

For each pair, the narrow phase builds a contact manifold: a normal and up to four contact points. Box against box uses the separating axis test, with a little hysteresis so the contact normal doesn't flip back and forth between two nearly equal axes.

The bigger win was making contacts remember. A solver that starts from zero every tick converges slowly and jitters, especially in stacks. So every contact point carries an ID based on the features that made it (this edge, that face), and each tick, new points get matched to last tick's points. A matched point starts the solve with the impulse it ended with last time. That's warm starting, and it's most of the difference between a stack that jitters and one that rests. When a contact drifts too far or the normal swings too much, its cached impulse is thrown out instead of trusted.

{{< figure
  src="persistence/warm_start_match_rate.png"
  caption="Warm-start match rate in Tracy over a large simulation. Dips are bodies coming into or out of contact."
>}}

### Solving, and sleeping

Contacts are solved in two passes. A velocity pass handles friction, bounce, and the warm-started impulses, with up to 16 iterations (more for big, complicated islands) and an early exit once it settles. Then a short position pass pushes out whatever overlap is left so things don't slowly sink. Distance constraints are solved after, XPBD-style, so zero compliance is a rigid rod and anything above that is a spring.

Bodies that touch each other form islands, and an island only goes to sleep all at once, after everything in it has been still for a while. Putting bodies to sleep one at a time makes stacks thrash between awake and asleep, so the whole pile sleeps or none of it does.

### Seeing what's going on

Most of the renderer is debugging tools: contacts, bounding boxes, velocities, sleep state, and constraints can each be toggled on from ImGui. Scenes are a plain text format (`.jvscene`) that's easy to read and diff, with a tool that checks a scene survives a round trip unchanged. Everything is instrumented in Tracy, and there are benchmarks for the BVH, the solver, contact persistence, and sleeping.

{{< figure
  src="rendering/grid_boxes.png"
  caption="A grid of boxes with the world grid underneath."
>}}

{{< github repo="joseph-wardle/javelin" showThumbnail=false >}}
