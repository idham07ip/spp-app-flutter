class DataPriceModel {
  String biayaInstansi;
  String? biayaTambahan;
  String? potongan;
  String totalBiaya;

  DataPriceModel({
    required this.biayaInstansi,
    this.biayaTambahan,
    this.potongan,
    required this.totalBiaya,
  });

  factory DataPriceModel.fromJson(Map<String, dynamic> json) {
    return DataPriceModel(
      biayaInstansi: json['biaya_instansi'] ?? '',
      biayaTambahan: json['biaya_tambahan'] ?? null,
      potongan: json['potongan'] ?? null,
      totalBiaya: json['total_biaya'].toString(),
    );
  }
}
