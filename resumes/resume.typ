#import "@preview/basic-resume:0.2.9": *

// Put your personal information here, replacing mine
#let name = "Joseph Wardle"
#let location = "Provo, UT"
#let email = "joseph.m.wardle@gmail.com"
#let github = "github.com/joseph-wardle"
#let phone = "+1 (435) 515-6980"
#let personal-site = "josephwardle.com"

#show: resume.with(
  author: name,
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
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

/*
* Lines that start with == are formatted into section headings
* You can use the specific formatting functions if needed
* The following formatting functions are listed below
* #edu(dates: "", degree: "", gpa: "", institution: "", location: "")
* #work(company: "", dates: "", location: "", title: "")
* #project(dates: "", name: "", role: "", url: "")
* #extracurriculars(activity: "", dates: "")
* There are also the following generic functions that don't apply any formatting
* #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
* #generic-one-by-two(left: "", right: "")
*/
== Education

#edu(
  institution: "Brigham Young University",
  location: "Provo, UT",
  dates: dates-helper(start-date: "Aug 2023", end-date: "Expected May 2027"),
  degree: "Bachelor's of Science, Computer Science: Animation and Games Emphasis",
)
- Cumulative GPA: 3.9\/3.9
- Relevant Coursework: Data Structures, Multithreading, Linear Algebra, Modeling, Rigging, Shading, FX, etc.

== Work Experience

#work(
  title: "Audio Engineer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "September 2023", end-date: "Present"),
)
- Live audio mixing for stadium sports, large scale devotionals, and band performances.
- FOH, streaming, and sound-system design. Lead small crews and work directly with clients.

#work(
  title: "Web Developer",
  location: "Provo, UT",
  company: "Brigham Young University",
  dates: dates-helper(start-date: "March 2025", end-date: "Present"),
)
- Engineer and maintain the BYU Computer Science Department’s website as a set of containerized *Django* applications.
- Oversee full-stack development, *CI/CD pipelines*, local development with *Docker Compose*, and deployment with *Kubernetes*.
- Design secure, large-scale academic and administrative systems using *SWIFT* and *AGILE* development practices.

== Projects

#project(
  dates: dates-helper(start-date: "March 2025", end-date: "August 2025"),
  name: "Real Time Raytracer",
  url: "https://github.com/DallinClark/RealTimeRaytracer"
)
- Worked in a small team to produce a real-time raytracer using *Vulkan* 1.3's hardware accelerated ray tracing pipeline
- I was responsible for configuring the vulkan pipeline and boilerplate. I also built development tools
- Developed entirely with *C++20 modules*.

#project(
  dates: "August 2025",
  name: "Film Grain Synthesis",
  url: "https://github.com/joseph-wardle/film_grain"
)
- Implement physically modivated film grain rendering algorithms from Newson et al. (2017) using GPU *compute shaders*
- Supports both grain-wise and pixel-wise rendering, with support for multithreaded CPU or GPU processing
- Written in *Rust* with *WGPU* and benchmarked with the Vulkan backend
- Improved performance from the original paper by a factor of 1000000000000x

#project(
  dates: dates-helper(start-date: "October 2025", end-date: "Present"),
  name: "Student Capstone Film Pipeline TD",
  url: "https://github.com/joseph-wardle/bobo-pipeline"
)
- Maintain and extend a film-scale, OS-agnostic USD pipeline used by 40+ artists, allowing seamless data sharing across the entire production pipeline in both *Linux* and Windows.
- Develop custom tools and plugins for Houdini, Maya, and Nuke to automate repetitive tasks, such as an automated render farm submission using *Pixar's tractor* for weekly per department reviews.
- Developed a *Python USD*-based layout tool enabling artists to create environments in either *Maya* or *Houdini*
- Currently working on moving production asset management to *Perforce* using a bot account and per DCC snapshot tools to increase data security, convenience of versioning, and automated CI/CD actions with *Jenkins*.


== Skills

- *Programming languages:* C++, Rust, Python, Java, C\#, HTML/CSS, Bash
- *Software:* Perforce, Unreal Engine, Unity, Houdini, Maya, Adobe Substance, Nuke, Jira, Confluence
- *Tools and Technologies:* Vulkan, WGPU, USD, Enterprise Linux, Git, CMake, Django, Docker, Kubernetes, Vim