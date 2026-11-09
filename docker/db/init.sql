-- Exécuté une seule fois, à la création du volume MariaDB.
-- Donne à l'utilisateur "app" les droits sur la base de test (app_test, suffixe ajouté par doctrine.yaml en env test).
GRANT ALL PRIVILEGES ON `app\_test%`.* TO 'app'@'%';
FLUSH PRIVILEGES;
