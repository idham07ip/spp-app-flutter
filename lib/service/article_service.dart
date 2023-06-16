import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spp_app/model/news_form_model.dart';

class ArticleService {
  static const String baseUrl =
      'https://newsapi.org/v2/top-headlines?country=id&apiKey=a1b05467561945c2863ce7f4785e10f6';

  Future<List<Article>> getArticles() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl'),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson.map((articleJson) {
          return Article.fromJson(articleJson);
        }).toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Failed to load articles');
    }
  }
}
