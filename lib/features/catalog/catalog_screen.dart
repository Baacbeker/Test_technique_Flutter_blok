import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/product.dart';
import '../../state/cart_controller.dart';
import '../../state/catalog_controller.dart';
import '../product_detail/product_detail_screen.dart';
import 'widgets/category_filter.dart';
import 'widgets/product_tile.dart';

/// [CatalogScreen] : écran 1, la liste des matériaux.
/// L'écran ne fait que lire l'état du [CatalogController] et l'afficher :
/// filtre, tri et chargement sont gérés dans le contrôleur.
class CatalogScreen extends StatelessWidget {
  /// Écran sans état interne : tout vient du contrôleur.
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CatalogController catalog = context.watch<CatalogController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogue')),
      body: _buildBody(catalog),
    );
  }

  /// Affiche le chargement, l'erreur ou la liste filtrée.
  Widget _buildBody(CatalogController catalog) {
    if (catalog.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }
    if (catalog.errorMessage != null) {
      return _buildError(catalog);
    }
    return Column(
      children: <Widget>[
        CategoryFilter(
          categories: catalog.categories,
          selectedCategory: catalog.selectedCategory,
          onSelected: catalog.selectCategory,
        ),
        Expanded(child: _buildList(catalog)),
      ],
    );
  }

  /// Liste des produits visibles pour la catégorie choisie.
  Widget _buildList(CatalogController catalog) {
    if (catalog.visibleProducts.isEmpty) {
      return const Center(
        child: Text('Aucun produit dans cette catégorie.'),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      itemCount: catalog.visibleProducts.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final Product product = catalog.visibleProducts[index];
        return ProductTile(
          product: product,
          onTap: () => _openProduct(context, product),
        );
      },
    );
  }

  /// Navigation empilée vers la fiche du produit touché.
  Future<void> _openProduct(BuildContext context, Product product) async {
    final int? quantity = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (BuildContext context) =>
            ProductDetailScreen(product: product),
      ),
    );
    if (quantity != null && context.mounted) {
      context.read<CartController>().addProduct(product, quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} x$quantity ajouté au panier'),
        ),
      );
    }
  }

  /// Message d'erreur avec possibilité de relancer le chargement.
  Widget _buildError(CatalogController catalog) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            catalog.errorMessage ?? '',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: catalog.loadProducts,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}