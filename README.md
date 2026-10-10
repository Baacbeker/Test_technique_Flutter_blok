# BLOK Chantier

Application Flutter de démonstration pour parcourir un catalogue de matériaux,
préparer une commande et suivre ses livraisons. Les données initiales sont
chargées depuis `assets/data.json` ; aucun backend n'est utilisé.

# Lancer l'application
Depuis le dossier `blok_chantier` :
bash
flutter pub get
flutter run
# Fonctionnalités
- Catalogue filtrable par catégorie et détail produit avec quantité.
- Panier modifiable, choix du chantier et envoi d'une commande.
- Liste des commandes et suivi visuel de leur statut.
- Interface en français, police Space Grotesk et montants en FCFA.
# Limites
Les nouvelles commandes restent en mémoire et ne sont pas conservées après
fermeture de l'application. Les statuts fournis par `data.json` sont affichés ;
aucun suivi temps réel ni backend n'est inclus.
# Architecture
- data : modèles typés et repository abstrait ; l'implémentation locale lit
  `assets/data.json` et pourra être remplacée par une source HTTP.
- state : contrôleurs `ChangeNotifier` qui chargent et manipulent le
  catalogue, le panier et les commandes.
- features : écrans et widgets d'affichage ; ils lisent les contrôleurs et
  leur transmettent les actions de l'utilisateur.
- core : palette, thème Material 3 et fonction unique de formatage FCFA.
# Difficultés rencontrées
Les bases de Flutter ne suffisent pas pour ce test
Ce test technique ne peut pas être réalisé avec les seules bases de Flutter (widgets, `setState`, navigation simple). Il demande déjà des compétences intermédiaires :
- gestion d’état avec `ChangeNotifier` + `provider` ;
- architecture en couches (data / state / features) ;
- `abstract class` pour définir un repository ;
- désérialisation JSON (`fromJson`) ;
- `enum` enrichi avec champs et constructeur ;
- formatage personnalisé (FCFA) ;
- navigation avec `BottomNavigationBar` et `Navigator.push` ;
- séparation stricte entre logique métier et interface.
Autrement dit : Flutter permet de faire beaucoup de choses, mais **les bases seules ne permettent pas de réaliser ce test**. Il faut au minimum maîtriser ces concepts intermédiaires.
# Solution apportée
Ce projet a été développé avec l’aide d’un assistant IA. Je l’ai utilisé comme un outil d’apprentissage et d’accélération, pas comme un substitut de compréhension : j’ai relu, testé et corrigé le code produit, et je suis capable d’expliquer chaque choix technique (structure des dossiers, rôle de `ChangeNotifier`, calcul du total, génération de la référence commande, etc.).
