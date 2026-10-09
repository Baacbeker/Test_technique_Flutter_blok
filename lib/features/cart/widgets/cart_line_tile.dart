import 'package:flutter/material.dart';

import '../../../core/utils/fcfa_format.dart';
import '../../../data/models/order_line.dart';
import '../../../data/models/product.dart';
import '../../product_detail/widgets/quantity_picker.dart';

/// Tuile du panier : affiche une ligne et remonte ses actions au contrôleur.
class CartLineTile extends StatelessWidget {
  /// Les valeurs affichées et callbacks sont fournis par l'écran.
  const CartLineTile({
    required this.line,
    required this.product,
    required this.amount,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });

  final OrderLine line;
  final Product product;
  final int amount;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Supprimer',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Text('${product.unit} · ${formatFcfa(product.price)} / unité'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                QuantityPicker(
                  quantity: line.qty,
                  canDecrease: line.qty > 1,
                  onDecrease: () => onQuantityChanged(line.qty - 1),
                  onIncrease: () => onQuantityChanged(line.qty + 1),
                ),
                Text(
                  formatFcfa(amount),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
