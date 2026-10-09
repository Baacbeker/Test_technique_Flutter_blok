import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// [OrderStatus] : les cinq états d'une commande, déclarés dans l'ordre du
/// cycle de vie (voir StatusStepper qui s'appuie sur l'index de l'enum).
/// Enum enrichi : chaque valeur porte son libellé français, la valeur renvoyée
/// par l'API et sa couleur, pour ne pas dupliquer ces tables dans les écrans.
enum OrderStatus {
  /// Commande créée par le conducteur de travaux, pas encore traitée.
  received('Received', 'Reçue', AppColors.yellow, AppColors.navy),

  /// Commande transmise au fournisseur.
  relayed('Relayed', 'Transmise', AppColors.teal, AppColors.navy),

  /// Marchandise en cours d'acheminement.
  shipped('Shipped', 'En livraison', AppColors.orange, Colors.white),

  /// Marchandise livrée sur le chantier.
  delivered('Delivered', 'Livrée', AppColors.green, Colors.white),

  /// Commande facturée, dernière étape du suivi.
  invoiced('Invoiced', 'Facturée', AppColors.navy, Colors.white);

  /// Construit une valeur de l'enum avec ses libellés et ses couleurs.
  const OrderStatus(this.apiValue, this.label, this.color, this.onColor);

  /// Valeur attendue côté API, par exemple "Received".
  final String apiValue;

  /// Libellé français affiché à l'utilisateur.
  final String label;

  /// Couleur de fond du badge correspondant à ce statut.
  final Color color;

  /// Couleur du texte et de l'icône posés sur [color].
  final Color onColor;

  /// Convertit une valeur d'API ("Received", "SHIPPED"...) en statut,
  /// sans tenir compte de la casse ni des espaces autour.
  /// Toute valeur inconnue retombe sur [OrderStatus.received].
  static OrderStatus fromApi(String value) {
    final String searched = value.trim().toLowerCase();
    for (final OrderStatus status in OrderStatus.values) {
      if (status.apiValue.toLowerCase() == searched) {
        return status;
      }
    }
    return OrderStatus.received;
  }
}