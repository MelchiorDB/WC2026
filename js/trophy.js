// ============================================================================
//  Coupe du Monde stylisée en Canvas, avec rotation pseudo-3D (écrasement
//  horizontal sinusoïdal + reflet mobile). Utilisée en grand (login/entête,
//  qui tourne) et en petit dans la main du leader du classement.
// ============================================================================
const GOLD_HI = "#fff6c2", GOLD = "#f4c430", GOLD_MID = "#d4a017", GOLD_DK = "#8a6b12";

// Dessine la coupe centrée en (cx, cy), hauteur h, tournée d'un angle (radians).
export function drawTrophy(ctx, cx, cy, h, angle = 0) {
  const sx = Math.max(0.18, Math.abs(Math.cos(angle)));   // écrasement = rotation Y
  const lightLeft = Math.cos(angle) >= 0;                 // côté éclairé selon l'angle
  ctx.save();
  ctx.translate(cx, cy);
  ctx.scale(sx, 1);                                       // squash horizontal
  ctx.translate(-cx, -cy);

  const gold = (x0, x1) => {
    const g = ctx.createLinearGradient(x0, 0, x1, 0);
    const stops = lightLeft ? [GOLD_HI, GOLD, GOLD_MID, GOLD_DK] : [GOLD_DK, GOLD_MID, GOLD, GOLD_HI];
    stops.forEach((c, i) => g.addColorStop(i / 3, c));
    return g;
  };
  const top = cy - h / 2;
  const globeR = h * 0.20, globeCy = top + globeR * 1.05;
  const cupW = h * 0.30;

  // socle
  ctx.fillStyle = gold(cx - cupW, cx + cupW);
  ctx.beginPath();
  ctx.ellipse(cx, cy + h * 0.46, cupW * 0.9, h * 0.05, 0, 0, 7); ctx.fill();
  ctx.fillStyle = "#5b4708";
  ctx.beginPath();
  ctx.ellipse(cx, cy + h * 0.40, cupW * 0.55, h * 0.035, 0, 0, 7); ctx.fill();

  // corps : deux courbes (les silhouettes) du socle vers le globe
  ctx.fillStyle = gold(cx - cupW, cx + cupW);
  ctx.beginPath();
  ctx.moveTo(cx - cupW * 0.5, cy + h * 0.40);
  ctx.bezierCurveTo(cx - cupW * 1.2, cy + h * 0.05, cx - cupW * 0.6, globeCy + globeR * 0.6, cx - globeR * 0.5, globeCy + globeR * 0.7);
  ctx.lineTo(cx + globeR * 0.5, globeCy + globeR * 0.7);
  ctx.bezierCurveTo(cx + cupW * 0.6, globeCy + globeR * 0.6, cx + cupW * 1.2, cy + h * 0.05, cx + cupW * 0.5, cy + h * 0.40);
  ctx.closePath(); ctx.fill();

  // globe (sphère dorée)
  const gg = ctx.createRadialGradient(cx - globeR * 0.4, globeCy - globeR * 0.4, globeR * 0.2, cx, globeCy, globeR * 1.1);
  gg.addColorStop(0, GOLD_HI); gg.addColorStop(0.6, GOLD); gg.addColorStop(1, GOLD_DK);
  ctx.fillStyle = gg;
  ctx.beginPath(); ctx.ellipse(cx, globeCy, globeR, globeR, 0, 0, 7); ctx.fill();
  // méridiens/parallèles
  ctx.strokeStyle = "rgba(90,71,8,0.5)"; ctx.lineWidth = Math.max(1, h * 0.01);
  ctx.beginPath(); ctx.ellipse(cx, globeCy, globeR * 0.55, globeR, 0, 0, 7); ctx.stroke();
  ctx.beginPath(); ctx.moveTo(cx - globeR, globeCy); ctx.lineTo(cx + globeR, globeCy); ctx.stroke();
  ctx.restore();
}

// Anime une coupe qui tourne dans un <canvas> (login / entête).
export function spinTrophy(canvas) {
  const ctx = canvas.getContext("2d");
  const W = canvas.width, H = canvas.height;
  let a = 0;
  (function frame() {
    if (!canvas.isConnected) return;
    ctx.clearRect(0, 0, W, H);
    drawTrophy(ctx, W / 2, H / 2, H * 0.86, a);
    a += 0.05;
    requestAnimationFrame(frame);
  })();
}
