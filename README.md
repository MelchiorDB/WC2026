# Pronostics CdM 2026 - version web (GitHub Pages + Supabase)

Web app multi-utilisateurs : chaque ami crée ses pronos depuis son téléphone /
PC, avec **anti-triche serveur** (verrou au coup d'envoi + horodatage), un
**classement partagé en direct**, des **avatars**, l'**arbre des phases finales**,
l'**historique** et l'**animation de but**.

## Comment marche l'anti-triche

- Tu enregistres un prono : le serveur l'**horodate lui-même** (impossible de
  mentir sur l'heure) et **refuse tout prono une fois le coup d'envoi atteint**.
- Les pronos des autres joueurs restent **cachés jusqu'au coup d'envoi** du match
  (donc personne ne peut copier).
- Le PIN n'est jamais exposé (haché en base). La clé "anon" Supabase est publique
  par design : ce sont les règles serveur (RLS + fonctions) qui protègent.

## Déploiement (une fois, ~15 min)

### 1. Créer la base Supabase (gratuit)
1. Va sur https://supabase.com, crée un compte, **New project** (note le mot de
   passe DB, garde la région proche).
2. Ouvre **SQL Editor > New query**, colle tout `supabase/schema.sql`, **Run**.
3. (Migration de tes données) Nouvelle query, colle `supabase/seed.sql`, **Run**.
   Ça crée tes 11 joueurs (avatars + pronos + 13 résultats + les 72 matchs).
   - **PIN par défaut de chaque joueur : `0000`** (chacun le changera dans l'app).
   - L'organisateur **Melchior** est marqué admin (peut saisir les résultats).

### 2. Brancher le front
Dans **Project Settings > API**, copie *Project URL* et la clé *anon public*,
puis colle-les dans `js/config.js` :
```js
export const SUPABASE_URL = "https://xxxx.supabase.co";
export const SUPABASE_ANON_KEY = "eyJhbGciOi...";
```

### 3. Publier sur GitHub Pages
1. Crée un dépôt GitHub, pousse le contenu de ce dossier (`index.html` à la racine).
2. **Settings > Pages > Build from branch**, branche `main`, dossier `/ (root)`, Save.
3. L'URL publique apparaît (ex. `https://ton-pseudo.github.io/pronostics/`).
   Partage-la aux amis.

### 4. Première connexion
- Chaque ami ouvre l'URL, entre son **pseudo + PIN**.
  - Migrés : pseudo existant + PIN `0000` (à changer ensuite).
  - Nouveau pseudo = nouveau compte (PIN au choix).
- Onglet **Joueurs** : "Modifier mon avatar".

## Côté organisateur (admin)

- Onglet **Résultats** : saisir les scores réels (toi seul, car admin), ou
  **Mettre à jour depuis le web** (récupère via l'API TheSportsDB).
- Les **heures de coup d'envoi** sont par défaut à 18:00 UTC. Pour les vraies
  heures, l'admin peut les ajuster (fonction `set_kickoff`) ou via une requête SQL
  `update matches set kickoff = '...' where id = '...';`.
- **Sécurité** : change le secret admin dans la table `app_config`
  (`admin_secret`), il permet à un joueur de devenir organisateur via la fonction
  `claim_admin(pseudo, pin, secret)`.

## Fichiers

| Fichier | Rôle |
|---|---|
| `index.html`, `css/style.css` | page + style |
| `js/data.js` | équipes, groupes, calendrier, bracket (généré depuis l'app bureau) |
| `js/config.js` | **à remplir** : URL + clé Supabase |
| `js/api.js` | appels Supabase (RPC + lectures) |
| `js/avatar.js` | rendu des avatars (Canvas) |
| `js/app.js` | logique, onglets, anti-triche, animations |
| `supabase/schema.sql` | base + règles anti-triche (à exécuter en 1er) |
| `supabase/seed.sql` | **migration** de tes pronos existants (à exécuter en 2e) |

## Bon à savoir
- Le PIN à 4 chiffres reste léger : suffisant entre amis, pas une vraie sécurité.
- Niveau gratuit Supabase largement suffisant pour un groupe d'amis.
- Pour repartir de zéro : `truncate predictions, players, matches, app_config;`
  puis relancer `schema.sql` + `seed.sql`.
