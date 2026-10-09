import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/repositories/local_catalog_repository.dart';
import 'features/catalog/catalog_screen.dart';
import 'state/catalog_controller.dart';

/// [BlokChantierApp] : racine de l'application.
/// Elle installe le thème BLOK et les providers : le repository (données),
/// puis le contrôleur du catalogue. Le panier et les commandes viendront
/// se brancher ici aux étapes suivantes, sans toucher aux écrans.
class BlokChantierApp extends StatelessWidget {
  /// Racine sans état interne : tout l'état vit dans les contrôleurs.
  const BlokChantierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Le repository est exposé par contrat : on pourra le remplacer
        // par une version HTTP sans changer une ligne des écrans.
        Provider<CatalogRepository>(
          create: (BuildContext context) => const LocalCatalogRepository(),
        ),
        ChangeNotifierProvider<CatalogController>(
          create: (BuildContext context) =>
              CatalogController(context.read<CatalogRepository>())
                ..loadProducts(),
        ),
      ],
      child: MaterialApp(
        title: 'BLOK Chantier',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const CatalogScreen(),
      ),
    );
  }
}