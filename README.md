# Instruments de musique — Cordes frottées

Site de présentation des instruments à cordes frottées (violon, alto, violoncelle, contrebasse, viole de gambe, monocorde à clavier) : historique de la famille, fiches d'instruments avec photos et extraits sonores, commentaires modérés.

Stack : Symfony 7.4 LTS, PHP 8.5, Twig + Symfony UX (AssetMapper), MariaDB / phpMyAdmin, Mailpit, Docker, sous WSL2 Ubuntu.

## Installation

```bash
git clone git@github.com:iren-savastre/irina_instrument_de_musique.git
cd irina_instrument_de_musique
composer install
docker compose up -d
symfony serve -d
```

### Prérequis PHP (WSL)

```bash
sudo apt install php8.5-xml php8.5-mysql php8.5-mbstring php8.5-intl php8.5-curl php8.5-zip
```

## Docker

Services (`compose.yaml` + `compose.override.yaml`) :

| Service | Image | Accès depuis la machine |
|---------|-------|-------------------------|
| `database` | MariaDB 11.8 | `127.0.0.1:3307` (utilisateur `app`, base `app`) |
| `phpmyadmin` | phpMyAdmin 5 | http://localhost:8081 |
| `mailer` | Mailpit | SMTP `127.0.0.1:1025`, interface http://localhost:8025 |

Les ports 3307 et 8081 évitent le MariaDB (3306) et l'Apache (8080) installés directement dans WSL.

Toutes les commandes se lancent **dans WSL**, à la racine du projet.

### Démarrer

```bash
docker compose up -d          # démarre les conteneurs en arrière-plan
docker compose ps             # vérifie leur état
```

### Arrêter manuellement

```bash
docker compose stop           # arrête les conteneurs (redémarrage rapide avec "docker compose up -d")
docker compose down           # arrête ET supprime les conteneurs ; les données de la base sont conservées (volume)
docker compose down -v        # ⚠️ supprime aussi le volume : la base de données est EFFACÉE
```

Arrêter un seul service : `docker compose stop phpmyadmin`.

Vérifier qu'il ne reste rien : `docker ps` (liste vide = plus aucun conteneur en marche). Pour arrêter un conteneur hors projet : `docker stop <nom_ou_id>` (le nom est dans `docker ps`).

Services natifs de WSL (hors Docker), si besoin de libérer les ports 3306/8080 :

```bash
sudo service mariadb stop
sudo service apache2 stop
```

## Étapes du projet

### Étape 1 — Création du projet Symfony

Squelette `symfony/webapp` 7.4.

### Étape 2 — Initialisation de Claude Code

Branche : `feature/01-install-claude`

```bash
claude update
claude
```

Dans Claude : `/init` pour générer `CLAUDE.md` (instructions du projet lues par Claude à chaque session).

### Étape 3 — Fins de ligne

Branche : `feature/02-fins-de-ligne`

Ajout de `.gitattributes` (`* text=auto eol=lf`) : tous les fichiers en LF, que le dépôt soit cloné depuis Windows ou depuis WSL.

### Étape 4 — MariaDB, phpMyAdmin, Mailpit

Branche : `feature/03-mariadb`

PostgreSQL du squelette remplacé par MariaDB 11.8 ; ajout de phpMyAdmin ; Mailpit branché en dev (`MAILER_DSN` dans `.env.dev`). `docker/db/init.sql` donne à l'utilisateur `app` les droits sur la base de test `app_test`.
