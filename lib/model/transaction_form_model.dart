class TransactionFormModel {
  final String? nis;
  final String? nama_siswa;
  final String? nominal;
  final String? total_payment;
  final String? status;
  final String? keterangan;
  final String? image;
  final DateTime? created_at;
  final DateTime? start_date;
  final DateTime? end_date;
  bool isNew;

  TransactionFormModel({
    this.nis,
    this.nama_siswa,
    this.nominal,
    this.total_payment,
    this.status,
    this.keterangan,
    this.image,
    this.created_at,
    this.start_date,
    this.end_date,
    this.isNew = false,
  });

  factory TransactionFormModel.fromJson(Map<String, dynamic> json) =>
      TransactionFormModel(
        nis: json['nis'],
        nama_siswa: json['nama_siswa'],
        nominal: json['nominal'],
        total_payment: json['total_payment'],
        status: json['status'],
        keterangan: json['keterangan'],
        image: json['image'],
        created_at: DateTime.tryParse(json['created_at']),
        start_date: json['start_date'],
        end_date: json['end_date'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nis'] = this.nis;
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;
    return data;
  }

  TransactionFormModel copyWith({
    String? nis,
    String? nama_siswa,
    String? nominal,
    String? total_payment,
    String? status,
    String? keterangan,
    String? image,
    DateTime? created_at,
    DateTime? start_date,
    DateTime? end_date,
  }) =>
      TransactionFormModel(
        nis: nis ?? this.nis,
        nama_siswa: nama_siswa ?? this.nama_siswa,
        nominal: nominal ?? this.nominal,
        total_payment: total_payment ?? this.total_payment,
        status: status ?? this.status,
        keterangan: keterangan ?? this.keterangan,
        image: image ?? this.image,
        created_at: created_at != null
            ? DateTime.tryParse(created_at.toString()) ?? this.created_at
            : this.created_at,
        start_date: start_date ?? this.start_date,
        end_date: end_date ?? this.end_date,
      );
}
