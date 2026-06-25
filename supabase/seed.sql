-- Migration des pronos existants (à exécuter APRÈS schema.sql)
-- PIN par défaut de chaque joueur : 0000  (à changer dans l'app)

insert into matches(id, grp, matchday, home, away, kickoff, home_score, away_score) values
  ('A1','A',1,'Mexico','South Africa','2026-06-11T18:00:00Z',2,0),
  ('A2','A',1,'South Korea','Czechia','2026-06-11T18:00:00Z',2,1),
  ('B1','B',1,'Canada','Bosnia','2026-06-12T18:00:00Z',1,1),
  ('D1','D',1,'United States','Paraguay','2026-06-12T18:00:00Z',4,1),
  ('B2','B',1,'Qatar','Switzerland','2026-06-13T18:00:00Z',null,null),
  ('C1','C',1,'Brazil','Morocco','2026-06-13T18:00:00Z',1,1),
  ('C2','C',1,'Haiti','Scotland','2026-06-13T18:00:00Z',null,null),
  ('D2','D',1,'Australia','Turkiye','2026-06-13T18:00:00Z',null,null),
  ('E1','E',1,'Germany','Curacao','2026-06-14T18:00:00Z',null,null),
  ('F1','F',1,'Netherlands','Japan','2026-06-14T18:00:00Z',null,null),
  ('E2','E',1,'Ivory Coast','Ecuador','2026-06-14T18:00:00Z',null,null),
  ('F2','F',1,'Sweden','Tunisia','2026-06-14T18:00:00Z',null,null),
  ('H1','H',1,'Spain','Cape Verde','2026-06-15T18:00:00Z',null,null),
  ('G1','G',1,'Belgium','Egypt','2026-06-15T18:00:00Z',null,null),
  ('H2','H',1,'Saudi Arabia','Uruguay','2026-06-15T18:00:00Z',null,null),
  ('G2','G',1,'Iran','New Zealand','2026-06-15T18:00:00Z',null,null),
  ('I1','I',1,'France','Senegal','2026-06-16T18:00:00Z',3,1),
  ('I2','I',1,'Iraq','Norway','2026-06-16T18:00:00Z',1,4),
  ('J1','J',1,'Argentina','Algeria','2026-06-16T18:00:00Z',3,0),
  ('J2','J',1,'Austria','Jordan','2026-06-16T18:00:00Z',3,1),
  ('K1','K',1,'Portugal','DR Congo','2026-06-17T18:00:00Z',1,1),
  ('L1','L',1,'England','Croatia','2026-06-17T18:00:00Z',4,2),
  ('L2','L',1,'Ghana','Panama','2026-06-17T18:00:00Z',1,0),
  ('K2','K',1,'Uzbekistan','Colombia','2026-06-17T18:00:00Z',1,3),
  ('A3','A',2,'Czechia','South Africa','2026-06-18T18:00:00Z',null,null),
  ('B3','B',2,'Switzerland','Bosnia','2026-06-18T18:00:00Z',null,null),
  ('B4','B',2,'Canada','Qatar','2026-06-18T18:00:00Z',null,null),
  ('A4','A',2,'Mexico','South Korea','2026-06-18T18:00:00Z',null,null),
  ('C3','C',2,'Scotland','Morocco','2026-06-19T18:00:00Z',null,null),
  ('D3','D',2,'United States','Australia','2026-06-19T18:00:00Z',null,null),
  ('C4','C',2,'Brazil','Haiti','2026-06-19T18:00:00Z',null,null),
  ('D4','D',2,'Turkiye','Paraguay','2026-06-19T18:00:00Z',null,null),
  ('F3','F',2,'Netherlands','Sweden','2026-06-20T18:00:00Z',null,null),
  ('E3','E',2,'Germany','Ivory Coast','2026-06-20T18:00:00Z',null,null),
  ('E4','E',2,'Ecuador','Curacao','2026-06-20T18:00:00Z',null,null),
  ('F4','F',2,'Tunisia','Japan','2026-06-20T18:00:00Z',null,null),
  ('H3','H',2,'Spain','Saudi Arabia','2026-06-21T18:00:00Z',null,null),
  ('G3','G',2,'Belgium','Iran','2026-06-21T18:00:00Z',null,null),
  ('H4','H',2,'Uruguay','Cape Verde','2026-06-21T18:00:00Z',null,null),
  ('G4','G',2,'New Zealand','Egypt','2026-06-21T18:00:00Z',null,null),
  ('J3','J',2,'Argentina','Austria','2026-06-22T18:00:00Z',null,null),
  ('I3','I',2,'France','Iraq','2026-06-22T18:00:00Z',null,null),
  ('I4','I',2,'Norway','Senegal','2026-06-22T18:00:00Z',null,null),
  ('J4','J',2,'Jordan','Algeria','2026-06-22T18:00:00Z',null,null),
  ('K3','K',2,'Portugal','Uzbekistan','2026-06-23T18:00:00Z',null,null),
  ('L3','L',2,'England','Ghana','2026-06-23T18:00:00Z',null,null),
  ('L4','L',2,'Panama','Croatia','2026-06-23T18:00:00Z',null,null),
  ('K4','K',2,'Colombia','DR Congo','2026-06-23T18:00:00Z',null,null),
  ('B5','B',3,'Switzerland','Canada','2026-06-24T18:00:00Z',null,null),
  ('B6','B',3,'Bosnia','Qatar','2026-06-24T18:00:00Z',null,null),
  ('C5','C',3,'Scotland','Brazil','2026-06-24T18:00:00Z',null,null),
  ('C6','C',3,'Morocco','Haiti','2026-06-24T18:00:00Z',null,null),
  ('A5','A',3,'Czechia','Mexico','2026-06-24T18:00:00Z',null,null),
  ('A6','A',3,'South Africa','South Korea','2026-06-24T18:00:00Z',null,null),
  ('E5','E',3,'Ecuador','Germany','2026-06-25T18:00:00Z',null,null),
  ('E6','E',3,'Curacao','Ivory Coast','2026-06-25T18:00:00Z',null,null),
  ('F5','F',3,'Japan','Sweden','2026-06-25T18:00:00Z',null,null),
  ('F6','F',3,'Tunisia','Netherlands','2026-06-25T18:00:00Z',null,null),
  ('D5','D',3,'Turkiye','United States','2026-06-25T18:00:00Z',null,null),
  ('D6','D',3,'Paraguay','Australia','2026-06-25T18:00:00Z',null,null),
  ('I5','I',3,'Norway','France','2026-06-26T18:00:00Z',null,null),
  ('I6','I',3,'Senegal','Iraq','2026-06-26T18:00:00Z',null,null),
  ('H5','H',3,'Cape Verde','Saudi Arabia','2026-06-26T18:00:00Z',null,null),
  ('H6','H',3,'Uruguay','Spain','2026-06-26T18:00:00Z',null,null),
  ('G5','G',3,'Egypt','Iran','2026-06-26T18:00:00Z',null,null),
  ('G6','G',3,'New Zealand','Belgium','2026-06-26T18:00:00Z',null,null),
  ('L5','L',3,'Panama','England','2026-06-27T18:00:00Z',null,null),
  ('L6','L',3,'Croatia','Ghana','2026-06-27T18:00:00Z',null,null),
  ('K5','K',3,'Colombia','Portugal','2026-06-27T18:00:00Z',null,null),
  ('K6','K',3,'DR Congo','Uzbekistan','2026-06-27T18:00:00Z',null,null),
  ('J5','J',3,'Algeria','Austria','2026-06-27T18:00:00Z',null,null),
  ('J6','J',3,'Jordan','Argentina','2026-06-27T18:00:00Z',null,null)
on conflict (id) do update set home_score = excluded.home_score, away_score = excluded.away_score, kickoff = matches.kickoff;

insert into players(name, pin_hash, avatar, is_admin) values ('Moe', crypt('0000', gen_salt('bf')), '{"country": "Morocco", "number": 67, "gender": "Homme", "skin": "Hâlée", "hair": "Court", "hair_color": "Noir", "beard": true}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Melchior', crypt('0000', gen_salt('bf')), '{"country": "France", "number": 10, "gender": "Homme", "skin": "Claire", "hair": "Court", "hair_color": "Brun", "beard": false}'::jsonb, true) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Arnaud', crypt('0000', gen_salt('bf')), '{"country": "France", "number": 7, "gender": "Homme", "skin": "Claire", "hair": "Court", "hair_color": "Châtain", "beard": true}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Julie', crypt('0000', gen_salt('bf')), '{"country": "France", "number": 12, "gender": "Femme", "skin": "Claire", "hair": "Long", "hair_color": "Brun", "beard": false}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Martin', crypt('0000', gen_salt('bf')), '{"country": "Switzerland", "number": 13, "gender": "Homme", "skin": "Claire", "hair": "Long", "hair_color": "Brun", "beard": true}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Séraphin', crypt('0000', gen_salt('bf')), '{"country": "Ivory Coast", "number": 10, "gender": "Homme", "skin": "Foncée", "hair": "Court", "hair_color": "Noir", "beard": true}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Fabiana', crypt('0000', gen_salt('bf')), '{"country": "Brazil", "number": 7, "gender": "Femme", "skin": "Hâlée", "hair": "Long", "hair_color": "Brun", "beard": false}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Malo', crypt('0000', gen_salt('bf')), '{"country": "Cape Verde", "number": 23, "gender": "Femme", "skin": "Claire", "hair": "Court", "hair_color": "Brun", "beard": false}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Nathan', crypt('0000', gen_salt('bf')), '{"country": "Switzerland", "number": 13, "gender": "Homme", "skin": "Hâlée", "hair": "Court", "hair_color": "Brun", "beard": true}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('Dantonnerre', crypt('0000', gen_salt('bf')), '{"country": "France", "number": 9, "gender": "Homme", "skin": "Claire", "hair": "Court", "hair_color": "Brun", "beard": true}'::jsonb, false) on conflict (name) do nothing;
insert into players(name, pin_hash, avatar, is_admin) values ('abdul', crypt('0000', gen_salt('bf')), '{"country": "France", "number": 3, "gender": "Homme", "skin": "Foncée", "hair": "Court", "hair_color": "Brun", "beard": true}'::jsonb, false) on conflict (name) do nothing;

insert into predictions(player_id, match_id, home, away, created_at, updated_at)
select id, 'I1', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'I2', 0, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'J1', 5, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'J2', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'K1', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'L1', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'L2', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'K2', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'A3', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'B3', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'B4', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'A4', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'C3', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'D3', 4, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'C4', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'D4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'F3', 3, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'E3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'E4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'F4', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'H3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'G3', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'H4', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'G4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'J3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'I3', 4, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'I4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'J4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Moe'
union all
select id, 'I1', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'I2', 0, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'J1', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'J2', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'K1', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'L1', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'L2', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'K2', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'A3', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'B3', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'B4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'A4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'C3', 0, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'D3', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'C4', 5, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'D4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'F3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'E3', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'E4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'F4', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'H3', 4, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'G3', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'H4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'G4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'J3', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'I3', 8, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'I4', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'J4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Melchior'
union all
select id, 'K1', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'L1', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'L2', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'K2', 0, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'C3', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'D3', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'C4', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'D4', 0, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'F3', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'E3', 4, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Arnaud'
union all
select id, 'K1', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Julie'
union all
select id, 'L1', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Julie'
union all
select id, 'L2', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Julie'
union all
select id, 'K2', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Julie'
union all
select id, 'K1', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Martin'
union all
select id, 'L1', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Martin'
union all
select id, 'L2', 0, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Martin'
union all
select id, 'K2', 2, 4, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Martin'
union all
select id, 'K3', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Martin'
union all
select id, 'K1', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Séraphin'
union all
select id, 'L1', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Séraphin'
union all
select id, 'L2', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Séraphin'
union all
select id, 'K2', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Séraphin'
union all
select id, 'A3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Fabiana'
union all
select id, 'B3', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Fabiana'
union all
select id, 'B4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Fabiana'
union all
select id, 'A4', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Fabiana'
union all
select id, 'C3', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'D3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'C4', 4, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'D4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'F3', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'E3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'E4', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'F4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'H3', 5, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'G3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'H4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'G4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'J3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'I3', 4, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'I4', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'J4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'K3', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'L3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'L4', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'K4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'B5', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'B6', 0, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'C5', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'C6', 4, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'A5', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'A6', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Malo'
union all
select id, 'C3', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'D3', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'C4', 4, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'D4', 2, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'F3', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'E3', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'E4', 4, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'F4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'H3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'G3', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'H4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'G4', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'J3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'I3', 5, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'I4', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'J4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'K3', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'L3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'L4', 0, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'K4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'B5', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'B6', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'C5', 1, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'C6', 3, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'A5', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'A6', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Nathan'
union all
select id, 'C3', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'D3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'C4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'D4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'F3', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'E3', 2, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'E4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'F4', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'H3', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'G3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'H4', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'G4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'J3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'I3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'I4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'J4', 0, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'K3', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'L3', 4, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'L4', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'K4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'B5', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'B6', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'C5', 1, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'C6', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'A5', 0, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'A6', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'Dantonnerre'
union all
select id, 'C3', 0, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'D3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'C4', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'D4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'F3', 2, 3, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'E3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'E4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'F4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'H3', 3, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'G3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'H4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'G4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'J3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'I3', 5, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'I4', 3, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'J4', 0, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'K3', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'L3', 3, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'L4', 0, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'K4', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'B5', 2, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'B6', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'C5', 1, 2, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'C6', 2, 0, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'A5', 0, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
union all
select id, 'A6', 1, 1, '2026-06-01 12:00:00+00'::timestamptz, '2026-06-01 12:00:00+00'::timestamptz from players where name = 'abdul'
on conflict (player_id, match_id) do update set home = excluded.home, away = excluded.away;
