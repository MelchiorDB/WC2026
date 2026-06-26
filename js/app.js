// ============================================================================
//  Pronostics CdM 2026 - web app (front statique + Supabase)
//  Anti-triche : verrou au coup d'envoi + horodatage serveur (cf. schema.sql).
// ============================================================================
import { TEAMS, GROUPS, KO_R32, SKIN_TONES, HAIR_COLORS, HAIR_STYLES, GENDERS } from "./data.js";
import { FLAG } from "./config.js";
import * as api from "./api.js";
import { drawAvatar, avatarCanvas, avatarColors } from "./avatar.js";
import { spinTrophy, drawTrophy } from "./trophy.js";

const S = {
  session: null,                 // {name, pin, isAdmin, avatar}
  matches: [], matchById: {},
  players: [], playerById: {},
  preds: {},                     // preds[player_id][match_id] = {home,away,created_at}  (publics)
  mine: {},                      // mine[match_id] = {home,away,created_at,updated_at}
  view: "Par groupe", upcoming: false, tab: "pred", histPlayer: null,
};

// ---------- utilitaires ----------
const $ = (s, r = document) => r.querySelector(s);
const el = (t, p = {}, ...kids) => {
  const e = document.createElement(t);
  for (const [k, v] of Object.entries(p)) {
    if (k === "class") e.className = v;
    else if (k === "html") e.innerHTML = v;
    else if (k.startsWith("on")) e.addEventListener(k.slice(2), v);
    else if (v !== null && v !== undefined && v !== false) e.setAttribute(k, v);
  }
  for (const c of kids.flat()) if (c != null && c !== false) e.append(c.nodeType ? c : document.createTextNode(c));
  return e;
};
const teamFr = id => (TEAMS[id] ? TEAMS[id].fr : id);
const flag = id => el("img", { src: FLAG(TEAMS[id] ? TEAMS[id].code : "un"), alt: "", loading: "lazy" });
const MONTHS = ["", "janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"];
const WD = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"];
const dt = iso => new Date(iso);
function dateFr(iso) { const d = dt(iso); return `${WD[d.getDay()][0].toUpperCase()}${WD[d.getDay()].slice(1)} ${d.getDate()} ${MONTHS[d.getMonth() + 1]}`; }
function dateShort(iso) { const d = dt(iso); return `${String(d.getDate()).padStart(2, "0")}/${String(d.getMonth() + 1).padStart(2, "0")}`; }
function hhmm(iso) { const d = dt(iso); return `${String(d.getHours()).padStart(2, "0")}h${String(d.getMinutes()).padStart(2, "0")}`; }
const locked = m => Date.parse(m.kickoff) <= Date.now();
const result = m => (m.home_score != null && m.away_score != null) ? [m.home_score, m.away_score] : null;
const GROUP_COLORS = ["#2563eb", "#7c3aed", "#db2777", "#dc2626", "#ea580c", "#ca8a04", "#16a34a", "#0d9488", "#0891b2", "#4f46e5", "#9333ea", "#be123c"];
const MD_COLORS = ["#2563eb", "#7c3aed", "#0d9488"];
const KO_ROUNDS = ["16es", "8es", "Quarts", "Demies", "3e place", "Finale"];
const isKO = m => KO_ROUNDS.includes(m.grp);
const isReal = x => !!TEAMS[x];
const predictable = m => isReal(m.home) && isReal(m.away);   // équipes connues
function koLabel(x) {
  if (isReal(x)) return teamFr(x);
  if (/^[12][A-L]$/.test(x)) return (x[0] === "1" ? "1er " : "2e ") + "gr. " + x[1];
  if (x === "3rd") return "3e ?";
  let mt = x.match(/^V(\d+)$/); if (mt) return "Vainq. M" + mt[1];
  mt = x.match(/^P(\d+)$/); if (mt) return "Perdant M" + mt[1];
  return x;
}

