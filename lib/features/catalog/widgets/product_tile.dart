import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/fcfa_format.dart';
import '../../../data/models/product.dart';

/// [ProductTile] : une ligne de la liste du catalogue.
/// Elle affiche un produit (nom, catégorie, unité, prix formaté en FCFA)
/// et remonte le clic au parent via [onTap]. Aucun calcul ici :
/// le prix vient déjà formaté de [formatFcfa], la seule fonction de formatage.
class ProductTile extends StatelessWidget {
  /// [product] : le produit à afficher ; [onTap] : ouverture de la fiche détail.
  const ProductTile({required this.product, this.onTap, super.key});

  /// Produit affiché par la tuile.
  final Product product;

  /// Action déclenchée quand on touche la tuile.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.category} · ${product.unit}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatFcfa(product.price),
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}