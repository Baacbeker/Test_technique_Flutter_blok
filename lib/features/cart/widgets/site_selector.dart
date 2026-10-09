import 'package:flutter/material.dart';

/// Sélecteur de chantier à partir des chantiers connus du catalogue local.
class SiteSelector extends StatelessWidget {
  /// Les chantiers et la sélection viennent du contrôleur du panier.
  const SiteSelector({
    required this.sites,
    required this.selectedSite,
    required this.onChanged,
    super.key,
  });

  final List<String> sites;
  final String? selectedSite;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedSite,
      decoration: const InputDecoration(
        labelText: 'Chantier de livraison',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Choisir un chantier'),
      items: sites
          .map(
            (String site) => DropdownMenuItem<String>(
              value: site,
              child: Text(site),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
