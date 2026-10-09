import 'package:intl/intl.dart';

/// [formatFcfa] : unique fonction de formatage des montants de l'application.
/// Règle métier : séparateur de milliers = espace, aucune décimale, suffixe "FCFA".
/// Exemple : 5200 devient "5 200 FCFA", 1528000 devient "1 528 000 FCFA".
String formatFcfa(int amount) {
  final String grouped = NumberFormat.decimalPattern('fr_FR').format(amount);
  // intl utilise une espace insécable étroite (U+202F) en français :
  // on la remplace par une espace normale pour obtenir exactement "5 200 FCFA".
  final String spaced = grouped
      .replaceAll('\u202F', ' ')
      .replaceAll('\u00A0', ' ');
  return '$spaced FCFA';
}