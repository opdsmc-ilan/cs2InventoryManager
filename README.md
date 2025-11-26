CS2 Inventory Manager (Flutter)

CS2 Inventory Manager est une application Flutter permettant d’afficher
tous les skins disponibles dans Counter-Strike via une API externe.
L’utilisateur peut ensuite parcourir les skins (armes, couteaux,
gants…). Consulter leurs informations détaillées. Sélectionner ses
skins préférés. Créer son propre loadout / inventaire. Sauvegarder son
inventaire dans une base de données

Ce projet a été conçu dans un objectif d’apprentissage Flutter (API,
affichage dynamique et persistance).

------------------------------------------------------------------------

Fonctionnalités principales

1. Récupération des skins via API

-   Requête HTTP vers une API listant les skins CS2
-   Parsing JSON → Objets Dart
-   Affichage dynamique

2. Aperçu et détails des skins

-   Affichage du nom et du type
-   Affichage de l’image (CachedNetworkImage)


3. Création d’un inventaire / loadout personnalisé

-   Sélection/désélection des skins
-   Inventaire affiché dans une page dédiée
-   Emplacement pour image :

    [AJOUTER ICI UNE IMAGE : Inventaire personnalisé]

4. Sauvegarde en base de données

Selon votre implémentation : - Supabase - Firebase - MySQL / PHP
backend - SQLite local

→ L’inventaire de l’utilisateur est sauvegardé.

------------------------------------------------------------------------

Technologies utilisées

-   Flutter (Dart)
-   API HTTP (http)
-   Base de données (supabase)

------------------------------------------------------------------------

Installation & lancement

1. Cloner le projet

    git clone https://github.com/votre-repo/cs2-inventory-manager.git
    cd cs2-inventory-manager

2. Installer les dépendances Flutter

    flutter pub get

3. Lancer l’application

    flutter run


------------------------------------------------------------------------

Objectif du projet

Ce projet a été créé pour : - Approfondir Flutter - Apprendre l'utilisation d’API - Travailler la manipulation d’objets JSON - Gérer un
inventaire persistant


