// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:spp_app/model/pembayaran_form_model.dart';
import 'package:spp_app/model/transaction_form_model.dart';

class PaymentMethodService {
  static const String Url = 'https://arrahman.site/api_spp/api';
  static const String token = 'KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9';

  Future<String> payment(PembayaranFormModel data, PlatformFile? image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$Url/upload'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['nis'] = data.nis ?? '';
    request.fields['nama_siswa'] = data.nama_siswa ?? '';
    request.fields['instansi'] = data.instansi ?? '';
    request.fields['nominal'] = data.nominal ?? '';
    request.fields['keterangan'] = data.keterangan ?? '';

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
      throw Exception('Failed to checkout: $responseData');
    }
  }

  Future<List<TransactionFormModel>> getTransactionDate(
      String nis, DateTime startDate, DateTime endDate) async {
    final Uri url = Uri.parse(
      '$Url/filterdate?nis=$nis&start_date=${startDate.toString().substring(0, 10)}&end_date=${endDate.toString().substring(0, 10)}&sort=-created_at',
    );
    try {
      final http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> transactionList = jsonDecode(response.body);
        final List<TransactionFormModel> transactions =
            transactionList.map((dynamic item) {
          return TransactionFormModel.fromJson(item as Map<String, dynamic>);
        }).toList();

        print('getTransactionDate success: $transactions');
        return transactions;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print('getTransactionDate error: $e');
      rethrow;
    }
  }

  Future<List<TransactionFormModel>> getTransaction(
    String nis,
  ) async {
    try {
      final res = await http.get(
        Uri.parse('$Url/getpayments/$nis?sort=-created_at'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data != null && data is List && data.isNotEmpty) {
          return List<TransactionFormModel>.from(
            data.map(
              (transactions) => TransactionFormModel.fromJson(transactions),
            ),
          ).toList();
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
