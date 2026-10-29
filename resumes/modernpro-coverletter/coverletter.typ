#import "@preview/modernpro-coverletter:1.0.3": *

// Edit identity and contacts here. Keeping them beside the letter content
// makes this starter a self-contained document with no personal-data imports.
#let profile = (
  name: [Joseph Wardle],
  role: [Pipeline Technical Director],
  address: [Salt Lake City, Utah],
  contacts: (
    (text: [joseph.m.wardle\@gmail.com], link: "mailto:joseph.m.wardle@gmail.com"),
    (text: [josephwardle.com], link: "https://josephwardle.com/"),
  ),
)

// Academic cover letter. Everything below `profile` and `recipient` is optional:
//   preset: "compact" | "default" | "relaxed"   vertical rhythm
//   accent: rgb("#1e3a5f")                      the one colour in the document
#show: coverletter.with(
  profile: profile,
  recipient: (
    name: [Dreamworks Recruitment Team],
    address: [Glendale, California],
    date: [28 October 2026],
    subject: [Application for the Production TD Internship],
    greeting: [Dear DreamWorks Recruiting Team,],
  ),
)

I'm a Pipeline Technical Directorat Brigham Young University working on our animated capstone films. I'm excited to apply for the Technical Director Internship at DreamWorks, where I hope to contribute to the development of production tools that empower artists to create extraordinary films. I greatly admire DreamWorks' history of developing meaningful production technology. Everything from open-source projects like OpenVDB and MoonRay to presentations on proprietary tools like Doodle have been immensely helpful as I've developed and maintained my own production pipeline.

At BYU, I've developed and maintained a USD-based production pipeline supporting more than 50 artists, integrating Maya, Houdini, RenderMan, Nuke, and a 100-node render farm. This experience has taught me to approach software engineering through the needs of artists, balancing technical ambition with reliability, usability, and performance. Outside of production, I've pursued my interest in computer graphics through a hardware-accelerated path tracer written in Rust and Vulkan and a real time physics engine written in C++.

I love being able to work alongside talented artists and solve problems that make their work easier. I've had the pleasure of working with many talented artists, and I know Dreamworks will be a fufilling way to continue down that path. I've also spoken with Matt Walker several times about the Technical Director culture at DreamWorks, and his descriptions of its collaborative, passionate problem-solving environment reflect exactly the kind of team I want to join. I'd be thrilled to contribute my experience, learn from DreamWorks' talented engineers, and help build the technology behind films that inspire audiences around the world.

Thank you for your time and consideration.
