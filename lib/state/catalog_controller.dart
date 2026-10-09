import 'package:flutter/foundation.dart';

import '../data/models/product.dart';
import '../data/repositories/catalog_repository.dart';

/// [CatalogController] : état du catalogue.
/// Il charge les produits via le repository, garde la catégorie choisie
/// et expose la liste à afficher. L'écran ne fait aucun tri ni filtrage :
/// il lit simplement [visibleProducts] et [categories].
class CatalogController extends ChangeNotifier {
  /// Le catalogue reçoit son repository par le constructeur : c'est ce qui
  /// permettra de passer à une version HTTP sans toucher aux écrans.
  CatalogController(this._repository);

  /// Contrat d'accès aux données (local aujourd'hui, HTTP demain).
  final CatalogRepository _repository;

  /// Libellé de la puce qui n'applique aucun filtre.
  static const String allCategoriesLabel = 'Tous';

  List<Product> _products = const <Product>[];
  String _selectedCategory = allCategoriesLabel;
  bool _isLoading = true;
  String? _errorMessage;

  /// Tous les produits du catalogue, sans filtre.
  List<Product> get products => _products;

  /// Catégorie sélectionnée dans le filtre.
  String get selectedCategory => _selectedCategory;

  /// Vrai pendant le chargement initial du fichier de données.
  bool get isLoading => _isLoading;

  /// Message d'erreur à afficher si le chargement a échoué, sinon null.
  String? get errorMessage => _errorMessage;

  /// Catégories proposées dans les puces : "Tous" puis celles trouvées
  /// dans les données, dans l'ordre d'apparition du catalogue.
  List<String> get categories {
    final List<String> result = <String>[allCategoriesLabel];
    for (final Product product in _products) {
      if (!result.contains(product.category)) {
        result.add(product.category);
      }
    }
    return result;
  }

  /// Produits à afficher : tout le catalogue, ou seulement la catégorie choisie.
  List<Product> get visibleProducts {
    if (_selectedCategory == allCategoriesLabel) {
      return _products;
    }
    return _products
        .where((Product product) => product.category == _selectedCategory)
        .toList(growable: false);
  }

  /// Recherche un produit par son identifiant (utilisé par le panier
  /// et par les commandes pour retrouver les prix).
  Product? productById(int id) {
    for (final Product product in _products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  /// Charge le catalogue depuis le repository.
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _products = await _repository.loadProducts();
    } catch (error) {
      _errorMessage = 'Impossible de charger le catalogue.';
      _products = const <Product>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Applique le filtre de catégorie.
  void selectCategory(String category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }
}