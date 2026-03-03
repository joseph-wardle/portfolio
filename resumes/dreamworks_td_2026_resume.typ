#import "@preview/basic-resume:0.2.9": *

#let name = "Joseph Wardle"
#let location = "Provo, UT"
#let email = "joseph.m.wardle@gmail.com"
#let github = "github.com/joseph-wardle"
#let phone = "+1 (435) 515-6980"
#let personal-site = "josephwardle.com"

#let offwhite = rgb("#e9ecf0")

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

== Work Experience

#box(
  fill: offwhite,
  inset: 8pt,        // padding
  radius: 4pt,       // rounded corners (optional)
  width: 100%,       // span text width
)[
#project(
  dates: dates-helper(start-date: "October 2025", end-date: "Present"),
  name: "Pipeline TD",
  url: "github.com/joseph-wardle/sandwich-pipeline"
)

- *Maintain and extend a film-scale, OS-agnostic USD* pipeline used by 40+ artists across *Linux* and Windows.
- Author *Qt* (PySide2) artist tools across *Maya*, *Houdini*, *Nuke*, and *Substance Painter*; integrated with *ShotGrid* for asset registration, version tracking, and automatic playblasts for dailies
- Built a telemetry system harvesting per-frame render times, memory usage from *Husk* and *RenderMan* via *Pixar Tractor* on an 107-node farm
- Engineered a unified publish: *Maya* and *Substance Painter* invoke *Houdini* subprocess to assemble a USD asset
- Built proxy generation tools for point instanced USD assets (foliage) to *improve viewport performance by 70x*.
- Introduced *version control* for shots and assets.
]

#box(
  fill: offwhite,
  inset: 8pt,        // padding
  radius: 4pt,       // rounded corners (optional)
  width: 100%,       // span text width
)[
#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University — Computer Science Department",
  dates: dates-helper(start-date: "March 2025", end-date: "November 2025"),
)
- Engineer and maintain department web services as *Django* applications using SWIFT development practices.
- Design REST endpoints and internal admin UIs for non-technical users.
- Build *CI/CD pipelines* for test, image build, and deploy; local dev with *Docker Compose*; deploy to *Kubernetes*.
]

#work(
  title: "Audio Engineer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "September 2023", end-date: "November 2025"),
)
- Sound-system design, streaming, live audio mixing for stadium sports, large-scale devotionals, and performances.

== Projects

#project(
  dates: dates-helper(start-date: "2023", end-date: "Present"),
  name: "Javelin - Real-Time Rigid Body Physics Engine",
  url: "github.com/joseph-wardle/javelin"
)
- Build a real-time rigid body simulator from scratch in *C++23*; handles *5,000+ concurrent dynamic bodies* at 60 Hz.
- Multithreaded broad phase (dynamic/static BVH), SAT + GJK narrow phase with contact manifolds, warm-started projected Gauss-Seidel solver; Tracy integration for per-tick diagnostics, profiling, and telemetry.
- Implemented in *C++23 named modules* throughout; custom math library (vec3, mat3, mat4, quat); lock-free atomics for pause / resume and manual step control from the render thread

#project(
  dates: dates-helper(start-date: "March 2025", end-date: "August 2025"),
  name: "Real-Time Ray Tracer",
  url: "github.com/DallinClark/RealTimeRaytracer"
)
- Built a real-time ray tracer using *Vulkan 1.3* hardware-accelerated ray tracing; authored pipeline/bootstrap code.
- Responsible for pipeline setup, descriptor management, development tooling, and custom memory allocators.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "github.com/joseph-wardle/film_grain"
)
- Implemented physically motivated film grain algorithms (Newson et al., 2017) in *Rust* with *WGPU* compute shaders;
- Up to *160X* faster than the C reference on CPU; *68x* faster on GPU for large pixel-wise workloads.


== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: dates-helper(start-date: "Aug 2023", end-date: "Expected May 2027"),
  degree: "Bachelor of Science, Computer Science (Animation & Games Emphasis)",
)
- Cumulative GPA: 3.95/3.96
- Relevant Coursework: Data Structures, Multithreading, Linear Algebra, Modeling, Rigging, Shading, FX


== Skills

- *Languages:* Python, MEL, C++20/23, Rust, Bash, Java, C\#, HTML/CSS
- *Systems:* Linux, Windows, systemd/Quadlet, Kubernetes, Podman/Docker, NGINX/Caddy
- *CI/CD & Deploy:* GitHub Actions, Jenkins, TeamCity, Git, Perforce
- *Render & Pipeline:* USD, Pixar Tractor, Houdini, Maya, Nuke, Perforce, Shotgrid, MoonRay
- *Other Software:* Unreal Engine, Unity, Adobe, Jira, Confluence

