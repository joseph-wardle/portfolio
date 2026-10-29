#import "@preview/basic-resume:0.2.10": *

#let name = "Joseph Wardle - Pipeline Technical Director"
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
  font: "Geist",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

#set text(size: 9.5pt)
#set par(justify: false, leading: 0.7em, spacing: 0.8em)

== Work Experience

#box(
  fill: lightbg,
  stroke: (left: 3pt + rgb("#9d5a2f")),
  inset: (left: 12pt, right: 8pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #work(
    title: "Pipeline Technical Director - Student Short Films",
    location: "Provo, UT",
    company: "Brigham Young University Center for Animation",
    dates: "October 2025 - Present",
  )

  - Develop artist tools and maintain a *USD production pipeline* supporting *50+ artists* across modeling, previs, animation, FX/CFX, shading, and rendering on Linux and Windows.

  - Built a *Python/Qt playblast viewer used across every department*, with scrubbing, looping, and multi-clip playback; reduced dailies preparation through department-specific burn-ins and submission to editorial and *ShotGrid*.
  - Developed a lightweight *ShotGrid API wrapper* to query, create, and update shots, assets, and playlists, supporting artist tools that reduced production-data authoring errors.
  - Developed *Maya previs tools* to batch-playblast shots with handles, review them consecutively, and export individual clips or a combined movie through the shared submission workflow.
  - Built an *FX/CFX wedge comparison interface* for farm-generated flipbooks and renders, with parameter burn-ins, grid comparison, individual inspection, and one-click selection of simulation caches.
  - Automated *Houdini lookdev turntables* with a cyclorama, color checker, and reference spheres, farm rendering, *color-managed movie generation*, and ShotGrid review submission.
  - Implemented *immutable USD publishes* and pinned layer versions at *Tractor* submission, keeping render dependencies consistent when assets were republished mid-render.
]

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University - Computer Science Department",
  dates: "March 2025 - November 2025",
)
- Refactored *Django/PostgreSQL data models* for TA/RA hiring to represent coursework, faculty assignments, and employment history, helping faculty track appointments and information used to determine pay.
- Developed *REST APIs and administrative interfaces* using *Django ORM* for database access and *Celery/Redis* for background tasks and scheduling.
- Built *GitHub Actions* workflows for testing, container builds, and deployment; used *Docker Compose* for local development and *Jira* for project tracking.

== Selected Projects

#project(
  dates: "",
  name: "Cenote - GPU Path Tracer and Hydra Render Delegate",
  url: "github.com/joseph-wardle/cenote",
)
- Built a *Rust/Vulkan* GPU path tracer and *Hydra render delegate* integrating with usdview, husk, and Houdini; implemented *OpenPBR* shading in Slang.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "github.com/joseph-wardle/film_grain",
)
- Reimplemented a published film-grain algorithm in *Rust* with *Rayon* and *wgpu* compute; benchmarked the CPU implementation across approximately 7,200 configurations, measuring a *median 72× speedup* over the reference C implementation.

== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: "August 2023 - Expected May 2027",
  degree: "Bachelor of Science, Computer Science (Animation & Games Emphasis)",
)
- *GPA: 3.95.* Relevant coursework: Data Structures, Multithreading, Linear Algebra, Modeling, Rigging, Shading, FX.

== Skills

- *Programming:* Python, C++23, Rust, SQL, MEL, Bash
- *Data & Services:* PostgreSQL, Django ORM, REST APIs, Celery, Redis
- *Media & Pipeline:* Qt/PySide2, FFmpeg, ShotGrid, OCIO, USD, Pixar Tractor
- *DCCs:* Maya, Houdini, Nuke, Substance Painter, Blender
- *Development:* Linux, Windows, Git, Perforce, GitHub Actions, Docker, Jira