import 'package:flutter/foundation.dart';

import '../data/models/order.dart';
import '../data/models/order_line.dart';
import '../data/models/order_status.dart';
import '../data/models/product.dart';
import '../data/repositories/catalog_repository.dart';
import 'catalog_controller.dart';

/// Contrôleur des commandes : chargement, montants et création locale.
class OrdersController extends ChangeNotifier {
  /// Le repository fournit les commandes initiales, le catalogue leurs prix.
  OrdersController(this._repository, this._catalog);

  final CatalogRepository _repository;
  final CatalogController _catalog;
  List<Order> _orders = <Order>[];
  bool _isLoading = true;
  String? _errorMessage;

  /// Commandes triées de la plus récente à la plus ancienne.
  List<Order> get orders {
    final List<Order> result = List<Order>.of(_orders)
      ..sort((Order a, Order b) => b.date.compareTo(a.date));
    return result;
  }

  /// État du chargement initial.
  bool get isLoading => _isLoading;

  /// Erreur de chargement à présenter à l'utilisateur.
  String? get errorMessage => _errorMessage;

  /// Charge les commandes depuis la source locale.
  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _orders = await _repository.loadOrders();
    } catch (error) {
      _errorMessage = 'Impossible de charger les commandes.';
      _orders = <Order>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Produit rattaché à une ligne ; l'incohérence est signalée explicitement.
  Product productFor(int productId) {
    final Product? product = _catalog.productById(productId);
    if (product == null) {
      throw StateError('Produit $productId absent du catalogue.');
    }
    return product;
  }

  /// Calcule le total d'une commande à partir du catalogue courant.
  int totalFor(Order order) => order.total(_catalog.products);

  /// Calcule le montant d'une ligne de commande.
  int lineTotal(OrderLine line) {
    return productFor(line.productId).amountFor(line.qty);
  }

  /// Crée une commande locale et renvoie sa référence, à partir de CMD-1048.
  Order submitOrder({
    required String site,
    required List<OrderLine> lines,
  }) {
    if (site.trim().isEmpty || lines.isEmpty) {
      throw ArgumentError('Un chantier et au moins une ligne sont requis.');
    }
    final int highestReference = _orders.fold<int>(
      1047,
      (int highest, Order order) {
        final String suffix = order.reference.replaceFirst('CMD-', '');
        final int? number = int.tryParse(suffix);
        return number != null && number > highest ? number : highest;
      },
    );
    final DateTime now = DateTime.now();
    final Order order = Order(
      reference: 'CMD-${highestReference + 1}',
      site: site,
      date: DateTime(now.year, now.month, now.day),
      status: OrderStatus.received,
      lines: List<OrderLine>.unmodifiable(lines),
    );
    _orders = <Order>[..._orders, order];
    notifyListeners();
    return order;
  }
}
