import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

/// [BlokChantierApp] : racine de l'application.
/// Elle installe le thème BLOK et, plus tard, les providers de gestion d'état
/// ainsi que la navigation du bas (Catalogue / Panier / Commandes).
class BlokChantierApp extends StatelessWidget {
  const BlokChantierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLOK Chantier',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const _StartupScreen(),
    );
  }
}

/// Écran provisoire affiché le temps de brancher le catalogue (étape 3).
/// Il est remplacé à l'étape 7 par la barre de navigation du bas.
class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLOK Chantier')),
      body: const Center(
        child: Text('Préparation du catalogue...'),
      ),
    );
  }
}