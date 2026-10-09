import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/order_status.dart';

/// Suivi visuel des cinq statuts dans l'ordre de leur cycle de vie.
class StatusStepper extends StatelessWidget {
  /// Le statut courant détermine l'étape mise en évidence.
  const StatusStepper({required this.currentStatus, super.key});

  final OrderStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: OrderStatus.values
          .asMap()
          .entries
          .map(
            (MapEntry<int, OrderStatus> entry) =>
                _buildStep(entry.key, entry.value),
          )
          .toList(),
    );
  }

  Widget _buildStep(int index, OrderStatus status) {
    final int currentIndex = currentStatus.index;
    final bool isCurrent = index == currentIndex;
    final bool isComplete = index < currentIndex;
    final Color color = isCurrent
        ? AppColors.yellow
        : isComplete
            ? AppColors.teal
            : AppColors.border;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Icon(
            isComplete ? Icons.check_circle : Icons.circle,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status.label,
              style: TextStyle(
                color: isCurrent ? AppColors.navy : AppColors.muted,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          if (isCurrent)
            const Icon(Icons.location_on, color: AppColors.yellow, size: 20),
        ],
      ),
    );
  }
}
