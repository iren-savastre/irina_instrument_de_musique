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
