import 'package:flutter/material.dart';

import '../models/analysis_summary.dart';
import '../models/sensor_data_point.dart';
import '../services/agri_api_service.dart';

class VisualizationScreen extends StatelessWidget {
  const VisualizationScreen({
    super.key,
    required this.apiService,
    required this.latestPoint,
    required this.analysisSummary,
    required this.onRefresh,
  });

  final AgriApiService apiService;
  final SensorDataPoint latestPoint;
  final AnalysisSummary? analysisSummary;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final summary = analysisSummary;
    final charts = [
      _ChartInfo(
        title: 'Temperature vs Time',
        metric: 'temperature',
        icon: Icons.thermostat,
        color: const Color(0xFFD84315),
      ),
      _ChartInfo(
        title: 'Humidity vs Time',
        metric: 'humidity',
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF0277BD),
      ),
      _ChartInfo(
        title: 'Soil Moisture vs Time',
        metric: 'soil_moisture',
        icon: Icons.grass,
        color: const Color(0xFF2E7D32),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            tooltip: 'Regenerate data',
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (summary != null) ...[
            _HealthPanel(summary: summary),
            const SizedBox(height: 12),
            _MetricGrid(summary: summary, latestPoint: latestPoint),
            const SizedBox(height: 12),
          ],
          ...charts.map(
            (chart) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _MatplotlibChartCard(
                chart: chart,
                imageUrl: apiService.chartUrl(chart.metric),
                summary: summary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthPanel extends StatelessWidget {
  const _HealthPanel({required this.summary});

  final AnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Backend Data Analytics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${summary.healthScore}/100',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.recommendation,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            summary.irrigationAdvice,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            '${summary.totalRecords} records | ${summary.dataSource}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'Range: ${_formatDateTime(summary.dateRange['start'])} to '
            '${_formatDateTime(summary.dateRange['end'])}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return '--';
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.summary, required this.latestPoint});

  final AnalysisSummary summary;
  final SensorDataPoint latestPoint;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _MetricTileData(
        'Temp Avg',
        '${_value(summary.averages, 'temperature')} \u00B0C',
        'Trend ${_signed(summary.trend['temperature'])}',
        Icons.thermostat,
        const Color(0xFFD84315),
      ),
      _MetricTileData(
        'Humidity Avg',
        '${_value(summary.averages, 'humidity')}%',
        'Trend ${_signed(summary.trend['humidity'])}',
        Icons.water_drop_outlined,
        const Color(0xFF0277BD),
      ),
      _MetricTileData(
        'Soil Avg',
        '${_value(summary.averages, 'soil_moisture')}%',
        'Latest ${latestPoint.soilMoisture.toStringAsFixed(0)}%',
        Icons.grass,
        const Color(0xFF2E7D32),
      ),
      _MetricTileData(
        'Data Used',
        '${summary.totalRecords}',
        '${summary.dummyRecords} dummy | ${summary.liveRecords} live',
        Icons.dataset_outlined,
        const Color(0xFF6A1B9A),
      ),
    ];

    return GridView.builder(
      itemCount: tiles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 650 ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: MediaQuery.sizeOf(context).width > 650 ? 1.35 : 1.18,
      ),
      itemBuilder: (context, index) => _MetricTile(data: tiles[index]),
    );
  }

  static String _value(Map<String, double> source, String key) {
    return (source[key] ?? 0).toStringAsFixed(1);
  }

  static String _signed(double? value) {
    final safeValue = value ?? 0;
    final prefix = safeValue > 0 ? '+' : '';
    return '$prefix${safeValue.toStringAsFixed(1)}';
  }
}

class _MetricTileData {
  const _MetricTileData(
    this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.color,
  );

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.data});

  final _MetricTileData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.color),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            data.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ChartInfo {
  const _ChartInfo({
    required this.title,
    required this.metric,
    required this.icon,
    required this.color,
  });

  final String title;
  final String metric;
  final IconData icon;
  final Color color;
}

class _MatplotlibChartCard extends StatelessWidget {
  const _MatplotlibChartCard({
    required this.chart,
    required this.imageUrl,
    required this.summary,
  });

  final _ChartInfo chart;
  final String imageUrl;
  final AnalysisSummary? summary;

  @override
  Widget build(BuildContext context) {
    final cacheKey = DateTime.now().millisecondsSinceEpoch;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(chart.icon, color: chart.color),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chart.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (summary != null)
                      Text(
                        '${summary!.chartPoints} plotted points from '
                        '${summary!.totalRecords} DB records',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              if (summary != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: summary!.liveRecords > 0
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    summary!.liveRecords > 0 ? 'LIVE' : 'DUMMY',
                    style: TextStyle(
                      color: summary!.liveRecords > 0
                          ? const Color(0xFF0D47A1)
                          : const Color(0xFFE65100),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                '$imageUrl?cache=$cacheKey',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFFEBEE),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Chart unavailable. Start Django backend and retry.',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
