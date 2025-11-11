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
  name: "Pipeline TD — Student Capstone Film",
  url: "github.com/joseph-wardle/bobo-pipeline"
)
- Maintain and extend a film-scale, OS-agnostic *USD* pipeline used by 40+ artists across *Linux* and Windows.
- Develop tools for Houdini, Maya, and Nuke to automate repetitive tasks, including a cross DCC snapshot tool backed by per asset Git repositories to simplify asset versioning for artists.
- Implemented a unified publish tool across DCCs, including automatic render submissions through *Pixar Tractor* configured for various asset types including playblasts, turntables, and final renders.
- Currently transitioning production asset management to *Perforce* with a unified bot account and cross DCC tooling; automate CI/CD actions with *TeamCity* to improve reliability and traceability.
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
  dates: dates-helper(start-date: "March 2025", end-date: "Present"),
)
- Engineer and maintain department web services as containerized *Django* applications.
- Design REST endpoints and internal admin UIs for non-technical users.
- Build *CI/CD pipelines* for test, image build, and deploy; local dev with *Docker Compose*; deploy to *Kubernetes*.
- Operate in *Linux* environments; instrument health checks and structured logging to simplify ops troubleshooting.
]

#work(
  title: "Audio Engineer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "September 2023", end-date: "Present"),
)
- Live audio mixing for stadium sports, large-scale devotionals, and performances; FOH, streaming, sound-system design.
- Lead small crews and coordinate with clients—prioritize clear communication, reliability, and incident response.

== Projects

#project(
  dates: dates-helper(start-date: "2023", end-date: "Present"),
  name: "Homelab & DevOps (Linux Server Management)",
  url: "josephwardle.com"
)
- Run *Fedora Server* services (*Podman*\/*Quadlet*, *systemd*); reverse proxy + TLS via *Caddy/NGINX*.
- Configure backups/archival for services and media; manage secrets/volumes; routine maintenance and upgrades.

#project(
  dates: dates-helper(start-date: "March 2025", end-date: "August 2025"),
  name: "Real-Time Ray Tracer",
  url: "github.com/DallinClark/RealTimeRaytracer"
)
- Built a real-time ray tracer using *Vulkan 1.3* hardware-accelerated ray tracing; authored pipeline/bootstrap code.
- Worked in a 3 man team, added developer utilities and profiling hooks; implemented in *C++20 modules*.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "github.com/joseph-wardle/film_grain"
)
- Implemented physically motivated film-grain rendering (Newson et al., 2017) with GPU *compute shaders*.
- Written in *Rust* with *WGPU*; benchmarked on the Vulkan backend; achieved substantial speedups versus a baseline.


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

- *Languages:* Python (Django/REST), C++20/23, Rust, Bash, Java, C\#, HTML/CSS
- *Systems:* Linux, systemd/Quadlet, Kubernetes, Podman/Docker, NGINX/Caddy
- *CI/CD & Deploy:* GitHub Actions, Jenkins, TeamCity
- *Render & Pipeline:* USD, Pixar Tractor, Houdini, Maya, Nuke, Perforce
- *Other Software:* Unreal Engine, Unity, Adobe, Jira, Confluence

