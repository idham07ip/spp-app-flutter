class NominalData {
  List<Transaction> data;

  NominalData({required this.data});

  factory NominalData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      List<Transaction> data = [];

      for (var transactionData in json['data']) {
        data.add(Transaction.fromJson(transactionData));
      }

      return NominalData(data: data);
    } else {
      throw Exception('Data is not in the expected format');
    }
  }
}

class Transaction {
  final String bulan;
  final int nominal;
  final String thn_akademik;

  Transaction({
    required this.bulan,
    required this.nominal,
    required this.thn_akademik,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      bulan: json['bulan'],
      nominal: json['nominal'],
      thn_akademik: json['thn_akademik'],
    );
  }
}
