import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// [QuantityPicker] : le sélecteur de quantité "- / valeur / +".
/// Widget d'affichage pur : la quantité et les actions viennent du parent,
/// il ne connaît aucune règle métier (le minimum de 1 est géré par l'écran).
class QuantityPicker extends StatelessWidget {
  /// [quantity] : valeur affichée ; [canDecrease] : faux quand on est au minimum.
  const QuantityPicker({
    required this.quantity,
    required this.canDecrease,
    required this.onIncrease,
    required this.onDecrease,
    super.key,
  });

  /// Quantité actuellement choisie.
  final int quantity;

  /// Vrai si l'on peut encore diminuer la quantité (quantité > 1).
  final bool canDecrease;

  /// Callback du bouton "+".
  final VoidCallback onIncrease;

  /// Callback du bouton "-".
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRoundButton(
          icon: Icons.remove,
          onPressed: canDecrease ? onDecrease : null,
        ),
        Container(
          width: 96,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        _buildRoundButton(
          icon: Icons.add,
          onPressed: onIncrease,
        ),
      ],
    );
  }

  /// Bouton rond turquoise, désactivé quand [onPressed] est null.
  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: AppColors.teal.withValues(alpha: 0.20),
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: AppColors.navy,
          disabledColor: AppColors.muted.withValues(alpha: 0.4),
          iconSize: 24,
        ),
      ),
    );
  }
}