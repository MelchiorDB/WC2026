// ============================================================================
//  Couche d'accès Supabase (REST/PostgREST via fetch, sans dépendance).
//  Toutes les écritures passent par des fonctions RPC SECURITY DEFINER qui
//  horodatent côté serveur et appliquent le verrou au coup d'envoi.
// ============================================================================
import { SUPABASE_URL, SUPABASE_ANON_KEY } from "./config.js";

const HEADERS = {
  "apikey": SUPABASE_ANON_KEY,
  "Authorization": "Bearer " + SUPABASE_ANON_KEY,
  "Content-Type": "application/json",
};

export function configured() {
  return !SUPABASE_URL.includes("VOTRE-PROJET") && !SUPABASE_ANON_KEY.includes("VOTRE_CLE");
}

async function rpc(fn, args) {
  const r = await fetch(`${SUPABASE_URL}/rest/v1/rpc/${fn}`, {
    method: "POST", headers: HEADERS, body: JSON.stringify(args || {}),
  });
  if (!r.ok) throw new Error(`${fn}: HTTP ${r.status}`);
  return r.json();
}

async function select(path) {
  const r = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, { headers: HEADERS });
  if (!r.ok) throw new Error(`select ${path}: HTTP ${r.status}`);
  return r.json();
}

// -- auth (pseudo + PIN) -----------------------------------------------------
export const login = (name, pin) => rpc("register_or_login", { p_name: name, p_pin: pin });
export const changePin = (name, pin, np) => rpc("change_pin", { p_name: name, p_old: pin, p_new: np });
export const claimAdmin = (name, pin, secret) =>
  rpc("claim_admin", { p_name: name, p_pin: pin, p_secret: secret });

// -- lectures publiques ------------------------------------------------------
export const getPlayers = () => select("players?select=id,name,avatar,is_admin&order=name");
export const getMatches = () => select("matches?select=*");
// pronos visibles = uniquement ceux dont le coup d'envoi est passé (RLS serveur)
export const getPublicPredictions = () =>
  select("predictions?select=player_id,match_id,home,away,created_at");

// -- écritures (RPC, anti-triche) -------------------------------------------
export const getMyPredictions = (name, pin) =>
  rpc("get_my_predictions", { p_name: name, p_pin: pin });
export const setPrediction = (name, pin, match, home, away) =>
  rpc("set_prediction", { p_name: name, p_pin: pin, p_match: match, p_home: home, p_away: away });
export const deletePrediction = (name, pin, match) =>
  rpc("delete_prediction", { p_name: name, p_pin: pin, p_match: match });
export const setAvatar = (name, pin, avatar) =>
  rpc("set_avatar", { p_name: name, p_pin: pin, p_avatar: avatar });
export const setResult = (name, pin, match, home, away) =>
  rpc("set_result", { p_name: name, p_pin: pin, p_match: match, p_home: home, p_away: away });
export const setKickoff = (name, pin, match, kickoffIso) =>
  rpc("set_kickoff", { p_name: name, p_pin: pin, p_match: match, p_kick: kickoffIso });
export const setMatchTeams = (name, pin, match, home, away) =>
  rpc("set_match_teams", { p_name: name, p_pin: pin, p_match: match, p_home: home, p_away: away });
