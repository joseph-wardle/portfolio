#import "@preview/basic-resume:0.2.10": *

#let name = "Joseph Wardle - Production TD"
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
#set par(justify: false, leading: 0.8em, spacing: 1.0em)

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
  - Develop *Python/Qt artist tools* and a *USD production pipeline* for *50+ artists* on two animated short films; troubleshoot material, lookdev, and publishing workflows in Maya and Houdini.
  - Built a *Maya material-assignment visualizer* with colors chosen for colorblind accessibility, helping artists inspect assignments and identify unassigned objects on assets with many materials.
  - Automated *material binding across Maya, Substance Painter, and Houdini*, mapping Maya shading groups through Substance texture sets to *USD geometry subsets*.
  - Built a *Houdini material-library HDA* that generates *PxrSurface* shaders from published textures and paired *UsdPreviewSurface* shaders with JPEG proxies capped at 1K; automated color conversion and tiled EXR/TEX generation for RenderMan.
  - Built a *Houdini lookdev HDA* with renderer-independent turntables, lighting presets, and artist-requested framing and angle controls; automated *Tractor rendering, denoising, and video export*.
  - Revised material tools from *artist feedback* to preserve custom shader edits during rebuilds, support layered RenderMan materials, and simplify controls for specular ray depth, displacement, and subdivision.
  - Extended *Houdini's Component Builder* with custom nodes for *geometry and material variants* and automatic viewport proxy generation.
  - Established consistent *OCIO color workflows* across Houdini, Maya, Nuke, and Blender, adapting OpenDRT and ACES 2.0 transforms for OCIO 2.3 compatibility.
]

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University - Computer Science Department",
  dates: "March 2025 - November 2025",
)
- Developed *Django services, REST APIs, and administrative interfaces* for nontechnical users.
- Built *GitHub Actions* workflows for testing, container builds, and deployment; used *Docker Compose* for local development and *Jira* for project tracking.

== Selected Project

#project(
  name: "Cenote - GPU Path Tracer & Hydra Render Delegate",
  url: "github.com/joseph-wardle/cenote",
  dates: "",
)
- Built a *Rust/Vulkan GPU path tracer* with a *Hydra render delegate* integrating with usdview, husk, and Houdini.
- Implemented *OpenPBR shading in Slang*; validated energy conservation with *white furnace tests* and rendering results against *pbrt-v4*.

== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: "Expected May 2027",
  degree: "B.S. Computer Science (Animation & Games Emphasis)",
)

*GPA: 3.95.* Coursework: Shading, Modeling, Rigging, FX, Linear Algebra, Data Structures, Multithreading.

== Skills

*Programming:* Python, C++23, Rust, Slang, MEL, Bash | *UI:* Qt/PySide2, ImGui \
*Materials & Pipeline:* USD, RenderMan, OCIO, Pixar Tractor, ShotGrid \
*DCCs:* Maya, Houdini/Solaris, Substance Painter, Nuke, Blender \
*Development:* Linux, Windows, Git, Perforce, GitHub Actions, Docker