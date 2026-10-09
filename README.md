# BLOK Chantier

Application Flutter de démonstration pour parcourir un catalogue de matériaux,
préparer une commande et suivre ses livraisons. Les données initiales sont
chargées depuis `assets/data.json` ; aucun backend n'est utilisé.

## Lancer l'application

Depuis le dossier `blok_chantier` :

```bash
flutter pub get
flutter run
```

## Fonctionnalités

- Catalogue filtrable par catégorie et détail produit avec quantité.
- Panier modifiable, choix du chantier et envoi d'une commande.
- Liste des commandes et suivi visuel de leur statut.
- Interface en français, police Space Grotesk et montants en FCFA.

## Limites

Les nouvelles commandes restent en mémoire et ne sont pas conservées après
fermeture de l'application. Les statuts fournis par `data.json` sont affichés ;
aucun suivi temps réel ni backend n'est inclus.

## Architecture

- **data** : modèles typés et repository abstrait ; l'implémentation locale lit
  `assets/data.json` et pourra être remplacée par une source HTTP.
- **state** : contrôleurs `ChangeNotifier` qui chargent et manipulent le
  catalogue, le panier et les commandes.
- **features** : écrans et widgets d'affichage ; ils lisent les contrôleurs et
  leur transmettent les actions de l'utilisateur.
- **core** : palette, thème Material 3 et fonction unique de formatage FCFA.

## Difficultés rencontrées

- Difficulté : ______________________________
- Solution apportée : ________________________
