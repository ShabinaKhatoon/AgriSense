import 'dart:async';

import 'package:flutter/material.dart';

import 'models/analysis_summary.dart';
import 'models/farmer.dart';
import 'models/sensor_data_point.dart';
import 'screens/account_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/visualization_screen.dart';
import 'services/agri_api_service.dart';

void main() {
  runApp(const AgriSenseApp());
}

class AgriSenseApp extends StatelessWidget {
  const AgriSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        fontFamily: 'serif',
        scaffoldBackgroundColor: const Color(0xFFF5F7F2),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: const SmartFarmHome(),
    );
  }
}

class SmartFarmHome extends StatefulWidget {
  const SmartFarmHome({super.key});

  @override
  State<SmartFarmHome> createState() => _SmartFarmHomeState();
}

class _SmartFarmHomeState extends State<SmartFarmHome> {
  final AgriApiService _apiService = const AgriApiService();
  Farmer? _farmer;
  SensorDataPoint? _latestPoint;
  AnalysisSummary? _analysisSummary;
  String? _errorMessage;
  bool _isLoading = true;
  int _currentIndex = 0;
  Timer? _liveTimer;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Future<void> _handleLogin(Farmer farmer) async {
    setState(() => _farmer = farmer);
    await _loadData();
    _startLiveUpdates();
  }

  Future<void> _handleLogout() async {
    _liveTimer?.cancel();
    _liveTimer = null;
    final farmer = _farmer;
    if (farmer != null) {
      try {
        await _apiService.logoutFarmer(farmer.id);
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _farmer = null;
      _latestPoint = null;
      _analysisSummary = null;
      _errorMessage = null;
      _currentIndex = 0;
    });
  }

  void _startLiveUpdates() {
    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _refreshLatestPoint();
    });
  }

  Future<void> _refreshLatestPoint() async {
    if (_farmer == null) return;
    try {
      final latest = await _apiService.fetchLatestData();
      if (!mounted || _farmer == null) return;
      setState(() {
        _latestPoint = latest;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted || _farmer == null) return;
      setState(() {
        _latestPoint = SensorDataPoint.offline();
      });
    }
  }

  Future<void> _loadData({bool regenerate = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (regenerate) {
        await _apiService.generateDummyData();
      }

      final latest = await _apiService.fetchLatestData();
      final analysis = await _apiService.fetchAnalysisSummary();

      if (!mounted) return;
      setState(() {
        _latestPoint = latest;
        _analysisSummary = analysis;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Backend is not reachable. Start Django on port 8000 and try again.';
        _latestPoint = SensorDataPoint.offline();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_farmer == null) {
      return LoginScreen(apiService: _apiService, onLogin: _handleLogin);
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null || _latestPoint == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AgriSense')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 54, color: Color(0xFFD84315)),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'No data available.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _loadData(regenerate: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Generate Data'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screens = [
      DashboardScreen(
        farmer: _farmer!,
        latestPoint: _latestPoint!,
        analysisSummary: _analysisSummary,
        onRefresh: () => _loadData(regenerate: true),
        onLogout: _handleLogout,
      ),
      VisualizationScreen(
        apiService: _apiService,
        analysisSummary: _analysisSummary,
        latestPoint: _latestPoint!,
        onRefresh: () => _loadData(regenerate: true),
      ),
      AccountScreen(farmer: _farmer!, onLogout: _handleLogout),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFF8F2F8),
        indicatorColor: const Color(0xFFE6F3E3),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined),
            selectedIcon: Icon(Icons.insert_chart),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.login_outlined),
            selectedIcon: Icon(Icons.logout),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}
