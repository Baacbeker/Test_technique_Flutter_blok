import 'order_line.dart';
import 'order_status.dart';
import 'product.dart';

/// [Order] : une commande passée sur un chantier.
/// Classe de données immuable : elle porte ses lignes et sait se construire
/// depuis le JSON, puis calculer son montant à partir du catalogue courant.
class Order {
  /// Construit une commande complète.
  const Order({
    required this.reference,
    required this.site,
    required this.date,
    required this.status,
    required this.lines,
  });

  /// Construit une commande depuis une entrée JSON de assets/data.json.
  factory Order.fromJson(Map<String, Object?> json) {
    final List<Object?> rawLines = json['lines'] as List<Object?>;
    final List<OrderLine> lines = rawLines
        .map((Object? raw) => OrderLine.fromJson(raw as Map<String, Object?>))
        .toList(growable: false);
    return Order(
      reference: json['ref'] as String,
      site: json['site'] as String,
      date: DateTime.parse(json['date'] as String),
      status: OrderStatus.fromApi(json['status'] as String),
      lines: lines,
    );
  }

  /// Référence visible de la commande, par exemple "CMD-1042".
  final String reference;

  /// Chantier de livraison, par exemple "R+3 Cocody Angré".
  final String site;

  /// Date de la commande.
  final DateTime date;

  /// Statut courant dans le cycle de vie de la commande.
  final OrderStatus status;

  /// Lignes de la commande (produit + quantité).
  final List<OrderLine> lines;

  /// Nombre total d'articles de la commande (somme des quantités).
  int get itemCount {
    int count = 0;
    for (final OrderLine line in lines) {
      count += line.qty;
    }
    return count;
  }

  /// Montant d'une ligne : prix unitaire du produit multiplié par la quantité.
  /// Retourne 0 si le produit n'existe plus dans le catalogue.
  int lineAmount(OrderLine line, List<Product> products) {
    for (final Product product in products) {
      if (product.id == line.productId) {
        return product.amountFor(line.qty);
      }
    }
    return 0;
  }

  /// Montant total de la commande, calculé à partir du catalogue fourni.
  /// Exemple : CMD-1042 = 200 x 5 200 + 80 x 6 100 = 1 528 000 FCFA.
  int total(List<Product> products) {
    int sum = 0;
    for (final OrderLine line in lines) {
      sum += lineAmount(line, products);
    }
    return sum;
  }
}