// ---------- scoring (port de scoring.py) ----------
const sign = (a, b) => a > b ? 1 : a < b ? -1 : 0;
function scorePred(pred, res) {
  if (!pred || !res) return { pts: 0, exact: false };
  // mauvais vainqueur / nul => 0
  if (sign(pred[0], pred[1]) !== sign(res[0], res[1])) return { pts: 0, exact: false };
  // score exact => 3
  if (pred[0] === res[0] && pred[1] === res[1]) return { pts: 3, exact: true };
  // bon résultat : 2 si à 1 but près du vrai score, sinon 1
  const dist = Math.abs(pred[0] - res[0]) + Math.abs(pred[1] - res[1]);
  return { pts: dist <= 1 ? 2 : 1, exact: false };
}
function standings(filterFn) {
  const flt = filterFn || (() => true);
  const rows = S.players.map(p => {
    const pr = S.preds[p.id] || {};
    let total = 0, exact = 0, good = 0;
    for (const m of S.matches) {
      if (!flt(m)) continue;
      const res = result(m); if (!res) continue;
      const pred = pr[m.id]; if (!pred) continue;
      const { pts, exact: ex } = scorePred([pred.home, pred.away], res);
      if (pts) { total += pts; ex ? exact++ : good++; }
    }
    return { ...p, total, exact, good };
  });
  rows.sort((a, b) => b.total - a.total || b.exact - a.exact || a.name.localeCompare(b.name));
  return rows;
}
function groupTable(grp) {
  const teams = GROUPS[grp];
  const st = Object.fromEntries(teams.map(t => [t, { pts: 0, gd: 0, gf: 0, pl: 0 }]));
  let complete = true;
  for (const m of S.matches.filter(x => x.grp === grp)) {
    const res = result(m);
    if (!res) { complete = false; continue; }
    const [h, a] = res;
    st[m.home].pl++; st[m.away].pl++; st[m.home].gf += h; st[m.away].gf += a;
    st[m.home].gd += h - a; st[m.away].gd += a - h;
    if (h > a) st[m.home].pts += 3; else if (h < a) st[m.away].pts += 3; else { st[m.home].pts++; st[m.away].pts++; }
  }
  const order = [...teams].sort((x, y) => st[y].pts - st[x].pts || st[y].gd - st[x].gd || st[y].gf - st[x].gf || x.localeCompare(y));
  return { order, complete };
}

// ---------- chargement ----------
async function loadAll() {
  const [players, matches, pub, mine] = await Promise.all([
    api.getPlayers(), api.getMatches(), api.getPublicPredictions(),
    api.getMyPredictions(S.session.name, S.session.pin),
  ]);
  S.players = players;
  S.playerById = Object.fromEntries(players.map(p => [p.id, p]));
  S.matches = matches.sort((a, b) => a.kickoff.localeCompare(b.kickoff) || a.id.localeCompare(b.id));
  S.matchById = Object.fromEntries(matches.map(m => [m.id, m]));
  S.preds = {};
  for (const r of pub) (S.preds[r.player_id] ||= {})[r.match_id] = { home: r.home, away: r.away, created_at: r.created_at };
  S.mine = {}; for (const r of mine) S.mine[r.match_id] = r;
  // mes pronos sont aussi "publics" pour moi (affichage perso)
  const meId = players.find(p => p.name === S.session.name)?.id;
  if (meId) { S.preds[meId] ||= {}; for (const r of mine) S.preds[meId][r.match_id] = { home: r.home, away: r.away, created_at: r.created_at }; }
  if (!S.histPlayer) S.histPlayer = S.session.name;
}

// ---------- rendu : barre d'options ----------
function optBar(saveBtn) {
  const sel = el("select", { onchange: e => { S.view = e.target.value; renderTab(); } },
    ...["Par groupe", "Par jour"].map(v => el("option", { value: v, selected: v === S.view ? "" : null }, v)));
  const chk = el("input", { type: "checkbox", onchange: e => { S.upcoming = e.target.checked; renderTab(); } });
  chk.checked = S.upcoming;
  return el("div", { class: "optbar" },
    el("span", {}, "Affichage :"), sel,
    el("label", {}, chk, " Matchs à venir seulement"),
    saveBtn ? el("div", { class: "save" }, saveBtn) : null);
}

function filteredMatches() {
  let ms = S.matches;
  if (S.upcoming) ms = ms.filter(m => !locked(m));
  return ms;
}
function grouped(ms) {
  if (S.view === "Par jour") {
    const by = {};
    for (const m of ms) (by[m.kickoff.slice(0, 10)] ||= []).push(m);
    return Object.entries(by).map(([d, list]) => {
      const k = isKO(list[0]);
      return {
        title: `${dateFr(d)}  ·  ${k ? list[0].grp : "Journée " + list[0].matchday}`,
        color: k ? "#0f766e" : MD_COLORS[(list[0].matchday - 1) % 3], list,
      };
    });
  }
  const blocks = Object.keys(GROUPS).map((g, i) => ({
    title: `Groupe ${g}`, color: GROUP_COLORS[i % 12], list: ms.filter(m => m.grp === g),
  })).filter(b => b.list.length);
  for (const r of KO_ROUNDS) {
    const list = ms.filter(m => m.grp === r);
    if (list.length) blocks.push({ title: "Phase finale - " + r, color: "#0f766e", list });
  }
  return blocks;
}

