import 'dart:convert';
import "package:http/http.dart";
import 'package:flutter_news/models/article.dart';

Map<String, List<Article>> cache = {};

class ApiService {
  Future<List<Article>> getArticles(
      {required String endpoint, bool forceRefresh = false}) async {
    if (cache.containsKey(endpoint) && !forceRefresh) {
      return cache[endpoint]!;
    }
    var response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> data = json['articles'];
      List<Article> articles =
          data.map((dynamic item) => Article.fromJson(item)).toList();
      cache[endpoint] = articles;
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
