class DataPriceModel {
  final String message;
  final List<DataItem> data;
  final String potongan;
  final int total;

  DataPriceModel({
    required this.message,
    required this.data,
    required this.potongan,
    required this.total,
  });

  factory DataPriceModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonData = json['data'];
    List<DataItem> data = jsonData.map((item) {
      return DataItem(
        jenisPembayaran: item['jenis_pembayaran'],
        biaya: item['biaya'],
      );
    }).toList();

    return DataPriceModel(
      message: json['message'],
      data: data,
      potongan: json['potongan'],
      total: json['total'] as int,
    );
  }
}

class DataItem {
  final String jenisPembayaran;
  final String biaya;

  DataItem({
    required this.jenisPembayaran,
    required this.biaya,
  });
}