// ---------- onglet Pronostics ----------
function tabPred() {
  const wrap = el("div", {});
  wrap.append(optBar(null));
  wrap.append(el("div", { class: "note" }, "Les scores se verrouillent au coup d'envoi (heure serveur). Ton pronostic est enregistré avec l'heure exacte. Les pronos des autres restent cachés jusqu'au coup d'envoi. Les matchs de phase finale apparaissent dès que les équipes sont connues."));
  const ms = filteredMatches().filter(predictable);   // groupes + KO dont les équipes sont connues
  if (!ms.length) { wrap.append(el("p", { class: "muted" }, "Aucun match à venir.")); return wrap; }
  for (const b of grouped(ms)) {
    const block = el("div", { class: "block" }, el("h3", { style: `background:${b.color}` }, b.title));
    for (const m of b.list) block.append(predRow(m));
    wrap.append(block);
  }
  return wrap;
}
function predRow(m) {
  const isLocked = locked(m), res = result(m);
  const mine = S.mine[m.id];
  const status = el("div", { class: "status" });
  const ih = el("input", { type: "number", min: 0, max: 99, value: mine ? mine.home : "" });
  const ia = el("input", { type: "number", min: 0, max: 99, value: mine ? mine.away : "" });
  if (isLocked) { ih.disabled = ia.disabled = true; }

  function paintStatus() {
    status.innerHTML = "";
    if (isLocked) {
      if (res) {
        const pred = (ih.value !== "" && ia.value !== "") ? [+ih.value, +ia.value] : (mine ? [mine.home, mine.away] : null);
        const { pts, exact } = scorePred(pred, res);
        status.append(el("span", { class: "muted" }, `Résultat ${res[0]}-${res[1]}  `),
          el("span", { class: "pill " + (exact ? "g" : pts ? "o" : "z") }, pred ? (pts ? "+" + pts : "0 pt") : "-"));
      } else {
        status.append(el("span", { class: "locked-badge" }, "verrouillé"),
          mine ? el("span", { class: "muted" }, ` ${mine.home}-${mine.away}`) : "");
      }
    } else {
      const sub = el("div", {});
      sub.append(el("div", { class: "when" }, "Coup d'envoi " + hhmm(m.kickoff)));
      if (mine && mine.updated_at) sub.append(el("span", { class: "pill g" }, "enregistré " + hhmm(mine.updated_at)));
      else sub.append(el("span", { class: "pill soon" }, "à pronostiquer"));
      status.append(sub);
    }
  }
  let timer;
  const onChange = () => {
    if (isLocked) return;
    clearTimeout(timer);
    timer = setTimeout(save, 500);
  };
  async function save() {
    if (ih.value === "" || ia.value === "") return;
    try {
      const r = await api.setPrediction(S.session.name, S.session.pin, m.id, +ih.value, +ia.value);
      if (r.error) {
        if (r.error === "locked") { toast("Match commencé, prono verrouillé.", "e"); await refresh(); return; }
        toast("Erreur : " + (r.message || r.error), "e"); return;
      }
      S.mine[m.id] = { home: +ih.value, away: +ia.value, updated_at: r.at, created_at: (mine && mine.created_at) || r.at };
      paintStatus();
    } catch (e) { toast("Réseau indisponible.", "e"); }
  }
  ih.addEventListener("input", onChange); ia.addEventListener("input", onChange);
  paintStatus();
  return el("div", { class: "row" },
    el("div", { class: "when" }, dateShort(m.kickoff), el("br"), "J" + m.matchday),
    el("div", { class: "team" }, flag(m.home), el("span", {}, teamFr(m.home))),
    el("div", { class: "score" }, ih, el("b", {}, "-"), ia),
    el("div", { class: "team away" }, flag(m.away), el("span", {}, teamFr(m.away))),
    status);
}

