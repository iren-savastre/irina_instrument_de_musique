# Mémoire partagée du projet

Journal de bord versionné avec le dépôt : état d'avancement, décisions et prochaines étapes, pour reprendre le travail dans une autre session ou sur une autre machine. Importé automatiquement par `CLAUDE.md`.

Règles de mise à jour :
- Mettre à jour à la fin de chaque étape ou session (section « État actuel », « Prochaines étapes », et une entrée datée dans « Historique »).
- Ne noter que ce que le code et git ne disent pas : décisions et leur raison, questions ouvertes, travail en cours.
- Dates absolues (AAAA-MM-JJ). Pas de mots de passe ni de secrets.

## État actuel

- Squelette Symfony 7.4 `webapp` créé, aucune entité/contrôleur/test encore.
- `vendor/` absent : lancer `composer install` (dans WSL) avant toute commande Symfony.
- Config BDD encore en **PostgreSQL** (héritage du squelette) alors que la cible est **MariaDB**.
- Claude Code configuré : `CLAUDE.md`, `README.md`, 8 agents dans `.claude/agents/`, cette mémoire.
- Branche courante : `main` ; rien de tout cela n'est encore commité.

## Décisions

| Date | Décision | Raison |
|------|----------|--------|
| 2026-11-09 | Tout en français (conversation, commits, contenus) ; autres langues plus tard via `translations/` | Demande de l'utilisatrice |
| 2026-11-09 | Base MariaDB + phpMyAdmin (et non PostgreSQL) | Choix de stack du projet |
| 2026-11-09 | Dépôt de référence : `git@github.com:iren-savastre/irina_instrument_de_musique.git` | Confirmé par l'utilisatrice |
| 2026-11-09 | Public cible : passionnés de musique, en particulier des instruments à cordes frottées | Confirmé par l'utilisatrice |
| 2026-11-09 | Templates : `base.html.twig` → `template.html.twig` → pages | Architecture voulue |
| 2026-11-09 | Une branche par étape `feature/NN-description` | Organisation du projet |
| 2026-11-09 | Agents par difficulté : opus (architecte, relecteur, designer), sonnet (symfony-dev, front-twig, testeur), haiku (traducteur, redacteur) | Coût adapté à la difficulté |
| 2026-11-09 | Commandes PHP/Composer/Docker toujours dans WSL (préfixe `wsl.exe` dans `CLAUDE.md`), jamais le PHP 8.4 de WAMP | Claude Code tourne sous Windows |

## Prochaines étapes

1. Créer la branche `feature/01-install-claude` et commiter `CLAUDE.md`, `README.md`, `.claude/` *(en attente de validation)*.
2. `feature/02-mariadb` : passer `compose.yaml` (MariaDB + phpMyAdmin), `.env` (`DATABASE_URL`), `doctrine.yaml` en MariaDB → agent `symfony-dev` *(en attente de validation)*.
3. Charte graphique `docs/charte-graphique.md` → agent `designer`.
4. Modèle de données (sections, instruments, photos, extraits sonores, commentaires, utilisateurs) → agent `architecte`.

## Questions ouvertes

- Aucune pour l'instant.

## Historique

- **2026-11-09** — Initialisation de Claude Code : `/init`, rédaction de `CLAUDE.md` en français, `README.md` avec journal des étapes, création des agents (dont `designer`), création de cette mémoire partagée.
