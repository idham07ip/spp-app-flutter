class Status {
  final StatusData diterima;
  final StatusData ditolak;
  final StatusData pending;
  final AnalyticsData analytics;

  Status({
    required this.diterima,
    required this.ditolak,
    required this.pending,
    required this.analytics,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      diterima: StatusData.fromJson(json['DITERIMA']),
      ditolak: StatusData.fromJson(json['DITOLAK']),
      pending: StatusData.fromJson(json['PENDING']),
      analytics: AnalyticsData.fromJson(json['analytics']),
    );
  }
}

class StatusData {
  final int count;
  final String nominal;

  StatusData({
    required this.count,
    required this.nominal,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      count: json['count'] ?? 0,
      nominal: json['nominal'] ?? '0',
    );
  }
}

class AnalyticsData {
  final String total_nominal;
  final int total_biaya; // Change the type to int
  final String presentase;

  AnalyticsData({
    required this.total_nominal,
    required this.total_biaya,
    required this.presentase,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      total_nominal: json['total_nominal'] ?? '0',
      total_biaya: json['total_biaya'] ?? 0, // Parse the value as an int
      presentase: json['presentase'] ?? '0%',
    );
  }
}