// ---------- onglet Classement ----------
function tabBoard() {
  const scopes = { "Général": null, "Poules": m => !isKO(m), "Phase finale": isKO };
  const scope = scopes[S.boardScope] !== undefined ? S.boardScope : "Général";
  const rows = standings(scopes[scope]);
  const prevTotal = +(localStorage.getItem("pron_total_" + S.session.name) || 0);
  const me = rows.find(r => r.name === S.session.name);
  const sel = el("select", { onchange: e => { S.boardScope = e.target.value; renderTab(); } },
    ...Object.keys(scopes).map(s => el("option", { value: s, selected: s === scope ? "" : null }, s)));
  const table = el("table", { class: "board" },
    el("tr", {}, el("th", {}, ""), el("th", {}, "Rang"), el("th", {}, "Joueur"),
      el("th", { class: "c" }, "Points"), el("th", { class: "c" }, "Exacts"), el("th", { class: "c" }, "Bons")));
  rows.forEach((r, i) => {
    const cls = i === 0 ? "gold" : i === 1 ? "silver" : i === 2 ? "bronze" : "";
    const cv = avatarCanvas(r.avatar, 30, 42, { withName: false });
    const nameCell = el("div", { class: "av" }, `${r.name}  N°${(r.avatar && r.avatar.number) ?? 10}`);
    if (i === 0 && r.total > 0) {
      const tc = el("canvas", { width: 26, height: 34 }); nameCell.append(tc); spinTrophy(tc);
    }
    table.append(el("tr", { class: cls },
      el("td", {}, cv), el("td", { class: "c" }, String(i + 1)),
      el("td", {}, nameCell),
      el("td", { class: "c" }, el("b", {}, String(r.total))),
      el("td", { class: "c" }, String(r.exact)), el("td", { class: "c" }, String(r.good))));
  });
  // animation de but si MON total GÉNÉRAL a augmenté depuis la dernière visite
  if (scope === "Général") {
    if (me && me.total > prevTotal) setTimeout(() => goalCelebration(me, me === rows[0]), 350);
    if (me) localStorage.setItem("pron_total_" + S.session.name, me.total);
  }
  return el("div", {},
    el("div", { class: "optbar" }, el("h2", {}, "Classement"), el("span", {}, "Tableau :"), sel),
    el("div", { class: "note" }, "Podium or / argent / bronze. « Poules » = points de la phase de groupes, « Phase finale » = points des matchs à élimination directe."), table);
}

