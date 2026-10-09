import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/repositories/local_catalog_repository.dart';
import 'features/cart/cart_screen.dart';
import 'features/catalog/catalog_screen.dart';
import 'features/orders/orders_screen.dart';
import 'state/cart_controller.dart';
import 'state/catalog_controller.dart';
import 'state/orders_controller.dart';

/// [BlokChantierApp] : racine de l'application.
/// Elle installe le thème BLOK et les providers : le repository (données),
/// puis les contrôleurs du catalogue et du panier.
class BlokChantierApp extends StatefulWidget {
  /// Racine sans état interne : tout l'état vit dans les contrôleurs.
  const BlokChantierApp({super.key});

  @override
  State<BlokChantierApp> createState() => _BlokChantierAppState();
}

/// État local de l'onglet actif dans la navigation principale.
class _BlokChantierAppState extends State<BlokChantierApp> {
  int _selectedIndex = 0;

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
        ChangeNotifierProvider<CartController>(
          create: (BuildContext context) => CartController(
            context.read<CatalogController>(),
            context.read<CatalogRepository>(),
          )..loadSites(),
        ),
        ChangeNotifierProvider<OrdersController>(
          create: (BuildContext context) => OrdersController(
            context.read<CatalogRepository>(),
            context.read<CatalogController>(),
          )..loadOrders(),
        ),
      ],
      child: MaterialApp(
        title: 'BLOK Chantier',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: Scaffold(
          appBar: AppBar(title: Text(_screenTitle)),
          body: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              const CatalogScreen(),
              CartScreen(onOrderSubmitted: (_) => _openOrders()),
              const OrdersScreen(),
            ],
          ),
          bottomNavigationBar: Consumer<CartController>(
            builder: (
              BuildContext context,
              CartController cart,
              Widget? child,
            ) {
              return NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: <NavigationDestination>[
                  const NavigationDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon: Icon(Icons.inventory_2),
                    label: 'Catalogue',
                  ),
                  NavigationDestination(
                    icon: _cartIcon(cart.itemCount, false),
                    selectedIcon: _cartIcon(cart.itemCount, true),
                    label: 'Panier',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.local_shipping_outlined),
                    selectedIcon: Icon(Icons.local_shipping),
                    label: 'Commandes',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String get _screenTitle {
    switch (_selectedIndex) {
      case 1:
        return 'Panier';
      case 2:
        return 'Mes commandes';
      default:
        return 'Catalogue';
    }
  }

  Widget _cartIcon(int itemCount, bool selected) {
    final Icon icon = Icon(
      selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
    );
    if (itemCount == 0) {
      return icon;
    }
    return Badge(
      backgroundColor: AppColors.orange,
      label: Text('$itemCount'),
      child: icon,
    );
  }

  void _openOrders() {
    setState(() {
      _selectedIndex = 2;
    });
  }
}