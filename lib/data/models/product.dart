/// [Product] : un matériau du catalogue BLOK.
/// Classe de données immuable (champs finaux, constructeur const) :
/// elle sait se construire depuis une entrée JSON de assets/data.json.
class Product {
  /// Construit un produit à partir de ses champs.
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
  });

  /// Construit un produit depuis une entrée JSON du fichier de données.
  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      unit: json['unit'] as String,
      price: (json['price'] as num).toInt(),
    );
  }

  /// Identifiant technique du produit (utilisé par les lignes de commande).
  final int id;

  /// Nom affiché, par exemple "Ciment CPJ 42.5".
  final String name;

  /// Catégorie du produit : "Gros œuvre", "Agrégats", "Toiture", "Second œuvre".
  final String category;

  /// Unité de vente affichée, par exemple "sac 50 kg".
  final String unit;

  /// Prix unitaire en FCFA (entier : le franc CFA n'a pas de décimales).
  final int price;

  /// Montant d'une quantité de ce produit : prix unitaire multiplié par [qty].
  /// Point unique de calcul "prix x quantité", réutilisé par le panier
  /// et par les commandes pour éviter de dupliquer la formule.
  int amountFor(int qty) {
    return price * qty;
  }
}