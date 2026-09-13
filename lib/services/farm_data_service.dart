import 'dart:math';

import '../models/sensor_data_point.dart';

class FarmDataService {
  final Random _random = Random();

  List<SensorDataPoint> generateDataPoints() {
    final pointCount = 150 + _random.nextInt(51);
    final now = DateTime.now();

    return List.generate(pointCount, (index) {
      final timestamp = now.subtract(
        Duration(minutes: (pointCount - index) * 15),
      );
      final temperature = _range(15, 45);
      final humidity = _range(20, 95);
      final soilMoisture = _range(10, 100);
      final decision = evaluateConditions(
        temperature: temperature,
        humidity: humidity,
        soilMoisture: soilMoisture,
      );

      return SensorDataPoint(
        timestamp: timestamp,
        temperature: temperature,
        humidity: humidity,
        soilMoisture: soilMoisture,
        alerts: decision.alerts,
        priority: decision.priority,
      );
    });
  }

  FarmDecision evaluateConditions({
    required double temperature,
    required double humidity,
    required double soilMoisture,
  }) {
    final alerts = <String>[];
    var priority = AlertPriority.low;

    void addAlert(String alert, AlertPriority alertPriority) {
      alerts.add(alert);
      if (alertPriority.index > priority.index) {
        priority = alertPriority;
      }
    }

    // Smart irrigation rules evaluate individual thresholds plus combined risks.
    // The highest matched rule controls the reading priority.
    if (soilMoisture < 20) {
      addAlert('Critical Dry Soil', AlertPriority.critical);
    }
    if (soilMoisture < 30) {
      addAlert('Irrigation Needed', AlertPriority.high);
    }
    if (soilMoisture > 90) {
      addAlert('Overwatering Risk', AlertPriority.high);
    }

    if (temperature > 45) {
      addAlert('Extreme Heat', AlertPriority.critical);
    }
    if (temperature > 40) {
      addAlert('Heat Stress', AlertPriority.high);
    }
    if (temperature < 10) {
      addAlert('Cold Stress', AlertPriority.medium);
    }

    if (humidity < 30) {
      addAlert('Low Humidity', AlertPriority.medium);
    }
    if (humidity > 90) {
      addAlert('Fungal Risk', AlertPriority.high);
    }
    if (temperature > 38 && soilMoisture < 30) {
      addAlert('Immediate Irrigation', AlertPriority.critical);
    }
    if (humidity > 82 && soilMoisture > 80) {
      addAlert('Root Rot Risk', AlertPriority.critical);
    }
    if (humidity < 35 && temperature > 38) {
      addAlert('Rapid Evaporation', AlertPriority.high);
    }

    if (temperature > 35 && soilMoisture > 85) {
      addAlert('Warm Wet Soil', AlertPriority.medium);
    }
    if (temperature < 20 && soilMoisture > 75) {
      addAlert('Slow Drying Soil', AlertPriority.medium);
    }
    if (humidity > 75 && temperature > 34) {
      addAlert('High Disease Pressure', AlertPriority.high);
    }
    if (humidity < 40 && soilMoisture < 40) {
      addAlert('Dry Air and Soil', AlertPriority.high);
    }
    if (temperature >= 24 &&
        temperature <= 32 &&
        humidity >= 45 &&
        humidity <= 70 &&
        soilMoisture >= 45 &&
        soilMoisture <= 75) {
      addAlert('Optimal Condition', AlertPriority.low);
    }
    if (temperature >= 30 &&
        temperature <= 38 &&
        soilMoisture >= 30 &&
        soilMoisture < 45) {
      addAlert('Monitor Soil Moisture', AlertPriority.medium);
    }
    if (soilMoisture >= 70 && soilMoisture <= 90 && humidity >= 70) {
      addAlert('Reduce Irrigation Frequency', AlertPriority.medium);
    }
    if (temperature >= 33 && humidity <= 45 && soilMoisture >= 50) {
      addAlert('Mulching Recommended', AlertPriority.medium);
    }

    if (temperature >= 28 && humidity >= 45 && soilMoisture >= 35) {
      addAlert('Crop Growth Favorable', AlertPriority.low);
    }
    if (alerts.isEmpty) {
      addAlert('Optimal Condition', AlertPriority.low);
    }

    return FarmDecision(alerts: alerts, priority: priority);
  }

  double _range(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }
}

class FarmDecision {
  const FarmDecision({required this.alerts, required this.priority});

  final List<String> alerts;
  final AlertPriority priority;
}
