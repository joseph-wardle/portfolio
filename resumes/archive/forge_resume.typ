#import "@preview/basic-resume:0.2.9": *

#let name = "Joseph Wardle"
#let location = "Provo, UT • Open to relocation: San Diego, CA"
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

== Graphics & Rendering Projects

#project(
  dates: dates-helper(start-date: "March 2025", end-date: "August 2025"),
  name: "Real-Time Ray Tracer",
  url: "github.com/DallinClark/RealTimeRaytracer"
)
- Co-developed a real-time ray tracer using *Vulkan 1.3* hardware-accelerated ray tracing in a 3-person team.
- Authored core pipeline/bootstrap code: swapchain, acceleration structure build, descriptor management, and frame loop.
- Implemented developer utilities and profiling hooks to analyze GPU/CPU timing and guide performance optimizations.
- Written in modern *C++20* with modules.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "github.com/joseph-wardle/film_grain"
)
- Implemented physically motivated film-grain rendering (Newson et al., 2017) in *Rust* using *WGPU* *compute shaders*.
- Developed both parallel CPU and GPU backends, then benchmarked against the original C implementation.
- Tuned workgroup sizes and memory access patterns to explore compute-shader optimization trade-offs.
- Structured as a CLI tool with clear parameters and reproducible benchmarking for future experimentation.

#project(
  dates: dates-helper(start-date: "2023", end-date: "Present"),
  name: "Homelab & DevOps (Linux Server Management)",
  url: "josephwardle.com"
)
- Run *Fedora Server* services (*Podman*\/*Quadlet*, *systemd*); reverse proxy + TLS via *Caddy/NGINX*.
- Configure backups/archival for services and media; manage secrets/volumes; routine maintenance and upgrades.

== Experience

#project(
  dates: dates-helper(start-date: "October 2025", end-date: "Present"),
  name: "Pipeline TD — Student Capstone Film",
  url: "github.com/joseph-wardle/bobo-pipeline"
)
- Maintain and extend a film-scale, OS-agnostic *USD* asset pipeline used by 40+ artists across *Linux* and Windows.
- Develop DCC tools for Houdini, Maya, and Nuke that automate publishing and scene setup, emphasizing robustness and UX for artists.
- Implement a unified publish tool with automatic render submissions through *Pixar Tractor* for playblasts, turntables, and final renders.
- Transitioning production asset management to *Perforce* with a unified bot account and CI/CD automation via *TeamCity* for traceable, reliable builds.

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University — Computer Science Department",
  dates: dates-helper(start-date: "March 2025", end-date: "Present"),
)
- Engineer and maintain department web services as containerized *Django* applications.
- Design internal REST APIs and admin UIs, and own *CI/CD* pipelines (test, image build, deploy) to Kubernetes clusters.

#work(
  title: "Audio Engineer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "September 2023", end-date: "Present"),
)
- Live audio mixing for stadium sports, large-scale devotionals, and performances; FOH, streaming, sound-system design.
- Coordinate with clients and small crews under time pressure, emphasizing clear communication and reliability.

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

- *Graphics & GPU:* Vulkan 1.3, WGPU, GPU compute shaders, USD
- *Languages:* C++20/23, Rust, Python (Django/REST), Bash, Java, C\#, HTML/CSS
- *Systems & Tooling:* Linux, Git, systemd/Quadlet, Podman/Docker, Kubernetes
- *CI/CD & Infra:* GitHub Actions, Jenkins, TeamCity
- *DCC & Engines:* Houdini, Maya, Nuke, Unreal Engine, Unity, Adobe suite
