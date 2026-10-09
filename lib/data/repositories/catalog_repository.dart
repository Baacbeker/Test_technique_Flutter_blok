import '../models/order.dart';
import '../models/product.dart';

/// [CatalogRepository] : contrat de récupération des données.
/// C'est l'équivalent Dart d'une interface Java : elle ne contient aucun code,
/// seulement les signatures dont les contrôleurs ont besoin.
/// Les écrans ne connaissent que ce contrat, jamais l'implémentation :
/// on pourra donc brancher plus tard un RemoteCatalogRepository (HTTP)
/// sans modifier une seule ligne d'interface.
abstract class CatalogRepository {
  /// Renvoie tous les produits du catalogue.
  Future<List<Product>> loadProducts();

  /// Renvoie toutes les commandes existantes.
  Future<List<Order>> loadOrders();
}