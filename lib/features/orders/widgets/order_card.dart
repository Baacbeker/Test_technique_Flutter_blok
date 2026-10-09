import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/fcfa_format.dart';
import '../../../data/models/order.dart';

/// Carte récapitulative d'une commande dans la liste.
class OrderCard extends StatelessWidget {
  /// Le montant est déjà calculé par OrdersController.
  const OrderCard({
    required this.order,
    required this.total,
    required this.onTap,
    super.key,
  });

  final Order order;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    order.reference,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildStatus(),
                ],
              ),
              const SizedBox(height: 6),
              Text(order.site),
              Text(DateFormat('dd/MM/yyyy').format(order.date)),
              const SizedBox(height: 6),
              Text(
                formatFcfa(total),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: order.status.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        order.status.label,
        style: TextStyle(
          color: order.status.onColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
