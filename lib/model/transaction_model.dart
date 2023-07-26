class TransactionModel {
  final String id;
  final String nipd;
  final String instansi;
  final String nominal;
  final String status;
  final String image;
  final String keterangan;
  final String thn_akademik;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.nipd,
    required this.instansi,
    required this.nominal,
    required this.status,
    required this.image,
    required this.keterangan,
    required this.thn_akademik,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      nipd: json['nipd'] as String,
      instansi: json['instansi'] as String,
      nominal: json['nominal'] as String,
      status: json['status'] as String,
      image: json['image'] as String,
      keterangan: json['keterangan'] as String,
      thn_akademik: json['thn_akademik'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
