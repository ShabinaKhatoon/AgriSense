import 'dart:async';

import 'package:flutter/material.dart';

import '../models/analysis_summary.dart';
import '../models/farmer.dart';
import '../models/sensor_data_point.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.farmer,
    required this.latestPoint,
    required this.analysisSummary,
    required this.onRefresh,
    required this.onLogout,
  });

  final Farmer farmer;
  final SensorDataPoint latestPoint;
  final AnalysisSummary? analysisSummary;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _clock;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _clock = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _clock = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final point = widget.latestPoint;
    final tempPercent = (point.temperature / 50).clamp(0.0, 1.0).toDouble();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/farm.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.26)),
          BackdropFilterOverlay(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 44,
                      ),
                      child: Column(
                        children: [
                          _Header(onLogout: widget.onLogout),
                          SizedBox(height: constraints.maxHeight * 0.04),
                          Text(
                            _formatClock(_clock),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(_clock),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.07),
                          const Text(
                            'Temperature',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 28),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${point.temperature.toStringAsFixed(1)} \u00B0C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 70,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 34),
                          _TemperatureBar(value: tempPercent),
                          const SizedBox(height: 42),
                          _GlassMetrics(point: point),
                          const SizedBox(height: 22),
                          _MiniStatus(
                            farmerName: widget.farmer.fullName,
                            summary: widget.analysisSummary,
                            alert: point.primaryAlert,
                          ),
                          const SizedBox(height: 96),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 22,
            bottom: 22,
            child: FloatingActionButton.large(
              heroTag: 'refresh-dashboard',
              onPressed: widget.onRefresh,
              backgroundColor: const Color(0xFFE9D9F6),
              foregroundColor: const Color(0xFF5D3E96),
              child: const Icon(Icons.refresh, size: 34),
            ),
          ),
        ],
      ),
    );
  }

  String _formatClock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String _formatDate(DateTime value) {
    return '${value.day}/${value.month}/${value.year}';
  }
}

class BackdropFilterOverlay extends StatelessWidget {
  const BackdropFilterOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04)),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(7),
          color: Colors.white,
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 18),
        const Expanded(
          child: Text(
            'AgriSense',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              letterSpacing: 0,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Logout',
          onPressed: onLogout,
          icon: const Icon(Icons.settings, color: Colors.white, size: 36),
        ),
      ],
    );
  }
}

class _TemperatureBar extends StatelessWidget {
  const _TemperatureBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF43C463),
                    Color(0xFFFFF052),
                    Color(0xFFFF9800),
                    Color(0xFFF44336),
                  ],
                ),
              ),
            ),
            Positioned(
              left: (constraints.maxWidth * value)
                  .clamp(0.0, constraints.maxWidth - 18)
                  .toDouble(),
              top: 0,
              bottom: 0,
              child: Container(
                width: 18,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlassMetrics extends StatelessWidget {
  const _GlassMetrics({required this.point});

  final SensorDataPoint point;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
      ),
      child: Column(
        children: [
          _MetricRow(
            label: 'Moisture',
            value: '${point.soilMoisture.toStringAsFixed(0)}%',
          ),
          const SizedBox(height: 24),
          _MetricRow(
            label: 'Humidity',
            value: '${point.humidity.toStringAsFixed(0)}%',
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _MiniStatus extends StatelessWidget {
  const _MiniStatus({
    required this.farmerName,
    required this.summary,
    required this.alert,
  });

  final String farmerName;
  final AnalysisSummary? summary;
  final String alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$farmerName | $alert'
        '${summary == null ? '' : ' | Score ${summary!.healthScore}/100'}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
