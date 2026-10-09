/// [OrderLine] : une ligne de commande (ou de panier).
/// Elle ne stocke que la référence du produit et la quantité : le prix reste
/// dans le catalogue, ce qui évite de figer un tarif dans la ligne.
/// Cette classe sert aussi bien au panier en cours qu'aux commandes envoyées.
class OrderLine {
  /// Construit une ligne à partir de l'identifiant produit et de la quantité.
  const OrderLine({required this.productId, required this.qty});

  /// Construit une ligne depuis une entrée JSON de assets/data.json.
  factory OrderLine.fromJson(Map<String, Object?> json) {
    return OrderLine(
      productId: (json['productId'] as num).toInt(),
      qty: (json['qty'] as num).toInt(),
    );
  }

  /// Identifiant du produit commandé (voir [Product.id]).
  final int productId;

  /// Quantité commandée, strictement positive.
  final int qty;

  /// Copie la ligne en changeant seulement la quantité.
  OrderLine copyWith({int? qty}) {
    return OrderLine(productId: productId, qty: qty ?? this.qty);
  }
}