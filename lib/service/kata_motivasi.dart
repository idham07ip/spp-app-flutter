import 'dart:convert';
import 'dart:math';
import 'package:spp_app/model/quotes_form_model.dart';
import 'package:http/http.dart' as http;

class KataMotivasi {
  static const String baseUrl = 'https://type.fit/api/quotes';

  static Future<KataMotivasiFormModel> getMotivasi() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl'),
      );

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body) as List<dynamic>;
        final motivasiIndex = Random().nextInt(jsonData.length);
        final motivasi =
            KataMotivasiFormModel.fromJson(jsonData[motivasiIndex]);
        return motivasi;
      } else {
        throw Exception(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
