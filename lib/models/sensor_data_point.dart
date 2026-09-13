enum AlertPriority { low, medium, high, critical }

class SensorDataPoint {
  const SensorDataPoint({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.alerts,
    required this.priority,
  });

  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final List<String> alerts;
  final AlertPriority priority;

  String get primaryAlert =>
      alerts.isEmpty ? 'Optimal Condition' : alerts.first;

  factory SensorDataPoint.offline() {
    return SensorDataPoint(
      timestamp: DateTime.now(),
      temperature: 0,
      humidity: 0,
      soilMoisture: 0,
      alerts: const ['Sensor Offline'],
      priority: AlertPriority.low,
    );
  }

  factory SensorDataPoint.fromJson(Map<String, dynamic> json) {
    return SensorDataPoint(
      timestamp: DateTime.parse(json['created_at'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      soilMoisture: (json['soil_moisture'] as num).toDouble(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((alert) => alert.toString())
          .toList(),
      priority: priorityFromString(json['priority'].toString()),
    );
  }
}

AlertPriority priorityFromString(String value) {
  switch (value.toUpperCase()) {
    case 'CRITICAL':
      return AlertPriority.critical;
    case 'HIGH':
      return AlertPriority.high;
    case 'MEDIUM':
      return AlertPriority.medium;
    case 'LOW':
    default:
      return AlertPriority.low;
  }
}
