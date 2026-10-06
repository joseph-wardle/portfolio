#import "@preview/basic-resume:0.2.9": *

#let name = "Joseph Wardle"
#let location = "Provo, UT"
#let email = "joseph.m.wardle@gmail.com"
#let github = "github.com/joseph-wardle"
#let phone = "+1 (435) 515-6980"
#let personal-site = "josephwardle.com"

#show: resume.with(
  author: name,
  location: location,
  email: email,
  github: github,
  phone: phone,
  personal-site: personal-site,
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: dates-helper(start-date: "Aug 2023", end-date: "Expected May 2027"),
  degree: "Bachelor of Science, Computer Science — Animation and Games Emphasis",
)
- Cumulative GPA: 3.9\/4.0
- Relevant Coursework: Data Structures, Multithreading, Linear Algebra, Modeling, Rigging, Shading, FX

== Work Experience

#work(
  title: "Pipeline TD",
  location: "Provo, UT",
  company: "BYU Center for Animation — Sandwich Kwon Do (2027 Capstone Feature Film)",
  dates: dates-helper(start-date: "Oct 2025", end-date: "Present"),
)
- Sole pipeline TD for a 50+ artist animated feature; authored 20,000+ lines of production *Python* spanning cross-DCC publishing, render farm integration, telemetry, and artist tooling.
- Built a render telemetry system that harvests per-frame render times and peak memory usage from *Husk* and *RenderMan* log output via *Pixar Tractor*; emits structured events for production monitoring.
- Engineered a unified publish: *Maya* invokes headless *Houdini* via subprocess to assemble a complete *USD* asset hierarchy — eliminating a manual double-publish step for all geometry assets.
- Authored *Qt* (PySide2) artist tools across *Maya*, *Houdini*, *Nuke*, and *Substance Painter*; integrated with *ShotGrid* for asset registration, version tracking, and automatic playblast upload.
- Deployed on production *Linux* (EL9) and Windows 11; enforced code quality with *uv*, *ruff*, *Black*, and pre-commit hooks.

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "Mar 2025", end-date: "Present"),
)
- Engineer and maintain the BYU CS Department website as containerized *Django* applications with *CI/CD pipelines*, *Docker Compose*, and *Kubernetes* deployment.

#work(
  title: "Audio Engineer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "Sep 2023", end-date: "Present"),
)
- Live audio mixing for stadium sports, large-scale devotionals, and performances; FOH, streaming, and sound-system design.

== Projects

#project(
  dates: dates-helper(start-date: "Jun 2025", end-date: "Present"),
  name: "Javelin — Real-Time Rigid Body Physics Engine",
  url: "https://github.com/joseph-wardle/javelin"
)
- Built a real-time rigid body simulator from scratch in *C++23* with dedicated physics thread and OpenGL renderer; handles *7,000+ concurrent dynamic bodies* at 60 Hz.
- Five-stage fixed-timestep pipeline: force integration, parallel broad phase (dual dynamic\/static BVH, multi-threaded worker pool), SAT+GJK narrow phase with contact manifolds, warm-started projected Gauss-Seidel solver, and pose publish.
- Persists contact manifolds across frames for warm starting: per-point feature-ID matching reduces solver iteration count and eliminates stack jitter; Tracy integration exposes per-tick diagnostics.
- Implemented in *C++23 named modules* throughout; custom math library (vec3, mat3, mat4, quat); lock-free atomics for pause\/resume and manual step control from the render thread.

#project(
  dates: dates-helper(start-date: "Mar 2025", end-date: "Aug 2025"),
  name: "Real-Time Ray Tracer",
  url: "https://github.com/DallinClark/RealTimeRaytracer"
)
- Built a fully ray-traced renderer in *C++23* with *Vulkan* 1.3 hardware-accelerated ray tracing; Cook-Torrance PBR, LTC area lights, and a compute-shader denoiser.
- Responsible for pipeline setup, descriptor management, custom memory allocators, BLAS\/TLAS acceleration structures, and development tooling.

#project(
  dates: "Aug 2025",
  name: "Film Grain Synthesis",
  url: "https://github.com/joseph-wardle/film_grain"
)
- Implemented physically motivated film grain algorithms from Newson et al. (2017) in *Rust* with *WGPU* compute shaders; benchmarked across ~56,000 renders.
- Up to *160×* faster than the C reference on CPU; *68×* faster on GPU for large pixel-wise workloads.

== Skills

- *Languages:* C++, Python, Rust, JavaScript, Bash, MEL, HScript
- *Graphics & Simulation:* Vulkan, OpenGL, WGPU, USD, physically based rendering, rigid body dynamics
- *DCC & Pipeline:* Maya, Houdini, Nuke, Substance Painter, ShotGrid, Tractor, Husk
- *Tools & Technologies:* Git, Linux (EL9), CMake, Tracy, Qt (PySide2), Docker, Kubernetes
