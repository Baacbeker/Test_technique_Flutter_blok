import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/fcfa_format.dart';
import '../../data/models/order_line.dart';
import '../../state/cart_controller.dart';
import '../../state/orders_controller.dart';
import 'widgets/cart_line_tile.dart';
import 'widgets/site_selector.dart';

/// Écran du panier : il se limite à afficher et relayer les actions.
class CartScreen extends StatelessWidget {
  /// Le parent peut ouvrir l'onglet commandes après l'envoi.
  const CartScreen({this.onOrderSubmitted, super.key});

  final ValueChanged<String>? onOrderSubmitted;

  @override
  Widget build(BuildContext context) {
    final CartController cart = context.watch<CartController>();
    if (cart.lines.isEmpty) {
      return const Center(child: Text('Votre panier est vide.'));
    }
    return Column(
      children: <Widget>[
        Expanded(child: _buildLines(cart)),
        _buildCheckout(context, cart),
      ],
    );
  }

  Widget _buildLines(CartController cart) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cart.lines.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final OrderLine line = cart.lines[index];
        return CartLineTile(
          line: line,
          product: cart.productFor(line.productId),
          amount: cart.lineTotal(line),
          onQuantityChanged: (int quantity) =>
              cart.setQuantity(line.productId, quantity),
          onRemove: () => cart.removeProduct(line.productId),
        );
      },
    );
  }

  Widget _buildCheckout(BuildContext context, CartController cart) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (cart.siteError != null)
              Text(cart.siteError!, style: const TextStyle(color: Colors.red)),
            SiteSelector(
              sites: cart.sites,
              selectedSite: cart.selectedSite,
              onChanged: cart.selectSite,
            ),
            const SizedBox(height: 12),
            _buildTotal(context, cart),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: cart.selectedSite == null
                  ? null
                  : () => _submitOrder(context, cart),
              child: const Text('Envoyer la commande'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal(BuildContext context, CartController cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total', style: Theme.of(context).textTheme.titleMedium),
        Text(
          formatFcfa(cart.total),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  void _submitOrder(BuildContext context, CartController cart) {
    final String? site = cart.selectedSite;
    if (site == null || cart.lines.isEmpty) {
      return;
    }
    final order = context.read<OrdersController>().submitOrder(
          site: site,
          lines: cart.lines,
        );
    cart.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Commande ${order.reference} envoyée.')),
    );
    onOrderSubmitted?.call(order.reference);
  }
}