// ---------- onglet Résultats ----------
function tabResults() {
  const wrap = el("div", {});
  wrap.append(el("h2", {}, "Résultats"));
  if (!S.session.isAdmin) {
    wrap.append(el("div", { class: "note" }, "Seul l'organisateur (admin) saisit les résultats et définit les équipes de la phase finale."));
  } else {
    wrap.append(el("div", { class: "optbar" },
      el("button", { class: "accent", onclick: fetchResultsWeb }, "Mettre à jour depuis le web"),
      el("button", { class: "small", onclick: autoFillKO }, "Phase finale : remplir 1ers/2es"),
      el("span", { class: "note" }, "Vide = non joué.")));
  }
  for (const b of grouped(S.matches)) {
    const block = el("div", { class: "block" }, el("h3", { style: `background:${b.color}` }, b.title));
    for (const m of b.list) block.append(resultRow(m));
    wrap.append(block);
  }
  return wrap;
}
function teamCellRO(x, away) {
  const cls = "team" + (away ? " away" : "");
  return isReal(x) ? el("div", { class: cls }, flag(x), el("span", {}, teamFr(x)))
                   : el("div", { class: cls }, el("span", { class: "muted" }, koLabel(x)));
}
function teamSelect(m, side) {
  const cur = side === "home" ? m.home : m.away;
  const list = Object.entries(TEAMS).map(([id, t]) => [id, t.fr]).sort((a, b) => a[1].localeCompare(b[1]));
  const sel = el("select", {},
    el("option", { value: cur, selected: "" }, isReal(cur) ? teamFr(cur) : koLabel(cur)),
    ...list.filter(([id]) => id !== cur).map(([id, fr]) => el("option", { value: id }, fr)));
  sel.addEventListener("change", async () => {
    const home = side === "home" ? sel.value : m.home, away = side === "away" ? sel.value : m.away;
    const r = await api.setMatchTeams(S.session.name, S.session.pin, m.id, home, away);
    if (r.error) return toast("Admin requis", "e");
    m.home = home; m.away = away; toast("Équipes mises à jour", "g"); renderTab();
  });
  return el("div", { class: "team" + (side === "away" ? " away" : "") }, sel);
}
function resultRow(m) {
  const res = result(m);
  const ih = el("input", { type: "number", min: 0, max: 99, value: res ? res[0] : "" });
  const ia = el("input", { type: "number", min: 0, max: 99, value: res ? res[1] : "" });
  if (!S.session.isAdmin) ih.disabled = ia.disabled = true;
  const save = async () => {
    if (ih.value === "" || ia.value === "") return;
    const r = await api.setResult(S.session.name, S.session.pin, m.id, +ih.value, +ia.value);
    if (r.error) return toast("Admin requis.", "e");
    m.home_score = +ih.value; m.away_score = +ia.value; toast("Résultat enregistré", "g");
  };
  ih.addEventListener("change", save); ia.addEventListener("change", save);
  const koAdmin = isKO(m) && S.session.isAdmin;
  return el("div", { class: "row" },
    el("div", { class: "when" }, dateShort(m.kickoff)),
    koAdmin ? teamSelect(m, "home") : teamCellRO(m.home, false),
    el("div", { class: "score" }, ih, el("b", {}, "-"), ia),
    koAdmin ? teamSelect(m, "away") : teamCellRO(m.away, true),
    el("div", {}));
}
async function autoFillKO() {
  const quals = {};
  for (const g of Object.keys(GROUPS)) { const t = groupTable(g); if (t.complete) quals[g] = { "1": t.order[0], "2": t.order[1] }; }
  const resolve = lab => { const mt = /^([12])([A-L])$/.exec(lab); return (mt && quals[mt[2]]) ? quals[mt[2]][mt[1]] : null; };
  let count = 0;
  for (const m of S.matches.filter(isKO)) {
    const nh = resolve(m.home), na = resolve(m.away);
    if (nh || na) {
      const home = nh || m.home, away = na || m.away;
      const r = await api.setMatchTeams(S.session.name, S.session.pin, m.id, home, away);
      if (r.ok) { m.home = home; m.away = away; count++; }
    }
  }
  toast(count ? `${count} match(s) renseigné(s)` : "Groupes pas encore terminés", "g");
  renderTab();
}
async function fetchResultsWeb() {
  toast("Recherche en ligne…");
  try {
    const base = "https://www.thesportsdb.com/api/v1/json/3";
    let count = 0;
    for (const r of [1, 2, 3]) {
      const d = await (await fetch(`${base}/eventsround.php?id=4429&r=${r}&s=2026`)).json();
      for (const ev of (d.events || [])) {
        const hs = parseInt(ev.intHomeScore), as = parseInt(ev.intAwayScore);
        if (isNaN(hs) || isNaN(as)) continue;
        const m = S.matches.find(x => sameTeams(x, ev.strHomeTeam, ev.strAwayTeam));
        if (!m) continue;
        const flip = !normEq(teamFr(m.home), ev.strHomeTeam) && !apiAlias(m.home, ev.strHomeTeam);
        const r2 = await api.setResult(S.session.name, S.session.pin, m.id, flip ? as : hs, flip ? hs : as);
        if (r2.ok) { m.home_score = flip ? as : hs; m.away_score = flip ? hs : as; count++; }
      }
    }
    toast(count ? `${count} résultat(s) mis à jour` : "Aucun nouveau résultat", "g");
    renderTab();
  } catch (e) { toast("API en ligne indisponible.", "e"); }
}
const norm = s => (s || "").normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().trim();
const normEq = (a, b) => norm(a) === norm(b);
function apiAlias(id, name) {
  const al = { "United States": ["usa"], "Bosnia": ["bosnia and herzegovina", "bosnia-herzegovina"], "Czechia": ["czech republic"], "South Korea": ["korea republic"], "Turkiye": ["turkey"] };
  return (al[id] || []).some(x => norm(x) === norm(name)) || norm(id) === norm(name) || normEq(teamFr(id), name);
}
function sameTeams(m, h, a) {
  const hit = id => apiAlias(id, h) || apiAlias(id, a);
  return hit(m.home) && hit(m.away);
}

