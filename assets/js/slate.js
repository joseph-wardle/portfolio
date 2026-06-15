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

/* Before/after compare — map the range input to the reveal position. */
document.querySelectorAll('[data-compare]').forEach((c) => {
  const pane = c.querySelector('.s-compare-pane');
  const range = c.querySelector('.s-compare-range');
  if (pane && range) {
    range.addEventListener('input', () => pane.style.setProperty('--pos', `${range.value}%`));
  }
});
