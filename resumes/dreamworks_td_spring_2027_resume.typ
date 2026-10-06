#import "@preview/basic-resume:0.2.9": *

#let name = "Joseph Wardle"
#let location = "Provo, UT"
#let email = "joseph.m.wardle@gmail.com"
#let github = "github.com/joseph-wardle"
#let phone = "+1 (435) 515-6980"
#let personal-site = "josephwardle.com"
#let lightbg = rgb("#faf8f3")

#show: resume.with(
  author: name,
  location: location,
  email: email,
  github: github,
  phone: phone,
  personal-site: personal-site,
  accent-color: "#9d5a2f",
  font: "Linux Libertine",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

#set text(size: 10pt)
#set par(justify: false, leading: 0.62em, spacing: 0.7em)

== Work Experience

#box(fill: lightbg, stroke: (left: 3pt + rgb("#9d5a2f")), inset: (left: 12pt, right: 8pt, top: 8pt, bottom: 8pt), width: 100%)[
#work(
  title: "Pipeline Technical Director - Capstone Films",
  location: "Provo, UT",
  company: "Brigham Young University - Animation Department",
  dates: "October 2025 - Present",
)

- Develop and support *Python/Qt* tools and a *USD* pipeline for *50+ artists* on Linux and Windows; troubleshoot DCC tools and publishing failures, and manage shot and asset data.

*Sandwich Kwon Do*
- Implemented *immutable, versioned USD publishes* and pinned every layer's version at *Tractor* submission, eliminating flicker caused by assets republished mid-render.
- Built a *Maya previs-to-layout workflow* with dry-run validation, *ShotGrid* shot creation and re-cutting, and versioned layout scene saves.
- Built *one-click Maya publishing* through a headless Houdini USD asset builder shared with Substance Painter.
- Built a shared *Maya/Houdini playblast previewer* with FFmpeg burn-ins and *ShotGrid Version uploads*.
- Established the show's *OCIO* color pipeline, baking *OpenDRT and ACES 2.0* to 65³ LUTs for OCIO 2.3 compatibility across Houdini, Maya, Nuke, and Blender.

*Honey Business* (contributor to an existing pipeline)
- Built whole-collection *VDB-to-mesh foliage proxies*, switched with USD purposes, for *up to 70× faster viewport performance*.
]

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University - Computer Science Department",
  dates: "March 2025 - November 2025",
)
- Developed and maintained *Django* web services, REST endpoints, and internal admin UIs for non-technical users.
- Built *GitHub Actions* pipelines for testing, container builds, and deployment; used *Docker Compose* for local development and *Jira* for project tracking.

#work(
  title: "Audio Engineer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: "September 2023 - November 2025",
)
- Designed sound systems, mixed live audio, and supported streaming for stadium sports, devotionals, and performances.

== Projects

#box(fill: lightbg, stroke: (left: 3pt + rgb("#9d5a2f")), inset: (left: 12pt, right: 8pt, top: 8pt, bottom: 8pt), width: 100%)[
#project(
  dates: "",
  name: "Cenote - GPU Path Tracer and Hydra Render Delegate",
  url: "github.com/joseph-wardle/cenote",
)
- Built a *Rust/Vulkan* GPU path tracer with *Slang* kernels and a *Hydra 2* render delegate for usdview, husk, and Houdini; one unbiased estimator serves interactive previews and final frames.
- Implemented *OpenPBR* shading with baked energy-compensation tables; verified with white furnace tests and comparisons against *pbrt-v4*.
]

#project(
  dates: "2023 - Present",
  name: "Javelin - Rigid Body Physics Engine",
  url: "github.com/joseph-wardle/javelin",
)
- Built a *C++23* simulator using named modules, fixed 60 Hz physics on a dedicated thread, BVH broad phase, and a warm-started constraint solver; added an *ImGui/OpenGL* viewer and *Tracy* profiling.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "github.com/joseph-wardle/film_grain",
)
- Reimplemented Newson et al. (2017) in *Rust* with *Rayon* CPU parallelism and *wgpu* compute; multithreaded CPU is a *median 72× faster* than the reference C implementation (\~7,200 configurations, \~56,000 renders; median of three runs each).

== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: "August 2023 - Expected May 2027",
  degree: "Bachelor of Science, Computer Science (Animation & Games Emphasis)",
)
- *GPA: 3.95.* Relevant coursework: Data Structures, Multithreading, Linear Algebra, Modeling, Rigging, Shading, FX.

== Skills

- *Programming:* Python, C++23, Rust, MEL, TypeScript, Bash
- *Pipeline:* USD, ShotGrid, Pixar Tractor, OCIO, RenderMan, MoonRay
- *DCCs & UI:* Maya, Houdini, Nuke, Substance Painter, Blender, Qt/PySide2, ImGui
- *Development:* Git, Perforce, GitHub Actions, Jira, Django, Docker; Linux, Windows
