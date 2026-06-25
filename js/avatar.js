// ============================================================================
//  Rendu d'avatar "footballeur" en Canvas (port du personnage Pillow) :
//  tête, maillot floqué (pseudo + numéro), bras + mains, short, jambes,
//  chaussettes, crampons, avec dégradés d'ombrage. Genre, peau, cheveux, barbe.
// ============================================================================
import { TEAMS, SKIN_TONES, HAIR_COLORS } from "./data.js";

const ACCENT = "#2563eb";

function rgb(hex) {
  const h = hex.replace("#", "");
  return [parseInt(h.slice(0, 2), 16), parseInt(h.slice(2, 4), 16), parseInt(h.slice(4, 6), 16)];
}
function mul(hex, f) {
  const c = rgb(hex).map(v => Math.max(0, Math.min(255, Math.round(v * f))));
  return `rgb(${c[0]},${c[1]},${c[2]})`;
}
function ink(hex) {
  const [r, g, b] = rgb(hex);
  return (0.299 * r + 0.587 * g + 0.114 * b) > 150 ? "#0f172a" : "#f5f8fc";
}
function vgrad(ctx, hex, y0, y1, light = 1.12, dark = 0.82) {
  const g = ctx.createLinearGradient(0, y0, 0, y1);
  g.addColorStop(0, mul(hex, light));
  g.addColorStop(1, mul(hex, dark));
  return g;
}
function rrect(ctx, x, y, w, h, r) {
  if (ctx.roundRect) { ctx.beginPath(); ctx.roundRect(x, y, w, h, r); return; }
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.arcTo(x + w, y, x + w, y + h, r);
  ctx.arcTo(x + w, y + h, x, y + h, r);
  ctx.arcTo(x, y + h, x, y, r);
  ctx.arcTo(x, y, x + w, y, r);
  ctx.closePath();
}

export function avatarColors(av) {
  const t = av && av.country && TEAMS[av.country];
  return {
    jersey: t ? t.kit : ACCENT,
    skin: SKIN_TONES[av && av.skin] || "#ffd1a4",
    hair: HAIR_COLORS[av && av.hair_color] || "#4b2e1e",
  };
}

