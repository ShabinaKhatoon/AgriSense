import 'package:flutter/material.dart';

import '../models/sensor_data_point.dart';

class PriorityStyle {
  const PriorityStyle({
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });

  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData icon;
}

PriorityStyle priorityStyle(AlertPriority priority) {
  switch (priority) {
    case AlertPriority.critical:
      return const PriorityStyle(
        label: 'CRITICAL',
        color: Color(0xFFC62828),
        backgroundColor: Color(0xFFFFEBEE),
        icon: Icons.priority_high,
      );
    case AlertPriority.high:
      return const PriorityStyle(
        label: 'HIGH',
        color: Color(0xFFEF6C00),
        backgroundColor: Color(0xFFFFF3E0),
        icon: Icons.warning_amber_rounded,
      );
    case AlertPriority.medium:
      return const PriorityStyle(
        label: 'MEDIUM',
        color: Color(0xFFF9A825),
        backgroundColor: Color(0xFFFFFDE7),
        icon: Icons.info_outline,
      );
    case AlertPriority.low:
      return const PriorityStyle(
        label: 'LOW',
        color: Color(0xFF2E7D32),
        backgroundColor: Color(0xFFE8F5E9),
        icon: Icons.check_circle_outline,
      );
  }
}