// ---------- onglet Phase finale (tableau depuis la base) ----------
function tabBracket() {
  const wrap = el("div", {});
  wrap.append(el("h2", {}, "Tableau phase finale"));
  wrap.append(el("div", { class: "note" }, "Se remplit au fil du tournoi (l'admin définit les équipes). Pronostique les scores dans « Mes pronostics » dès que les deux équipes sont connues."));
  const br = el("div", { class: "bracket" });
  for (const round of KO_ROUNDS) {
    const list = S.matches.filter(m => m.grp === round)
      .sort((a, b) => a.id.localeCompare(b.id, undefined, { numeric: true }));
    if (!list.length) continue;
    const col = el("div", { class: "bcol" }, el("h4", {}, round));
    for (const m of list) {
      const res = result(m);
      const line = x => el("div", { class: isReal(x) ? "real" : "" },
        isReal(x) ? teamFr(x) : koLabel(x));
      const box = el("div", { class: "bbox" }, line(m.home), line(m.away));
      if (res) box.append(el("div", { class: "muted", style: "font-size:11px" }, `${res[0]} - ${res[1]}`));
      else box.append(el("div", { class: "muted", style: "font-size:10px" }, dateShort(m.kickoff)));
      col.append(box);
    }
    br.append(col);
  }
  wrap.append(br);
  return wrap;
}

// ---------- onglet Historique ----------
function tabHist() {
  const wrap = el("div", {});
  const sel = el("select", { onchange: e => { S.histPlayer = e.target.value; renderTab(); } },
    ...S.players.map(p => el("option", { value: p.name, selected: p.name === S.histPlayer ? "" : null }, p.name)));
  const p = S.players.find(x => x.name === S.histPlayer);
  const av = avatarCanvas(p ? p.avatar : {}, 40, 56, { withName: false });
  const pr = (p && S.preds[p.id]) || {};
  // résumé
  let total = 0, exact = 0, good = 0, n = 0;
  for (const m of S.matches) { const pred = pr[m.id]; if (!pred) continue; n++; const res = result(m); if (res) { const r = scorePred([pred.home, pred.away], res); if (r.pts) { total += r.pts; r.exact ? exact++ : good++; } } }
  wrap.append(el("div", { class: "optbar" }, el("span", {}, "Joueur :"), sel, av,
    el("b", {}, `${total} pts · ${exact} exacts · ${good} bons · ${n} pronos`)));
  if (p && p.name !== S.session.name)
    wrap.append(el("div", { class: "note" }, "Tu vois uniquement les pronos déjà révélés (coup d'envoi passé) des autres joueurs."));
  // groupé par jour
  const ids = Object.keys(pr).map(id => S.matchById[id]).filter(Boolean).sort((a, b) => a.kickoff.localeCompare(b.kickoff));
  const by = {}; for (const m of ids) (by[m.kickoff.slice(0, 10)] ||= []).push(m);
  for (const [d, list] of Object.entries(by)) {
    const k0 = isKO(list[0]);
    const block = el("div", { class: "block" }, el("h3", { style: `background:${k0 ? "#0f766e" : MD_COLORS[(list[0].matchday - 1) % 3]}` }, `${dateFr(d)} · ${k0 ? list[0].grp : "Journée " + list[0].matchday}`));
    for (const m of list) {
      const pred = pr[m.id], res = result(m);
      let pill;
      if (!res) pill = el("span", { class: "pill soon" }, "à venir");
      else { const r = scorePred([pred.home, pred.away], res); pill = el("span", { class: "pill " + (r.exact ? "g" : r.pts ? "o" : "z") }, r.pts ? "+" + r.pts : "0 pt"); }
      block.append(el("div", { class: "row" },
        el("div", { class: "team" }, flag(m.home), el("span", {}, teamFr(m.home))),
        el("div", { class: "score" }, el("b", {}, `${pred.home} - ${pred.away}`)),
        el("div", { class: "team away" }, flag(m.away), el("span", {}, teamFr(m.away))),
        el("div", { class: "status" }, res ? `Rés. ${res[0]}-${res[1]} ` : "", pill)));
    }
    wrap.append(block);
  }
  return wrap;
}

// ---------- onglet Joueurs ----------
function tabPlayers() {
  const wrap = el("div", {});
  wrap.append(el("div", { class: "optbar" }, el("h2", {}, "Joueurs"),
    el("button", { class: "accent save", onclick: () => avatarDialog() }, "Modifier mon avatar")));
  const g = el("div", { class: "gallery" });
  for (const p of S.players) {
    const cv = avatarCanvas(p.avatar, 150, 208, { pseudo: p.name, withName: true });
    g.append(el("div", { class: "pcard" }, cv, el("div", { class: "nm" }, p.name),
      el("div", { class: "muted" }, ((p.avatar && p.avatar.country && teamFr(p.avatar.country)) || "Couleur neutre") + " · N°" + ((p.avatar && p.avatar.number) ?? 10))));
  }
  wrap.append(g);
  return wrap;
}

