import 'package:flutter/material.dart';

/// [AppColors] : palette de la charte graphique BLOK Chantier.
/// Classe utilitaire immuable : elle ne s'instancie jamais, elle expose
/// seulement des constantes de couleurs utilisées par le thème et les écrans.
class AppColors {
  /// Constructeur privé : empêche toute instanciation de la classe.
  const AppColors._();

  /// Bleu marine de la charte : AppBar et titres.
  static const Color navy = Color(0xFF002060);

  /// Orange de la charte : boutons principaux et actions fortes.
  static const Color orange = Color(0xFFFF4A00);

  /// Turquoise de la charte : accents (badges, totaux, sélections).
  static const Color teal = Color(0xFF5BC0BE);

  /// Jaune de la charte : alertes et étape en cours du suivi de commande.
  static const Color yellow = Color(0xFFEEC844);

  /// Vert de confirmation : statut "Livrée".
  static const Color green = Color(0xFF2E7D32);

  /// Fond neutre des écrans.
  static const Color background = Color(0xFFF4F5F7);

  /// Fond des cartes et des surfaces posées sur le fond neutre.
  static const Color surface = Color(0xFFFFFFFF);

  /// Bordures fines des cartes et des séparateurs.
  static const Color border = Color(0xFFE2E5EA);

  /// Texte secondaire (unité, date, catégorie).
  static const Color muted = Color(0xFF6B7280);
}