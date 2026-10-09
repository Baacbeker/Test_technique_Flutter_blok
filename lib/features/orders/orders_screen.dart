import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/order.dart';
import '../../state/orders_controller.dart';
import 'order_detail_screen.dart';
import 'widgets/order_card.dart';

/// Écran de liste des commandes, triées par date décroissante.
class OrdersScreen extends StatelessWidget {
  /// Affiche les commandes chargées par OrdersController.
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController orders = context.watch<OrdersController>();
    if (orders.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(orders.errorMessage!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: orders.loadOrders,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    if (orders.orders.isEmpty) {
      return const Center(child: Text('Aucune commande pour le moment.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.orders.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final Order order = orders.orders[index];
        return OrderCard(
          order: order,
          total: orders.totalFor(order),
          onTap: () => _openOrder(context, order),
        );
      },
    );
  }

  void _openOrder(BuildContext context, Order order) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => OrderDetailScreen(order: order),
      ),
    );
  }
}
