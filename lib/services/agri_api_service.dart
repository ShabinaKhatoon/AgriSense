import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/analysis_summary.dart';
import '../models/farmer.dart';
import '../models/sensor_data_point.dart';

const _configuredApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '',
);

class AgriApiService {
  const AgriApiService({http.Client? client}) : _client = client;

  static const _requestTimeout = Duration(seconds: 8);
  static String? _lastReachableBaseUrl;

  final http.Client? _client;

  http.Client get _httpClient => _client ?? http.Client();
  List<String> get _apiBaseUrls {
    if (_configuredApiBaseUrl.isNotEmpty) {
      return [_configuredApiBaseUrl];
    }

    if (kIsWeb) {
      final currentHost = Uri.base.host;
      final host = currentHost.isEmpty ? '127.0.0.1' : currentHost;
      return [
        'http://$host:8000/api',
        if (host != '127.0.0.1') 'http://127.0.0.1:8000/api',
      ];
    }

    return const ['http://10.0.2.2:8000/api', 'http://127.0.0.1:8000/api'];
  }

  Future<Farmer> registerFarmer({
    required String fullName,
    required String phone,
    required String password,
    required String village,
    required double farmSizeAcres,
  }) async {
    final response = await _postJson(
      '/auth/register/',
      body: jsonEncode({
        'full_name': fullName,
        'phone': phone,
        'password': password,
        'village': village,
        'farm_size_acres': farmSizeAcres,
      }),
    );
    _throwIfFailed(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return Farmer.fromJson(body['farmer'] as Map<String, dynamic>);
  }

  Future<Farmer> loginFarmer({
    required String phone,
    required String password,
  }) async {
    final response = await _postJson(
      '/auth/login/',
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    _throwIfFailed(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return Farmer.fromJson(body['farmer'] as Map<String, dynamic>);
  }

  Future<void> logoutFarmer(int farmerId) async {
    final response = await _postJson(
      '/auth/logout/',
      body: jsonEncode({'farmer_id': farmerId}),
    );
    _throwIfFailed(response);
  }

  Future<void> generateDummyData() async {
    final response = await _get('/generate-dummy-data/');
    _throwIfFailed(response);
  }

  Future<SensorDataPoint> fetchLatestData() async {
    final response = await _get('/latest/');
    _throwIfFailed(response);
    return SensorDataPoint.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<SensorDataPoint>> fetchAlerts() async {
    final response = await _get('/alerts/');
    _throwIfFailed(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['alerts'] as List<dynamic>)
        .map((item) => SensorDataPoint.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AnalysisSummary> fetchAnalysisSummary() async {
    final response = await _get('/analysis/');
    _throwIfFailed(response);
    return AnalysisSummary.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  String chartUrl(String metric) {
    return _buildUrl(
      _lastReachableBaseUrl ?? _apiBaseUrls.first,
      '/chart/$metric/',
    );
  }

  Future<http.Response> _get(String path) async {
    return _request((baseUrl) {
      return _httpClient
          .get(Uri.parse(_buildUrl(baseUrl, path)))
          .timeout(_requestTimeout);
    });
  }

  Future<http.Response> _postJson(String path, {required String body}) async {
    return _request((baseUrl) {
      return _httpClient
          .post(
            Uri.parse(_buildUrl(baseUrl, path)),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(_requestTimeout);
    });
  }

  Future<http.Response> _request(
    Future<http.Response> Function(String baseUrl) send,
  ) async {
    final configuredBaseUrls = _apiBaseUrls;
    final lastReachableBaseUrl = _lastReachableBaseUrl;
    final baseUrls =
        lastReachableBaseUrl != null &&
            configuredBaseUrls.contains(lastReachableBaseUrl)
        ? [
            lastReachableBaseUrl,
            ...configuredBaseUrls.where((url) => url != lastReachableBaseUrl),
          ]
        : configuredBaseUrls;
    Object? lastError;
    for (final baseUrl in baseUrls) {
      try {
        final response = await send(baseUrl);
        _lastReachableBaseUrl = baseUrl;
        return response;
      } catch (error) {
        lastError = error;
      }
    }

    throw Exception(
      'Backend is not reachable at ${baseUrls.join(', ')}. '
      'Start Django on port 8000 or pass --dart-define=API_BASE_URL=http://YOUR_PC_IP:8000/api. '
      'Last error: $lastError',
    );
  }

  String _buildUrl(String baseUrl, String path) {
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBaseUrl$cleanPath';
  }

  void _throwIfFailed(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String? message;
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        message = body['error']?.toString();
      } catch (_) {
        message = null;
      }
      throw Exception(
        message ?? 'API request failed with status ${response.statusCode}',
      );
    }
  }
}
