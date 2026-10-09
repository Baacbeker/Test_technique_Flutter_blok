import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// [CategoryFilter] : la rangée de puces "Tous / Gros œuvre / Agrégats...".
/// Widget d'affichage pur : il reçoit les catégories et la sélection,
/// et remonte le clic au parent, sans aucune logique métier.
class CategoryFilter extends StatelessWidget {
  /// [categories] : libellés à afficher ; [onSelected] : clic sur une puce.
  const CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  /// Libellés des puces, dans l'ordre d'affichage.
  final List<String> categories;

  /// Puce actuellement active.
  final String selectedCategory;

  /// Callback appelé avec le libellé de la puce cliquée.
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: categories.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final String category = categories[index];
          return _buildChip(category, category == selectedCategory);
        },
      ),
    );
  }

  /// Construit une puce, en inversant les couleurs quand elle est active.
  Widget _buildChip(String category, bool isSelected) {
    return ChoiceChip(
      label: Text(category),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (bool selected) => onSelected(category),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.navy,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.navy,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}