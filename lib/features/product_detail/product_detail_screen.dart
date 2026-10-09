import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/fcfa_format.dart';
import '../../data/models/product.dart';
import 'widgets/quantity_picker.dart';

/// [ProductDetailScreen] : écran 2, la fiche d'un matériau.
/// Le produit est passé par le constructeur (navigation empilée).
/// La seule chose que l'écran garde en mémoire est la quantité choisie :
/// c'est de l'état d'interface, pas du métier.
class ProductDetailScreen extends StatefulWidget {
  /// Reçoit le produit à afficher depuis le catalogue.
  const ProductDetailScreen({required this.product, super.key});

  /// Produit dont on affiche la fiche.
  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  /// Quantité choisie, qui démarre toujours à 1.
  int _quantity = 1;

  /// Un article de plus.
  void _increaseQuantity() {
    setState(() {
      _quantity = _quantity + 1;
    });
  }

  /// Un article de moins, sans jamais descendre sous 1.
  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity = _quantity - 1;
      });
    }
  }

  /// Ajoute au panier puis revient au catalogue avec un message de confirmation.
  void _addToCart() {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    // Étape 5 : le CartController sera branché ici, avant le retour.
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} x$_quantity ajouté au panier'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(child: _buildInfo(product, context)),
          const SizedBox(height: 24),
          Text(
            'Quantité',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          QuantityPicker(
            quantity: _quantity,
            canDecrease: _quantity > 1,
            onIncrease: _increaseQuantity,
            onDecrease: _decreaseQuantity,
          ),
          const SizedBox(height: 20),
          _buildTotal(context),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _addToCart,
            child: const Text('Ajouter au panier'),
          ),
        ),
      ),
    );
  }

  /// Bloc d'informations du produit : catégorie, unité et prix unitaire.
  Widget _buildInfo(Product product, BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.category,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Unité de vente : ${product.unit}',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          Text(
            'Prix unitaire : ${formatFcfa(product.price)}',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// Montant de la ligne : le modèle Product fait la multiplication,
  /// l'écran se contente de l'afficher avec le formatage FCFA commun.
  Widget _buildTotal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Montant',
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            formatFcfa(widget.product.amountFor(_quantity)),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}