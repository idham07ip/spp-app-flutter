class Status {
  String diterima;
  String ditolak;
  String pending;

  Status({
    required this.diterima,
    required this.ditolak,
    required this.pending,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      diterima: json['diterima'] ?? "",
      ditolak: json['ditolak'] ?? "",
      pending: json['pending'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diterima'] = this.diterima;
    data['ditolak'] = this.ditolak;
    data['pending'] = this.pending;

    return data;
  }
}
