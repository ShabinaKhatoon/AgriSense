class AnalysisSummary {
  const AnalysisSummary({
    required this.totalRecords,
    required this.averages,
    required this.minimums,
    required this.maximums,
    required this.priorityCounts,
    required this.recommendation,
    required this.trend,
    required this.healthScore,
    required this.dataSource,
    required this.dummyRecords,
    required this.liveRecords,
    required this.dateRange,
    required this.chartPoints,
    required this.irrigationAdvice,
  });

  final int totalRecords;
  final Map<String, double> averages;
  final Map<String, double> minimums;
  final Map<String, double> maximums;
  final Map<String, int> priorityCounts;
  final String recommendation;
  final Map<String, double> trend;
  final int healthScore;
  final String dataSource;
  final int dummyRecords;
  final int liveRecords;
  final Map<String, DateTime> dateRange;
  final int chartPoints;
  final String irrigationAdvice;

  factory AnalysisSummary.fromJson(Map<String, dynamic> json) {
    return AnalysisSummary(
      totalRecords: (json['total_records'] as num?)?.toInt() ?? 0,
      averages: _doubleMap(json['averages']),
      minimums: _doubleMap(json['minimums']),
      maximums: _doubleMap(json['maximums']),
      priorityCounts: _intMap(json['priority_counts']),
      recommendation: json['recommendation']?.toString() ?? '',
      trend: _doubleMap(json['trend']),
      healthScore: (json['health_score'] as num?)?.toInt() ?? 0,
      dataSource: json['data_source']?.toString() ?? '',
      dummyRecords: (json['dummy_records'] as num?)?.toInt() ?? 0,
      liveRecords: (json['live_records'] as num?)?.toInt() ?? 0,
      dateRange: _dateMap(json['date_range']),
      chartPoints: (json['chart_points'] as num?)?.toInt() ?? 0,
      irrigationAdvice: json['irrigation_advice']?.toString() ?? '',
    );
  }

  static Map<String, double> _doubleMap(dynamic value) {
    if (value is! Map<String, dynamic>) return {};
    return value.map(
      (key, mapValue) => MapEntry(key, (mapValue as num).toDouble()),
    );
  }

  static Map<String, int> _intMap(dynamic value) {
    if (value is! Map<String, dynamic>) return {};
    return value.map(
      (key, mapValue) => MapEntry(key, (mapValue as num).toInt()),
    );
  }

  static Map<String, DateTime> _dateMap(dynamic value) {
    if (value is! Map<String, dynamic>) return {};
    return value.map(
      (key, mapValue) => MapEntry(key, DateTime.parse(mapValue.toString())),
    );
  }
}
