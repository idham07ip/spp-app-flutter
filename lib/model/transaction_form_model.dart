class TransactionFormModel {
  final String? nipd;
  final String? nama_siswa;
  final String? nominal;
  final String? total_payment;
  final String? status;
  final String? keterangan;
  final String? thn_akademik;
  final String? image;
  final DateTime? created_at;
  final DateTime? bulan;
  final DateTime? start_date;
  final DateTime? end_date;
  bool isNew;

  TransactionFormModel({
    this.nipd,
    this.nama_siswa,
    this.nominal,
    this.total_payment,
    this.status,
    this.keterangan,
    this.thn_akademik,
    this.image,
    this.created_at,
    this.bulan,
    this.start_date,
    this.end_date,
    this.isNew = false,
  });

  factory TransactionFormModel.fromJson(Map<String, dynamic> json) =>
      TransactionFormModel(
        nipd: json['nipd'],
        nama_siswa: json['nama_siswa'],
        nominal: json['nominal'],
        total_payment: json['total_payment'],
        status: json['status'],
        keterangan: json['keterangan'],
        thn_akademik: json['thn_akademik'],
        image: json['image'],
        created_at: DateTime.tryParse(json['created_at']),
        bulan: DateTime.tryParse(json['bulan']),
        start_date: json['start_date'],
        end_date: json['end_date'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nipd'] = this.nipd;
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;
    return data;
  }

  TransactionFormModel copyWith({
    String? nipd,
    String? nama_siswa,
    String? nominal,
    String? total_payment,
    String? status,
    String? keterangan,
    String? thn_akademik,
    String? image,
    DateTime? created_at,
    DateTime? bulan,
    DateTime? start_date,
    DateTime? end_date,
  }) =>
      TransactionFormModel(
        nipd: nipd ?? this.nipd,
        nama_siswa: nama_siswa ?? this.nama_siswa,
        nominal: nominal ?? this.nominal,
        total_payment: total_payment ?? this.total_payment,
        status: status ?? this.status,
        keterangan: keterangan ?? this.keterangan,
        thn_akademik: thn_akademik ?? this.thn_akademik,
        image: image ?? this.image,
        created_at: created_at != null
            ? DateTime.tryParse(created_at.toString()) ?? this.created_at
            : this.created_at,
        bulan: bulan != null
            ? DateTime.tryParse(bulan.toString()) ?? this.bulan
            : this.bulan,
        start_date: start_date ?? this.start_date,
        end_date: end_date ?? this.end_date,
      );
}
