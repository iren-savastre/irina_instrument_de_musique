# Mémoire partagée du projet

Journal de bord versionné avec le dépôt : état d'avancement, décisions et prochaines étapes, pour reprendre le travail dans une autre session ou sur une autre machine. Importé automatiquement par `CLAUDE.md`.

Règles de mise à jour :
- Mettre à jour à la fin de chaque étape ou session (section « État actuel », « Prochaines étapes », et une entrée datée dans « Historique »).
- Ne noter que ce que le code et git ne disent pas : décisions et leur raison, questions ouvertes, travail en cours.
- Dates absolues (AAAA-MM-JJ). Pas de mots de passe ni de secrets.

## État actuel

- Squelette Symfony 7.4 `webapp`, aucune entité/contrôleur/test encore.
- Claude Code configuré : `CLAUDE.md`, `README.md`, 8 agents dans `.claude/agents/`, cette mémoire.
- Branches empilées, toutes poussées, aucune fusionnée dans `main` : `feature/01-install-claude` → `feature/02-fins-de-ligne` → `feature/03-mariadb` (branche courante).
- Docker : MariaDB 11.8 (port hôte 3307), phpMyAdmin (8081), Mailpit (1025/8025) testés et fonctionnels, puis arrêtés (`docker compose stop`). Un MariaDB (3306) et un Apache (8080) natifs tournent dans WSL hors Docker : ne pas les utiliser pour ce projet.
- ⚠️ `composer install` échoue : extensions PHP manquantes dans WSL (xml, dom, pdo_mysql, mbstring, intl, curl, zip). À installer par l'utilisatrice (sudo) : `sudo apt install php8.5-xml php8.5-mysql php8.5-mbstring php8.5-intl php8.5-curl php8.5-zip`. Ensuite `composer install`, puis vérifier `php bin/console dbal:run-sql "SELECT 1"`.
- Fins de ligne réglées par `.gitattributes` (LF partout).
- Git dans WSL n'a ni identité (`user.name`/`user.email`) ni clé SSH GitHub : commits et push se font avec le git Windows (`git -c safe.directory=* …`). `gh` n'est installé nulle part : les pull requests s'ouvrent dans le navigateur.
- Sous Windows, `python` est le raccourci du Microsoft Store (il bloque) : ne pas l'utiliser.

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
| 2026-11-09 | `.gitattributes` `* text=auto eol=lf` | Clone Windows en CRLF : WSL voyait tout modifié |
| 2026-11-09 | MariaDB Docker sur port hôte 3307, phpMyAdmin sur 8081 | 3306 et 8080 déjà pris par MariaDB et Apache natifs de WSL |
| 2026-11-09 | `docker/db/init.sql` donne à `app` les droits sur `app_test%` | Permettre la BDD de test sans root |

## Prochaines étapes

1. Installer les extensions PHP (voir « État actuel »), `composer install`, vérifier la connexion Doctrine.
2. Ouvrir et fusionner les pull requests dans l'ordre : `feature/01-install-claude`, `feature/02-fins-de-ligne`, `feature/03-mariadb`.
3. Charte graphique `docs/charte-graphique.md` → agent `designer`.
4. Modèle de données (sections, instruments, photos, extraits sonores, commentaires, utilisateurs) → agent `architecte`.

## Questions ouvertes

- Aucune pour l'instant.

## Historique

- **2026-11-09** — Initialisation de Claude Code : `/init`, rédaction de `CLAUDE.md` en français, `README.md` avec journal des étapes, création des agents (dont `designer`), création de cette mémoire partagée. Commit `6455ce0` poussé sur `feature/01-install-claude`.
- **2026-11-09** — `.gitattributes` (commit `fe58abb`, branche `feature/02-fins-de-ligne`). Passage à MariaDB + phpMyAdmin + Mailpit et section Docker (démarrer/arrêter) dans le README (branche `feature/03-mariadb`). Conteneurs testés puis arrêtés. `composer install` bloqué par les extensions PHP manquantes.
