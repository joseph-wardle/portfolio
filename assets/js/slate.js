/* slate.js — per-component progressive enhancement for the interactive
   shortcodes. Loaded deferred, and only on pages that use them (the shortcodes
   set a page flag). Each block is a no-op when its elements are absent, and
   nothing here is required for the content to be readable. */

/* YouTube facade → swap in the iframe on click (no third-party JS before then). */
document.querySelectorAll('.s-embed-frame[data-yt]').forEach((btn) => {
  btn.addEventListener('click', () => {
    const f = document.createElement('iframe');
    f.src = `https://www.youtube-nocookie.com/embed/${btn.dataset.yt}?autoplay=1`;
    f.allow = 'accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture';
    f.allowFullscreen = true;
    f.title = 'YouTube video player';
    btn.replaceWith(f);
  });
});

/* Carousel — buttons, dot sync, and optional autoplay (data-interval ms). */
const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;
document.querySelectorAll('[data-carousel]').forEach((c) => {
  const track = c.querySelector('.s-carousel-track');
  const slides = [...c.querySelectorAll('.s-slide')];
  const dots = [...c.querySelectorAll('.s-carousel-dots span')];
  if (!track || slides.length < 2) return;

  const step = (dir) => track.scrollBy({ left: track.clientWidth * dir, behavior: 'smooth' });
  c.querySelectorAll('.s-carousel-nav').forEach((b) =>
    b.addEventListener('click', () => step(+b.dataset.dir)));

  track.addEventListener('scroll', () => {
    const i = Math.round(track.scrollLeft / track.clientWidth);
    dots.forEach((d, j) => d.classList.toggle('on', j === i));
  }, { passive: true });

  const interval = +c.dataset.interval;
  if (interval > 0 && !reduceMotion) {
    let timer = setInterval(() => {
      const atEnd = track.scrollLeft + track.clientWidth >= track.scrollWidth - 4;
      atEnd ? track.scrollTo({ left: 0, behavior: 'smooth' }) : step(1);
    }, interval);
    const stop = () => { clearInterval(timer); timer = 0; };
    c.addEventListener('pointerenter', stop);
    c.addEventListener('focusin', stop);
  }
});

/* Before/after compare — pointer drag anywhere on the image (mouse, pen, touch),
   with the hidden range input kept for keyboard use and screen readers. */
document.querySelectorAll('[data-compare]').forEach((c) => {
  const pane = c.querySelector('.s-compare-pane');
  const range = c.querySelector('.s-compare-range');
  if (!pane || !range) return;
  const set = (v) => {
    const pos = Math.min(100, Math.max(0, v));
    range.value = pos;
    pane.style.setProperty('--pos', `${pos}%`);
  };
  const fromX = (x) => {
    const r = pane.getBoundingClientRect();
    set(((x - r.left) / r.width) * 100);
  };
  range.addEventListener('input', () => set(+range.value));
  // Track the drag on window so it keeps following outside the pane. Mouse moves
  // on press; touch waits until the gesture is clearly horizontal, because a
  // vertical swipe here is a page scroll (touch-action: pan-y).
  let drag = null;
  pane.addEventListener('pointerdown', (e) => {
    if (e.button !== 0) return;
    e.preventDefault();
    const mouse = e.pointerType === 'mouse';
    drag = { id: e.pointerId, x: e.clientX, y: e.clientY, on: mouse };
    if (mouse) fromX(e.clientX);
  });
  window.addEventListener('pointermove', (e) => {
    if (!drag || e.pointerId !== drag.id) return;
    if (!drag.on) {
      const dx = Math.abs(e.clientX - drag.x), dy = Math.abs(e.clientY - drag.y);
      if (dy > dx && dy > 6) { drag = null; return; }
      if (dx < 6) return;
      drag.on = true;
    }
    fromX(e.clientX);
  });
  window.addEventListener('pointerup', (e) => {
    if (!drag || e.pointerId !== drag.id) return;
    const tap = Math.abs(e.clientX - drag.x) < 6 && Math.abs(e.clientY - drag.y) < 6;
    if (drag.on || tap) fromX(e.clientX);
    drag = null;
  });
  window.addEventListener('pointercancel', (e) => {
    if (drag && e.pointerId === drag.id) drag = null;
  });
});

/* Autoplay clips — play only while on screen (and never under reduced motion). */
const clips = document.querySelectorAll('video[data-autoplay]');
if (clips.length && !reduceMotion && 'IntersectionObserver' in window) {
  const io = new IntersectionObserver((entries) => entries.forEach((e) => {
    if (e.isIntersecting) e.target.play().catch(() => {});
    else e.target.pause();
  }), { threshold: 0.25 });
  clips.forEach((v) => io.observe(v));
}
