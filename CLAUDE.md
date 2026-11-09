# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Langue

Tout en **français** : conversation, messages de commit, noms de routes/templates visibles, contenus du site. Le site sera traduit plus tard (anglais, espagnol…) : écrire dès maintenant les textes d'interface via `translations/` (locale `fr` d'abord) plutôt qu'en dur dans les templates.

## Mémoire partagée

État d'avancement, décisions et prochaines étapes : @.claude/MEMORY.md

La mettre à jour à la fin de chaque étape ou session (et avant un commit de fin d'étape), pour qu'une autre session ou une autre machine puisse reprendre le travail.

## Projet : Instruments de musique — Cordes frottées

Site de présentation des instruments à cordes frottées, destiné aux passionnés de musique, et particulièrement des instruments à cordes frottées. On peut y publier plusieurs modèles d'instruments d'un même type.

- **Accueil** : historique de la famille des cordes frottées.
- **Sections** : Violon, Alto, Violoncelle, Contrebasse, Viole de gambe, Monocorde à clavier. Les sections sont des données (gérables par l'admin), pas des pages codées en dur.
- **Instrument** : appartient à une section, avec photos et extrait sonore (optionnel).
- **Rôles** :
  - Admin : ajoute/modifie instruments et sections.
  - Utilisateurs : postent des commentaires, publiés seulement après validation par l'admin.

## Stack

- WSL2 Ubuntu 22.04 sous Windows 11. Le dépôt est dans WSL : lancer PHP/Composer/Docker **dans WSL**, pas depuis Windows. Fins de ligne LF, indentation 4 espaces (2 pour `compose*.yaml`) — voir `.editorconfig`.
- Symfony 7.4 LTS (webapp), PHP 8.5 visé (`composer.json` exige `>=8.2`).
- Front : AssetMapper + importmap (pas de Node), Stimulus, Turbo, Symfony UX (https://ux.symfony.com/), templates Twig.
- Base de données : **MariaDB 11.8** en Docker, port hôte **3307** (le 3306 est pris par un MariaDB natif dans WSL, à ne pas utiliser) ; phpMyAdmin sur http://localhost:8081 (le 8080 est pris par Apache dans WSL). `docker/db/init.sql` donne à `app` les droits sur `app_test%` ; il ne s'exécute qu'à la création du volume (`docker compose down -v` pour le rejouer, ce qui efface la base).
- Mails en dev : Mailpit (`MAILER_DSN` dans `.env.dev`), interface http://localhost:8025.
- Extensions PHP requises dans WSL : `php8.5-xml php8.5-mysql php8.5-mbstring php8.5-intl php8.5-curl php8.5-zip`.
- Docker pour l'environnement local.

## Commandes

Claude Code tourne sous Windows. Un PHP 8.4 (WAMP) existe côté Windows : **ne pas l'utiliser**. Toujours exécuter les commandes ci-dessous dans WSL via ce préfixe (Git Bash) :

```bash
MSYS_NO_PATHCONV=1 wsl.exe -d Ubuntu-22.04 --cd /home/webdev/irina_instrument_de_musique -- bash -lc '<commande>'
```

```bash
composer install
docker compose up -d                     # MariaDB + phpMyAdmin + Mailpit
docker compose stop                      # arrêter (down = supprimer les conteneurs, down -v = effacer aussi la BDD)
symfony serve -d                         # ou : php -S localhost:8000 -t public

php bin/console make:entity              # make:controller, make:form, make:crud, make:user…
php bin/console make:migration
php bin/console doctrine:migrations:migrate

php bin/phpunit                          # tous les tests
php bin/phpunit tests/Chemin/FooTest.php # un fichier
php bin/phpunit --filter testNom         # un test

php bin/console --env=test doctrine:database:create   # BDD de test (suffixe _test)
php bin/console messenger:consume async -vv           # envoie les mails en file d'attente
php bin/console importmap:require <paquet>            # ajouter une dépendance JS
```

Aucun linter / analyse statique n'est configuré.

## Architecture

- **État actuel** : squelette `symfony/webapp` ; `src/Entity`, `src/Controller`, `src/Repository`, `migrations/` et `translations/` sont vides.
- **Backend** : services autowirés depuis `src/` (`config/services.yaml`), routes via attributs `#[Route]` dans les contrôleurs. Doctrine ORM 3, mapping par attributs dans `App\Entity`, schéma uniquement via migrations.
- **Templates** : `base.html.twig` → `template.html.twig` (layout commun du site) → pages.
- **Front** : point d'entrée `assets/app.js` ; contrôleurs Stimulus dans `assets/controllers/` (enregistrés automatiquement par `assets/stimulus_bootstrap.js`).
- **Messenger** : les mails (`SendEmailMessage`) et notifications passent par le transport `async` (Doctrine) — rien n'est envoyé sans worker `messenger:consume`.
- **Sécurité** : `security.yaml` contient un provider en mémoire factice ; à remplacer par l'entité `User` (`make:user`) avec `ROLE_ADMIN` pour l'administration.
- **Tests** : PHPUnit avec `failOnDeprecation`, `failOnNotice`, `failOnWarning` : une dépréciation dans `src/` fait échouer la suite.

## Agents (`.claude/agents/`)

Répartir le travail selon la difficulté :

| Agent | Modèle | Rôle |
|-------|--------|------|
| `architecte` | opus | Conception avant code (modèle de données, sécurité, upload, i18n), plan découpé par agent. Lecture seule. |
| `relecteur` | opus | Revue avant commit/merge : sécurité, Doctrine, bugs. Lecture seule. |
| `designer` | opus | Identité visuelle, charte `docs/charte-graphique.md`, maquettes, variables CSS dans `assets/styles/`. |
| `symfony-dev` | sonnet | Entités, migrations, contrôleurs, formulaires, config. |
| `front-twig` | sonnet | Twig, Stimulus, Symfony UX, CSS. |
| `testeur` | sonnet | Tests PHPUnit. |
| `traducteur` | haiku | Clés dans `translations/`. |
| `redacteur` | haiku | README, journal des étapes, messages de commit. |

Flux type d'une fonctionnalité : `architecte` (+ `designer` si la page a un nouvel aspect visuel) → `symfony-dev` / `front-twig` → `traducteur` → `testeur` → `relecteur`. Les agents ne commitent pas : les commits et changements de branche sont faits par la session principale.

## Git

- Une branche par étape : `feature/NN-description` (ex. `feature/01-install-claude`), jamais de travail direct sur `main`.
- Dépôt : `origin` → `git@github.com:iren-savastre/irina_instrument_de_musique.git`.
- Depuis Windows, git refuse le dossier WSL (« dubious ownership ») : utiliser git dans WSL, ou `git config --global --add safe.directory '%(prefix)///wsl.localhost/Ubuntu-22.04/home/webdev/irina_instrument_de_musique'`.
