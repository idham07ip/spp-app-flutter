class DataPriceModel {
  final List<Pembayaran> pembayaran;
  final String potongan;
  final int total;

  DataPriceModel({
    required this.pembayaran,
    required this.potongan,
    required this.total,
  });

  factory DataPriceModel.fromJson(Map<String, dynamic> json) {
    final pembayaranList = json['data'] as List<dynamic>;
    final pembayaran =
        pembayaranList.map((item) => Pembayaran.fromJson(item)).toList();
    final potongan = json['potongan'] as String;
    final total = json['total'] as int;

    return DataPriceModel(
      pembayaran: pembayaran,
      potongan: potongan,
      total: total,
    );
  }
}

class Pembayaran {
  final String jenisPembayaran;
  final String biaya;

  Pembayaran({
    required this.jenisPembayaran,
    required this.biaya,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    final jenisPembayaran = json['jenis_pembayaran'] as String;
    final biaya = json['biaya'] as String;

    return Pembayaran(
      jenisPembayaran: jenisPembayaran,
      biaya: biaya,
    );
  }
}
