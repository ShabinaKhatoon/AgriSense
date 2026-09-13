import 'package:flutter/material.dart';

import '../models/sensor_data_point.dart';
import '../widgets/priority_style.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({
    super.key,
    required this.dataPoints,
    required this.onRefresh,
  });

  final List<SensorDataPoint> dataPoints;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final alertPoints = dataPoints.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Alerts'),
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: alertPoints.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final point = alertPoints[index];
          final style = priorityStyle(point.priority);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: style.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(style.icon, color: style.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              style.label,
                              style: TextStyle(
                                color: style.color,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0,
                              ),
                            ),
                            Text(
                              _formatTimestamp(point.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          point.alerts.join(' | '),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Temp ${point.temperature.toStringAsFixed(1)} \u00B0C   '
                          'Humidity ${point.humidity.toStringAsFixed(1)} %   '
                          'Soil ${point.soilMoisture.toStringAsFixed(1)} %',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }
}
