// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:spp_app/model/pembayaran_form_model.dart';
import 'package:spp_app/model/transaction_form_model.dart';

import '../model/filter_amount.dart';

class PaymentMethodService {
  static const String Url = 'https://arrahman.site/spp-web/api';
  static const String token = 'KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9';

  Future<NominalData> fetchNominalData(String nipd, String thnAkademik) async {
    try {
      final url = Uri.parse(
          'https://arrahman.site/spp-web/api/nominalfilter?nipd=$nipd&thn_akademik=$thnAkademik');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          List<Transaction> transactions = jsonData
              .map((transactionData) => Transaction.fromJson(transactionData))
              .toList();

          return NominalData(data: transactions);
        } else {
          throw Exception('Data is not in the expected format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle the error gracefully
      print('Error fetching nominal data: $e');
      throw Exception('Failed to fetch nominal data');
    }
  }

  Future<List<TransactionFormModel>> getAdditionalTransactions(
      String nis, int count, int startIndex) async {
    // TODO: Implement the logic to fetch additional transactions
    // based on the given parameters (nis, count, startIndex).
    // Return a list of TransactionFormModel objects.
    // You can use any API or data source to fetch the data.
    // For now, I'll return an empty list as a placeholder.
    return [];
  }

  Future<String> payment(PembayaranFormModel data, PlatformFile? image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$Url/upload'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['nipd'] = data.nipd ?? '';
    request.fields['nama_siswa'] = data.nama_siswa ?? '';
    request.fields['instansi'] = data.instansi ?? '';
    request.fields['nominal'] = data.nominal ?? '';
    request.fields['keterangan'] = data.keterangan ?? '';
    request.fields['start_range_date'] = data.startRangeDate ?? '';
    request.fields['end_range_date'] = data.endRangeDate ?? '';
    request.fields['thn_akademik'] = data.thn_akademik ?? '';
    // request.fields['start_range_date'] =
    //     data.startRangeDate?.toIso8601String() ?? '';
    // request.fields['end_range_date'] =
    //     data.endRangeDate?.toIso8601String() ?? '';

    if (image != null) {
      // Convert PlatformFile to File
      var file = File(image.path!);

      // Read image file
      var imageBytes = await file.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: image.name,
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return responseData;
    } else {
      var errorResponse;
      try {
        errorResponse = jsonDecode(responseData);
      } catch (e) {
        throw Exception('Failed to checkout: $responseData');
      }

      if (errorResponse is Map<String, dynamic> &&
          errorResponse.containsKey('error')) {
        throw ('${errorResponse['error']}');
      } else {
        throw ('Failed to checkout');
      }
    }
  }

  Future<List<TransactionFormModel>> getTransactionDate(
      String nipd, DateTime? startDate, DateTime? endDate) async {
    if (startDate == null || endDate == null) {
      throw ArgumentError('Start date and end date must not be null');
    }

    final formattedStartDate = startDate.toString().substring(0, 10);
    final formattedEndDate = endDate.toString().substring(0, 10);

    final url = Uri.parse(
        '$Url/filterdate?nipd=$nipd&start_date=$formattedStartDate&end_date=$formattedEndDate&sort=asc');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> transactionList = jsonDecode(response.body);
        final transactions = transactionList
            .map((dynamic item) =>
                TransactionFormModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return transactions;
      } else {
        throw jsonDecode(response.body)['error'];
      }
    } catch (e) {
      print('getTransactionDate error: $e');
      rethrow;
    }
  }

  Future<List<TransactionFormModel>> getTransaction(String nipd) async {
    try {
      final res = await http.get(
        Uri.parse('$Url/getpayments/$nipd?sort=-created_at'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        if (data.isNotEmpty) {
          return data
              .map((transaction) => TransactionFormModel.fromJson(transaction))
              .toList();
        } else {
          throw 'Data tidak ditemukan';
        }
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
