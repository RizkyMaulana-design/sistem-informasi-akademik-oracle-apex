(function () {
  var root = document.querySelector('.sk-home');
  if (!root) return;
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // Hitung naik pada angka statistik
  root.querySelectorAll('.sk-num').forEach(function (el) {
    var target = parseFloat(el.getAttribute('data-count')) || 0;
    if (reduce || target === 0) { el.textContent = target; return; }
    var start = null, dur = 1400;
    el.textContent = '0';
    function step(ts) {
      if (start === null) start = ts;
      var p = Math.min((ts - start) / dur, 1);
      var eased = 1 - Math.pow(1 - p, 3);
      el.textContent = Math.round(target * eased);
      if (p < 1) requestAnimationFrame(step);
    }
    setTimeout(function () { requestAnimationFrame(step); }, 500);
  });

  if (reduce) return;

  // Efek miring 3D mengikuti kursor pada kartu
  root.querySelectorAll('.sk-card, .sk-tile').forEach(function (card) {
    card.addEventListener('mousemove', function (e) {
      var r = card.getBoundingClientRect();
      var x = (e.clientX - r.left) / r.width - 0.5;
      var y = (e.clientY - r.top) / r.height - 0.5;
      card.style.animation = 'none';
      card.style.opacity = 1;
      card.style.transform = 'rotateY(' + (x * 14) + 'deg) rotateX(' + (-y * 14) + 'deg) translateZ(8px)';
    });
    card.addEventListener('mouseleave', function () {
      card.style.transform = '';
    });
  });

  // Parallax lembut pada objek 3D di hero
  var scene = root.querySelector('.sk-scene');
  if (scene) {
    root.addEventListener('mousemove', function (e) {
      var r = root.getBoundingClientRect();
      var x = (e.clientX - r.left) / r.width - 0.5;
      var y = (e.clientY - r.top) / r.height - 0.5;
      scene.style.transform = 'rotateY(' + (x * 16) + 'deg) rotateX(' + (-y * 12) + 'deg)';
    });
  }
})();