// ---------- dialog avatar (mon avatar uniquement) ----------
function avatarDialog(firstTime = false) {
  const cur = { country: null, number: 10, gender: "Homme", skin: "Claire", hair: "Court", hair_color: "Brun", beard: false, ...(S.session.avatar || {}) };
  const countries = [["", "(Couleur neutre)"], ...Object.entries(TEAMS).map(([id, t]) => [id, t.fr]).sort((a, b) => a[1].localeCompare(b[1]))];
  const sel = (val, opts, onch) => el("select", { onchange: onch }, ...opts.map(o => el("option", { value: Array.isArray(o) ? o[0] : o, selected: (Array.isArray(o) ? o[0] : o) === val ? "" : null }, Array.isArray(o) ? o[1] : o)));
  const prev = el("canvas", { class: "preview", width: 220, height: 300 });
  const draw = () => drawAvatar(prev, cur, { pseudo: S.session.name, withName: true });
  const country = sel(cur.country || "", countries, e => { cur.country = e.target.value || null; draw(); });
  const gender = sel(cur.gender, GENDERS, e => { cur.gender = e.target.value; draw(); });
  const skin = sel(cur.skin, Object.keys(SKIN_TONES), e => { cur.skin = e.target.value; draw(); });
  const hair = sel(cur.hair, HAIR_STYLES, e => { cur.hair = e.target.value; draw(); });
  const hairc = sel(cur.hair_color, Object.keys(HAIR_COLORS), e => { cur.hair_color = e.target.value; draw(); });
  const num = el("input", { type: "number", min: 0, max: 99, value: cur.number });
  num.addEventListener("input", () => { cur.number = Math.max(0, Math.min(99, +num.value || 0)); draw(); });
  const beard = el("input", { type: "checkbox" }); beard.checked = cur.beard;
  beard.addEventListener("change", () => { cur.beard = beard.checked; draw(); });
  const overlay = el("div", { class: "modal", onclick: e => { if (!firstTime && e.target === overlay) overlay.remove(); } },
    el("div", { class: "modal-card" },
      el("div", { class: "form" },
        el("b", {}, firstTime ? `Bienvenue ${S.session.name} ! Crée ton avatar` : "Avatar de " + S.session.name),
        firstTime ? el("div", { class: "note" }, "Personnalise ton joueur, puis valide pour commencer à pronostiquer.") : null,
        el("label", {}, "Pays (maillot)", country),
        el("label", {}, "Genre", gender),
        el("label", {}, "Couleur de peau", skin),
        el("label", {}, "Cheveux", hair),
        el("label", {}, "Couleur cheveux", hairc),
        el("label", {}, "Numéro", num),
        el("label", { style: "flex-direction:row;align-items:center;gap:6px" }, beard, "Barbe"),
        el("div", { class: "actions" },
          el("button", { class: "accent", onclick: saveAvatar }, firstTime ? "Créer mon profil" : "Valider"),
          firstTime ? null : el("button", { class: "small", onclick: () => overlay.remove() }, "Annuler"))),
      prev));
  async function saveAvatar() {
    const r = await api.setAvatar(S.session.name, S.session.pin, cur);
    if (r.error) return toast("Erreur PIN", "e");
    S.session.avatar = cur; localStorage.setItem("pron_session", JSON.stringify(S.session));
    overlay.remove(); await refresh(); drawMe(); toast("Avatar enregistré", "g");
  }
  document.body.append(overlay); draw();
}

