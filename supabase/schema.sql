-- ============================================================================
--  Pronostics CdM 2026 - schéma Supabase (anti-triche serveur)
--  À exécuter une fois dans : Supabase > SQL Editor > New query > Run.
--
--  Principes anti-triche :
--   - les écritures passent par des fonctions SECURITY DEFINER qui horodatent
--     côté SERVEUR (now()) et refusent tout prono après le coup d'envoi ;
--   - les pronos des autres ne sont visibles qu'APRÈS le coup d'envoi
--     (politique RLS), donc impossible de copier avant ;
--   - le PIN n'est jamais exposé (hash bcrypt, colonne non lisible).
-- ============================================================================

create extension if not exists pgcrypto with schema extensions;

-- ---------- Tables ----------------------------------------------------------
create table if not exists app_config (
  key   text primary key,
  value text not null
);

create table if not exists players (
  id         uuid primary key default gen_random_uuid(),
  name       text unique not null,
  pin_hash   text not null,
  avatar     jsonb not null default '{}'::jsonb,
  is_admin   boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists matches (
  id         text primary key,
  grp        text not null,
  matchday   int  not null,
  home       text not null,
  away       text not null,
  kickoff    timestamptz not null,
  home_score int,
  away_score int
);

create table if not exists predictions (
  player_id  uuid not null references players(id) on delete cascade,
  match_id   text not null references matches(id),
  home       int  not null check (home between 0 and 99),
  away       int  not null check (away between 0 and 99),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (player_id, match_id)
);

-- ---------- RLS (lecture publique contrôlée, écritures via RPC) -------------
alter table players     enable row level security;
alter table matches     enable row level security;
alter table predictions enable row level security;
alter table app_config  enable row level security;

-- joueurs : lignes visibles, mais on RÉVOQUE la colonne pin_hash pour anon
drop policy if exists players_read on players;
create policy players_read on players for select using (true);
revoke select on players from anon, authenticated;
grant  select (id, name, avatar, is_admin, created_at) on players to anon, authenticated;

-- matchs : tout public (calendrier + résultats)
drop policy if exists matches_read on matches;
create policy matches_read on matches for select using (true);

-- pronostics : visibles seulement une fois le coup d'envoi PASSÉ
drop policy if exists predictions_read on predictions;
create policy predictions_read on predictions for select using (
  exists (select 1 from matches m where m.id = predictions.match_id and m.kickoff <= now())
);

-- app_config : non lisible par les clients (admin_secret reste secret)
-- (aucune policy => aucune lecture côté anon)

-- ---------- Fonctions utilitaires -------------------------------------------
create or replace function _player_by_pin(p_name text, p_pin text)
returns players language sql stable security definer set search_path = public, extensions as $$
  select * from players
  where name = p_name and pin_hash = crypt(p_pin, pin_hash)
  limit 1;
$$;

-- ---------- Inscription / connexion ----------------------------------------
create or replace function register_or_login(p_name text, p_pin text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players;
begin
  p_name := trim(p_name);
  if p_name = '' or length(coalesce(p_pin,'')) < 3 then
    return jsonb_build_object('error', 'invalid', 'message', 'Pseudo requis et PIN >= 3 caractères.');
  end if;

  select * into pl from players where name = p_name;
  if found then
    if pl.pin_hash = crypt(p_pin, pl.pin_hash) then
      return jsonb_build_object('ok', true, 'id', pl.id, 'name', pl.name,
                                'avatar', pl.avatar, 'is_admin', pl.is_admin, 'new', false);
    else
      return jsonb_build_object('error', 'pin', 'message', 'Code PIN incorrect.');
    end if;
  end if;

  insert into players(name, pin_hash) values (p_name, crypt(p_pin, gen_salt('bf')))
  returning * into pl;
  return jsonb_build_object('ok', true, 'id', pl.id, 'name', pl.name,
                            'avatar', pl.avatar, 'is_admin', false, 'new', true);
end;
$$;

create or replace function change_pin(p_name text, p_old text, p_new text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players;
begin
  pl := _player_by_pin(p_name, p_old);
  if pl.id is null then return jsonb_build_object('error','pin'); end if;
  if length(coalesce(p_new,'')) < 3 then return jsonb_build_object('error','invalid'); end if;
  update players set pin_hash = crypt(p_new, gen_salt('bf')) where id = pl.id;
  return jsonb_build_object('ok', true);
end;
$$;

-- ---------- Avatar ----------------------------------------------------------
create or replace function set_avatar(p_name text, p_pin text, p_avatar jsonb)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players;
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null then return jsonb_build_object('error','pin'); end if;
  update players set avatar = p_avatar where id = pl.id;
  return jsonb_build_object('ok', true);
end;
$$;

-- ---------- Pronostic (ANTI-TRICHE : verrou au coup d'envoi) ----------------
create or replace function set_prediction(p_name text, p_pin text, p_match text,
                                          p_home int, p_away int)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players; m matches; ts timestamptz := now();
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null then return jsonb_build_object('error','pin'); end if;

  select * into m from matches where id = p_match;
  if not found then return jsonb_build_object('error','match'); end if;

  -- VERROU : on refuse tout prono une fois le coup d'envoi atteint (heure serveur)
  if m.kickoff <= ts then
    return jsonb_build_object('error','locked','message','Match commencé, pronostic verrouillé.');
  end if;
  if p_home is null or p_away is null or p_home < 0 or p_away < 0
     or p_home > 99 or p_away > 99 then
    return jsonb_build_object('error','score');
  end if;

  insert into predictions(player_id, match_id, home, away, created_at, updated_at)
  values (pl.id, p_match, p_home, p_away, ts, ts)
  on conflict (player_id, match_id)
  do update set home = excluded.home, away = excluded.away, updated_at = ts;

  return jsonb_build_object('ok', true, 'at', ts);
end;
$$;

create or replace function delete_prediction(p_name text, p_pin text, p_match text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players; m matches;
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null then return jsonb_build_object('error','pin'); end if;
  select * into m from matches where id = p_match;
  if found and m.kickoff <= now() then
    return jsonb_build_object('error','locked');
  end if;
  delete from predictions where player_id = pl.id and match_id = p_match;
  return jsonb_build_object('ok', true);
end;
$$;

-- mes propres pronos (y compris ceux NON encore visibles publiquement)
create or replace function get_my_predictions(p_name text, p_pin text)
returns table(match_id text, home int, away int, created_at timestamptz, updated_at timestamptz)
language plpgsql security definer set search_path = public, extensions as $$
declare pl players;
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null then return; end if;
  return query select pr.match_id, pr.home, pr.away, pr.created_at, pr.updated_at
               from predictions pr where pr.player_id = pl.id;
end;
$$;

-- ---------- Résultats (ADMIN seulement) -------------------------------------
create or replace function set_result(p_name text, p_pin text, p_match text,
                                      p_home int, p_away int)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players;
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null or not pl.is_admin then return jsonb_build_object('error','admin'); end if;
  update matches set home_score = p_home, away_score = p_away where id = p_match;
  return jsonb_build_object('ok', true);
end;
$$;

create or replace function set_kickoff(p_name text, p_pin text, p_match text, p_kick timestamptz)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players;
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null or not pl.is_admin then return jsonb_build_object('error','admin'); end if;
  update matches set kickoff = p_kick where id = p_match;
  return jsonb_build_object('ok', true);
end;
$$;

-- devenir admin avec le secret stocké dans app_config('admin_secret')
create or replace function claim_admin(p_name text, p_pin text, p_secret text)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare pl players; sec text;
begin
  pl := _player_by_pin(p_name, p_pin);
  if pl.id is null then return jsonb_build_object('error','pin'); end if;
  select value into sec from app_config where key = 'admin_secret';
  if sec is null or p_secret <> sec then return jsonb_build_object('error','secret'); end if;
  update players set is_admin = true where id = pl.id;
  return jsonb_build_object('ok', true);
end;
$$;

-- droits d'exécution pour les clients web
grant execute on function register_or_login, change_pin, set_avatar, set_prediction,
  delete_prediction, get_my_predictions, set_result, set_kickoff, claim_admin
  to anon, authenticated;

-- secret admin par défaut (À CHANGER) : permet à un joueur de devenir organisateur
insert into app_config(key, value) values ('admin_secret', 'change-moi-2026')
  on conflict (key) do nothing;
