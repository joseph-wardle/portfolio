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
- Sole pipeline TD for a 50+ artist animated feature; authored 20,000+ lines of production *Python* covering Layout and Previs tooling, cross-DCC publishing, render farm integration, and telemetry.
- Built *Layout* and *Previs* tools in *Maya*: shot file managers that auto-load the *USD* stage on file open, configure shot camera constraints, and set scene context — mirroring the workflow responsibilities of this role.
- Developed a proxy generation system for large outdoor environments using VDB-to-mesh conversion from render geometry, reducing Layout artist viewport load times by *70×* for point-instanced foliage sets.
- Engineered a multi-environment shot assembly system enabling artists to divide and independently author large scenes in either *Maya* or *Houdini* with consistent *USD* layer composition at assembly time.
- Designed a unified publish: *Maya* tool invokes headless *Houdini* via subprocess to generate `geo.usd`, `mtl.usd`, `payload.usd`, and `asset.usd` in one click; artists never switch applications to publish.
- Authored *Qt* (PySide2) UIs across *Maya*, *Houdini*, *Nuke*, and *Substance Painter*; integrated with *ShotGrid* for asset registration, version tracking, and playblast delivery to dailies.
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
  dates: dates-helper(start-date: "Mar 2025", end-date: "Aug 2025"),
  name: "Real-Time Ray Tracer",
  url: "https://github.com/DallinClark/RealTimeRaytracer"
)
- Built a fully ray-traced renderer in *C++23* with *Vulkan* 1.3 hardware-accelerated ray tracing; Cook-Torrance PBR, LTC area lights, and a compute-shader denoiser.
- Responsible for pipeline setup, descriptor management, custom memory allocators, and development tooling.

#project(
  dates: "Aug 2025",
  name: "Film Grain Synthesis",
  url: "https://github.com/joseph-wardle/film_grain"
)
- Implemented physically motivated film grain algorithms from Newson et al. (2017) in *Rust* with *WGPU* compute shaders; up to *160×* faster than the C reference on CPU across ~56,000 benchmark renders.

== Skills

- *Languages:* Python, C++, Rust, JavaScript, Bash, MEL, HScript
- *DCC & Pipeline:* Maya, Houdini, Nuke, Substance Painter, USD, ShotGrid, Tractor
- *Tools & Technologies:* Qt (PySide2), Git, Linux (EL9), CMake, Vulkan, WGPU, Docker, Kubernetes