// ---------- animation de but ----------
function goalCelebration(player, isLeader = false) {
  const W = 460, H = 360;
  const cv = el("canvas", { width: W, height: H });
  const ov = el("div", { id: "goal-overlay", onclick: () => ov.remove() }, cv);
  document.body.append(ov);
  const ctx = cv.getContext("2d");
  const colors = ["#ef4444", "#f59e0b", "#10b981", "#3b82f6", "#8b5cf6", "#ec4899", "#fbbf24"];
  const parts = Array.from({ length: 70 }, () => ({ x: Math.random() * W, y: -Math.random() * H, vx: (Math.random() - .5) * 3, vy: 2 + Math.random() * 4, c: colors[(Math.random() * colors.length) | 0] }));
  const avC = avatarCanvas(player.avatar, 150, 210, { pseudo: player.name, withName: true });
  let t = 0;
  (function frame() {
    ctx.fillStyle = "#0b3d1e"; ctx.fillRect(0, 0, W, H);
    for (let i = 0; i < W; i += 56) { ctx.fillStyle = (i / 56) % 2 ? "#0b3d1e" : "#0e4a25"; ctx.fillRect(i, 0, 56, H); }
    ctx.drawImage(avC, W / 2 - 75, H - 230);
    if (isLeader) drawTrophy(ctx, W / 2 + 56, H - 150, 66, t / 180);   // coupe dans la main du leader
    for (const p of parts) { p.x += p.vx; p.y += p.vy; p.vy += .12; ctx.fillStyle = p.c; ctx.fillRect(p.x, p.y, 7, 11); }
    ctx.fillStyle = "#fde047"; ctx.font = "bold 30px sans-serif"; ctx.textAlign = "center";
    ctx.fillText("BUT !", W / 2, 50);
    ctx.fillStyle = "#fff"; ctx.font = "bold 17px sans-serif";
    ctx.fillText(`${player.name} marque !  ${player.total} pts`, W / 2, H - 14);
    if ((t += 33) < 2600 && document.body.contains(ov)) requestAnimationFrame(frame);
  })();
  setTimeout(() => ov.remove(), 2800);
}

// ---------- onglets ----------
const TABS = [
  ["pred", "Mes pronostics", tabPred],
  ["board", "Classement", tabBoard],
  ["results", "Résultats", tabResults],
  ["ko", "Phase finale", tabBracket],
  ["hist", "Historique", tabHist],
  ["players", "Joueurs", tabPlayers],
];
function renderTabs() {
  const nav = $("#tabs"); nav.innerHTML = "";
  for (const [id, label] of TABS)
    nav.append(el("button", { class: id === S.tab ? "active" : "", onclick: () => { S.tab = id; renderTabs(); renderTab(); } }, label));
}
function renderTab() {
  const fn = TABS.find(t => t[0] === S.tab)[2];
  const p = $("#panel"); p.innerHTML = ""; p.append(fn());
}
function drawMe() { drawAvatar($("#me-avatar"), S.session.avatar, { withName: false }); $("#me-name").textContent = S.session.name; }

async function refresh() { await loadAll(); renderTab(); }

// ---------- toast ----------
let toastT;
function toast(msg, type) {
  const t = $("#toast"); t.textContent = msg; t.className = "toast " + (type || "");
  t.hidden = false; clearTimeout(toastT); toastT = setTimeout(() => t.hidden = true, 1900);
}

// ---------- login ----------
async function doLogin(name, pin) {
  const r = await api.login(name, pin);
  if (r.error) { $("#login-msg").className = "msg err"; $("#login-msg").textContent = r.message || "Erreur."; return false; }
  S.session = { name: r.name, pin, isAdmin: r.is_admin, avatar: r.avatar || {} };
  localStorage.setItem("pron_session", JSON.stringify(S.session));
  await loadAll();
  $("#login").hidden = true; $("#app").hidden = false;
  const tt = $("#top-trophy"); if (tt && !tt._spin) { tt._spin = true; spinTrophy(tt); }
  renderTabs(); renderTab(); drawMe();
  // 1ère connexion (compte créé ou avatar vide) : créer son profil/avatar direct
  const fresh = r.new || !S.session.avatar || Object.keys(S.session.avatar).length === 0;
  if (fresh) { S.tab = "players"; renderTabs(); renderTab(); setTimeout(() => avatarDialog(true), 250); }
  return true;
}

async function main() {
  const lt = $("#login-trophy"); if (lt) spinTrophy(lt);   // coupe qui tourne (login)
  if (!api.configured()) { $("#login-config").hidden = false; return; }
  $("#login-btn").addEventListener("click", () =>
    doLogin($("#login-name").value.trim(), $("#login-pin").value));
  $("#login-pin").addEventListener("keydown", e => { if (e.key === "Enter") $("#login-btn").click(); });
  $("#logout").addEventListener("click", () => { localStorage.removeItem("pron_session"); location.reload(); });
  // session mémorisée ?
  const saved = localStorage.getItem("pron_session");
  if (saved) {
    try { const s = JSON.parse(saved); if (await doLogin(s.name, s.pin)) return; } catch (e) {}
  }
}
main();