// Dessine l'avatar dans tout le canvas fourni.
export function drawAvatar(canvas, av, { pseudo = "", withName = true } = {}) {
  av = av || {};
  const W = canvas.width, H = canvas.height;
  const ctx = canvas.getContext("2d");
  ctx.clearRect(0, 0, W, H);
  const { jersey, skin, hair } = avatarColors(av);
  const skinDark = mul(skin, 0.72);
  const style = av.hair || "Court", gender = av.gender || "Homme", beard = !!av.beard;
  const cx = W / 2;
  const headR = 0.103 * H, headCy = 0.155 * H;
  const torsoTop = 0.275 * H, hem = 0.52 * H, torsoHw = 0.185 * W;
  const sleeveH = 0.085 * H, armW = 0.085 * W, armX = torsoHw + 0.028 * W;
  const armTop = torsoTop + 0.02 * H, armBot = 0.56 * H;
  const shortsTop = 0.485 * H, shortsBot = 0.625 * H;
  const legOff = 0.058 * W, legW = 0.072 * W, legTop = 0.6 * H, legBot = 0.815 * H;
  const sockTop = 0.79 * H, sockBot = 0.88 * H, bootTop = 0.86 * H, bootBot = 0.93 * H;

  // ombre portée
  ctx.save();
  ctx.fillStyle = "rgba(0,0,0,0.22)";
  ctx.beginPath();
  ctx.ellipse(cx, H - 0.04 * H, 0.3 * W, 0.025 * H, 0, 0, 7);
  ctx.fill();
  ctx.restore();

  const part = (drawShape, hex, y0, y1, light, dark) => {
    drawShape(); ctx.fillStyle = vgrad(ctx, hex, y0, y1, light, dark); ctx.fill();
  };

  // cheveux longs (arrière)
  if (style === "Long") {
    part(() => { ctx.beginPath(); ctx.ellipse(cx, headCy + headR * 0.9, headR * 1.2, headR * 1.8, 0, 0, 7); },
         hair, headCy - headR, headCy + headR * 2.6);
  }
  // jambes
  for (const s of [-1, 1]) {
    const lc = cx + s * legOff;
    part(() => rrect(ctx, lc - legW, legTop, legW * 2, legBot - legTop, legW), skin, legTop, legBot);
  }
  // chaussettes
  for (const s of [-1, 1]) {
    const lc = cx + s * legOff;
    part(() => rrect(ctx, lc - legW, sockTop, legW * 2, sockBot - sockTop, legW * 0.6), jersey, sockTop, sockBot);
  }
  // crampons
  for (const s of [-1, 1]) {
    const lc = cx + s * legOff, toe = 0.05 * W;
    ctx.beginPath();
    ctx.ellipse(lc + s * toe * 0.4, (bootTop + bootBot) / 2, legW + toe * 0.6, (bootBot - bootTop) / 2, 0, 0, 7);
    ctx.fillStyle = vgrad(ctx, "#23272e", bootTop, bootBot, 1.5, 0.9); ctx.fill();
  }
  // short
  part(() => {
    rrect(ctx, cx - torsoHw * 0.95, shortsTop, torsoHw * 0.95 - 0.012 * W, shortsBot - shortsTop, 0.03 * W);
    rrect(ctx, cx + 0.012 * W, shortsTop, torsoHw * 0.95 - 0.012 * W, shortsBot - shortsTop, 0.03 * W);
  }, "#eef1f6", shortsTop, shortsBot, 1.04, 0.86);
  // bras + mains
  for (const s of [-1, 1]) {
    const ac = cx + s * armX;
    part(() => rrect(ctx, ac - armW / 2, armTop, armW, armBot - armTop, armW / 2), skin, armTop, armBot);
    part(() => { ctx.beginPath(); ctx.ellipse(ac, armBot, armW * 0.6, armW * 0.6, 0, 0, 7); }, skin, armBot - armW, armBot + armW);
  }
  // maillot (torse + épaules)
  part(() => {
    rrect(ctx, cx - torsoHw, torsoTop + sleeveH * 0.35, torsoHw * 2, hem - torsoTop - sleeveH * 0.35, torsoHw * 0.32);
    rrect(ctx, cx - torsoHw - armW, torsoTop, (torsoHw + armW) * 2, sleeveH, sleeveH * 0.5);
  }, jersey, torsoTop, hem, 1.1, 0.72);
  // col en V
  ctx.strokeStyle = skinDark; ctx.lineWidth = Math.max(1, 0.006 * W);
  ctx.beginPath();
  ctx.moveTo(cx - 0.05 * W, torsoTop + sleeveH * 0.4); ctx.lineTo(cx, torsoTop + sleeveH * 0.95);
  ctx.lineTo(cx + 0.05 * W, torsoTop + sleeveH * 0.4); ctx.stroke();
  // floquage
  const tk = ink(jersey);
  ctx.fillStyle = tk; ctx.textAlign = "center"; ctx.textBaseline = "middle";
  if (withName) {
    ctx.font = `bold ${Math.round(0.05 * H)}px 'DejaVu Sans', sans-serif`;
    ctx.fillText(String(pseudo).toUpperCase().slice(0, 11), cx, torsoTop + 0.055 * H);
  }
  ctx.font = `bold ${Math.round(0.12 * H)}px 'DejaVu Sans', sans-serif`;
  ctx.fillText(String(av.number ?? 10), cx, 0.452 * H);

  // cou
  part(() => rrect(ctx, cx - 0.035 * W, headCy + headR - 0.01 * H, 0.07 * W, torsoTop - headCy - headR + 0.02 * H, 0.02 * W), skin, headCy, torsoTop);
  // oreilles + boucles
  for (const ex of [cx - headR, cx + headR]) {
    ctx.beginPath(); ctx.ellipse(ex, headCy + 0.01 * H, 0.018 * W, 0.02 * H, 0, 0, 7);
    ctx.fillStyle = vgrad(ctx, skin, headCy, headCy + 0.03 * H); ctx.fill();
  }
  if (gender === "Femme") {
    ctx.fillStyle = "#f1c40f";
    for (const ex of [cx - headR, cx + headR]) {
      ctx.beginPath(); ctx.ellipse(ex, headCy + 0.04 * H, 0.008 * W, 0.011 * H, 0, 0, 7); ctx.fill();
    }
  }
  // tête (sphère ombrée)
  const hg = ctx.createRadialGradient(cx - headR * 0.4, headCy - headR * 0.4, headR * 0.2, cx, headCy, headR * 1.05);
  hg.addColorStop(0, mul(skin, 1.14)); hg.addColorStop(1, mul(skin, 0.82));
  ctx.beginPath(); ctx.ellipse(cx, headCy, headR, headR, 0, 0, 7); ctx.fillStyle = hg; ctx.fill();
  // barbe
  if (beard) {
    ctx.save();
    ctx.beginPath(); ctx.ellipse(cx, headCy + headR * 0.25, headR * 0.96, headR * 0.78, 0, 0.15 * Math.PI, 0.85 * Math.PI);
    ctx.fillStyle = mul(hair, 0.95); ctx.fill();
    ctx.beginPath(); ctx.ellipse(cx, headCy + 0.011 * H, 0.03 * W, 0.014 * H, 0, 0, 7);
    ctx.fillStyle = mul(skin, 0.98); ctx.fill();
    ctx.restore();
  }
  // visage
  const eo = headR * 0.42;
  for (const s of [-1, 1]) {
    const ex = cx + s * eo;
    ctx.fillStyle = "#fff"; ctx.beginPath(); ctx.ellipse(ex, headCy - 0.004 * H, headR * 0.18, headR * 0.16, 0, 0, 7); ctx.fill();
    ctx.fillStyle = "#28323a"; ctx.beginPath(); ctx.ellipse(ex, headCy, headR * 0.1, headR * 0.12, 0, 0, 7); ctx.fill();
    ctx.strokeStyle = hair; ctx.lineWidth = Math.max(1, 0.004 * W);
    ctx.beginPath(); ctx.moveTo(ex - headR * 0.24, headCy - headR * 0.42); ctx.lineTo(ex + headR * 0.24, headCy - headR * 0.46); ctx.stroke();
  }
  // bouche (sourire)
  ctx.beginPath();
  ctx.arc(cx, headCy + headR * 0.2, headR * 0.3, 0.15 * Math.PI, 0.85 * Math.PI);
  ctx.strokeStyle = gender === "Femme" ? "#c0392b" : skinDark;
  ctx.lineWidth = Math.max(2, 0.008 * W); ctx.stroke();
  // cheveux (dessus)
  ctx.fillStyle = vgrad(ctx, hair, headCy - headR, headCy + headR, 1.1, 0.85);
  if (style === "Court" || style === "Long") {
    ctx.beginPath();
    ctx.ellipse(cx, headCy, headR * 1.04, headR * 1.04, 0, Math.PI * (style === "Long" ? 1.02 : 1.06), Math.PI * (style === "Long" ? 1.98 : 1.94));
    ctx.ellipse(cx, headCy + headR * 0.18, headR * 0.85, headR * 0.7, 0, Math.PI, 0, true);
    ctx.fill();
  } else if (style === "Frisé") {
    for (let a = 0; a <= 180; a += 24) {
      const ax = cx + headR * 0.95 * Math.cos(a * Math.PI / 180);
      const ay = headCy - headR * 0.25 - headR * 0.78 * Math.sin(a * Math.PI / 180);
      ctx.beginPath(); ctx.ellipse(ax, ay, headR * 0.55, headR * 0.55, 0, 0, 7); ctx.fill();
    }
    ctx.beginPath(); ctx.ellipse(cx, headCy - headR * 0.55, headR * 0.85, headR * 0.55, 0, 0, 7); ctx.fill();
  }
  // "Chauve" : rien
}

// Rendu vers un <canvas> autonome (utilisé pour les listes).
export function avatarCanvas(av, W, H, opts) {
  const c = document.createElement("canvas");
  c.width = W; c.height = H; c.style.width = W + "px"; c.style.height = H + "px";
  drawAvatar(c, av, opts);
  return c;
}
