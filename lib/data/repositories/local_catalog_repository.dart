import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/order.dart';
import '../models/product.dart';
import 'catalog_repository.dart';

/// [LocalCatalogRepository] : implémentation locale de [CatalogRepository].
/// Elle lit l'unique fichier assets/data.json (aucun backend dans ce test)
/// et délègue la conversion JSON aux constructeurs fromJson des modèles.
class LocalCatalogRepository implements CatalogRepository {
  /// Construit le repository ; il n'a aucun état, d'où le constructeur const.
  const LocalCatalogRepository();

  /// Chemin de l'asset déclaré dans pubspec.yaml.
  static const String _assetPath = 'assets/data.json';

  /// Lit puis décode le fichier JSON complet.
  Future<Map<String, Object?>> _readData() async {
    final String rawContent = await rootBundle.loadString(_assetPath);
    final Object? decoded = jsonDecode(rawContent);
    return decoded as Map<String, Object?>;
  }

  @override
  Future<List<Product>> loadProducts() async {
    final Map<String, Object?> data = await _readData();
    final List<Object?> rawProducts = data['products'] as List<Object?>;
    return rawProducts
        .map((Object? raw) => Product.fromJson(raw as Map<String, Object?>))
        .toList(growable: false);
  }

  @override
  Future<List<Order>> loadOrders() async {
    final Map<String, Object?> data = await _readData();
    final List<Object?> rawOrders = data['orders'] as List<Object?>;
    return rawOrders
        .map((Object? raw) => Order.fromJson(raw as Map<String, Object?>))
        .toList(growable: false);
  }
}