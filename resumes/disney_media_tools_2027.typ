#import "@preview/basic-resume:0.2.9": *

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

#box(fill: lightbg, stroke: (left: 3pt + rgb("#9d5a2f")), inset: (left: 12pt, right: 8pt, top: 8pt, bottom: 8pt), width: 100%)[
#work(
  title: "Pipeline Technical Director - Student Short Films",
  location: "Provo, UT",
  company: "Brigham Young University Center for Animation",
  dates: "October 2025 - Present",
)

- Develop *Python/Qt artist tools* and a *USD production pipeline* supporting *50+ artists* on Linux and Windows; manage asset and shot data and troubleshoot publishing and DCC workflow failures.

*Sandwich Kwon Do*
- Implemented *immutable, versioned USD publishes* and pinned layer versions at *Tractor* submission, keeping render dependencies consistent and eliminating flicker from assets republished mid-render.
- Built a *Maya previs-to-layout tool* that lets artists review shot changes and validation errors before updating *ShotGrid* and saving versioned layout scenes.
- Built *one-click asset publishing in Maya* backed by a headless Houdini USD builder shared with Substance Painter.
- Developed a shared *Maya/Houdini playblast tool* with FFmpeg burn-ins and *ShotGrid Version uploads*.
- Established consistent *OCIO color workflows* across Houdini, Maya, Nuke, and Blender, adapting OpenDRT and ACES 2.0 transforms for OCIO 2.3 compatibility.

*Honey Business*
- Built *VDB-to-mesh foliage proxies* for entire collections, using USD purposes to switch representations and improve viewport performance by *up to 70×*.
]

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University - Computer Science Department",
  dates: "March 2025 - November 2025",
)
- Developed and maintained *Django web services, REST APIs, and administrative interfaces* for nontechnical users.
- Built *GitHub Actions* workflows for testing, container builds, and deployment; used *Docker Compose* for local development and *Jira* for project tracking.

== Projects

#box(fill: lightbg, stroke: (left: 3pt + rgb("#9d5a2f")), inset: (left: 12pt, right: 8pt, top: 8pt, bottom: 8pt), width: 100%)[
#project(
  dates: "",
  name: "Cenote - GPU Path Tracer and Hydra Render Delegate",
  url: "github.com/joseph-wardle/cenote",
)
- Built a *Rust/Vulkan* GPU path tracer and *Hydra 2 render delegate* integrating with usdview, husk, and Houdini.
- Implemented *OpenPBR* shading in Slang; validated energy conservation with *white furnace tests* and rendering results against *pbrt-v4*.
]

#project(
  dates: "2023 - Present",
  name: "Javelin - Rigid Body Physics Engine",
  url: "github.com/joseph-wardle/javelin",
)
- Built a *C++23* physics engine using named modules and a dedicated simulation thread, with an *ImGui/OpenGL* viewer and *Tracy* profiling.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "github.com/joseph-wardle/film_grain",
)
- Reimplemented a published film-grain algorithm in *Rust*, with *Rayon* CPU parallelism and *wgpu* compute; benchmarked the CPU implementation across \~7,200 configurations, measuring a *median 72× speedup* over the reference C implementation.

== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: "August 2023 - Expected May 2027",
  degree: "Bachelor of Science, Computer Science (Animation & Games Emphasis)",
)
- *GPA: 3.95.* Relevant coursework: Data Structures, Multithreading, Linear Algebra, Modeling, Rigging, Shading, FX.

== Skills

- *Programming:* Python, C++23, Rust, MEL, Bash
- *Interfaces & APIs:* Qt/PySide2, Django, REST APIs, ImGui
- *Production Pipeline:* USD, ShotGrid, Pixar Tractor, OCIO
- *DCCs:* Maya, Houdini, Nuke, Substance Painter, Blender
- *Development:* Linux, Windows, Git, Perforce, GitHub Actions, Docker, Jira
