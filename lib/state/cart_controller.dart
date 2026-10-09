import 'package:flutter/foundation.dart';

import '../data/models/order.dart';
import '../data/models/order_line.dart';
import '../data/models/product.dart';
import '../data/repositories/catalog_repository.dart';
import 'catalog_controller.dart';

/// Contrôleur du panier : lignes, quantités, chantier et montants.
class CartController extends ChangeNotifier {
  /// Le catalogue et le repository fournissent les produits et chantiers.
  CartController(this._catalog, this._repository);

  final CatalogController _catalog;
  final CatalogRepository _repository;
  List<OrderLine> _lines = <OrderLine>[];
  List<String> _sites = <String>[];
  String? _selectedSite;
  String? _siteError;

  /// Lignes actuellement préparées pour la commande.
  List<OrderLine> get lines => List<OrderLine>.unmodifiable(_lines);

  /// Nombre d'unités dans le panier, affiché sur la navigation.
  int get itemCount => _lines.fold<int>(0, (int sum, OrderLine line) => sum + line.qty);

  /// Chantiers distincts présents dans les commandes locales.
  List<String> get sites => List<String>.unmodifiable(_sites);

  /// Chantier choisi pour l'envoi.
  String? get selectedSite => _selectedSite;

  /// Erreur de chargement des chantiers, s'il y en a une.
  String? get siteError => _siteError;

  /// Montant total du panier, calculé à partir des prix du catalogue.
  int get total => _lines.fold<int>(
        0,
        (int sum, OrderLine line) =>
            sum + lineTotal(line),
      );

  /// Charge les chantiers à partir des commandes de la source locale.
  Future<void> loadSites() async {
    try {
      final List<Order> orders = await _repository.loadOrders();
      _sites = orders.map((Order order) => order.site).toSet().toList();
      _siteError = null;
    } catch (error) {
      _siteError = 'Impossible de charger les chantiers.';
    }
    notifyListeners();
  }

  /// Produit associé à une ligne, avec erreur explicite si le catalogue est incohérent.
  Product productFor(int productId) {
    final Product? product = _catalog.productById(productId);
    if (product == null) {
      throw StateError('Produit $productId absent du catalogue.');
    }
    return product;
  }

  /// Montant d'une ligne du panier.
  int lineTotal(OrderLine line) {
    return productFor(line.productId).amountFor(line.qty);
  }

  /// Ajoute une quantité au panier ou l'additionne à la ligne existante.
  void addProduct(Product product, int quantity) {
    final int index = _lines.indexWhere(
      (OrderLine line) => line.productId == product.id,
    );
    if (index == -1) {
      _lines = <OrderLine>[
        ..._lines,
        OrderLine(productId: product.id, qty: quantity),
      ];
    } else {
      final OrderLine current = _lines[index];
      _lines[index] = current.copyWith(qty: current.qty + quantity);
    }
    notifyListeners();
  }

  /// Modifie une quantité sans jamais la faire passer sous un.
  void setQuantity(int productId, int quantity) {
    if (quantity < 1) {
      return;
    }
    _lines = _lines
        .map(
          (OrderLine line) => line.productId == productId
              ? line.copyWith(qty: quantity)
              : line,
        )
        .toList();
    notifyListeners();
  }

  /// Supprime une ligne du panier.
  void removeProduct(int productId) {
    _lines = _lines
        .where((OrderLine line) => line.productId != productId)
        .toList();
    notifyListeners();
  }

  /// Sélectionne un chantier valide de la liste chargée.
  void selectSite(String? site) {
    if (site != null && !_sites.contains(site)) {
      throw ArgumentError.value(site, 'site', 'Chantier inconnu.');
    }
    _selectedSite = site;
    notifyListeners();
  }

  /// Vide les lignes après la création d'une commande.
  void clear() {
    _lines = <OrderLine>[];
    _selectedSite = null;
    notifyListeners();
  }
}
