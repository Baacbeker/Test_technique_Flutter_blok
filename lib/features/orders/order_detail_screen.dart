import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/utils/fcfa_format.dart';
import '../../data/models/order.dart';
import '../../data/models/order_line.dart';
import '../../state/orders_controller.dart';
import 'widgets/status_stepper.dart';

/// Détail d'une commande et avancement dans son cycle de livraison.
class OrderDetailScreen extends StatelessWidget {
  /// La commande sélectionnée dans la liste.
  const OrderDetailScreen({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = context.watch<OrdersController>();
    return Scaffold(
      appBar: AppBar(title: Text(order.reference)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _buildSummary(context),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StatusStepper(currentStatus: order.status),
            ),
          ),
          const SizedBox(height: 16),
          Text('Articles', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...order.lines.map(
            (OrderLine line) => _buildLine(context, controller, line),
          ),
          const SizedBox(height: 12),
          _buildTotal(context, controller),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(order.site, style: Theme.of(context).textTheme.titleMedium),
            Text(DateFormat('dd/MM/yyyy').format(order.date)),
            const SizedBox(height: 6),
            Text(order.status.label),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(
    BuildContext context,
    OrdersController controller,
    OrderLine line,
  ) {
    final String productName = controller.productFor(line.productId).name;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(productName),
      subtitle: Text('Quantité : ${line.qty}'),
      trailing: Text(formatFcfa(controller.lineTotal(line))),
    );
  }

  Widget _buildTotal(BuildContext context, OrdersController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total', style: Theme.of(context).textTheme.titleMedium),
        Text(
          formatFcfa(controller.totalFor(order)),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
