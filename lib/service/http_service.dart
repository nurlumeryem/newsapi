import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:newsapi/model/article.dart';
import 'package:newsapi/model/news.dart';

class HttpService {
  static HttpService? _instance;
  HttpService() : super();
  static HttpService get instance {
    return _instance ??= HttpService();
  }

  var baseUrl = "https://newsapi.org/v2/everything";
  var apiKey = "90f78b5e459f4557a6d285161db89387";

  Future<List<Articles>> getNews({String? category, String? pageCount}) async {
    Map<String, dynamic> queryParameters = {
      "q": category ?? "haber",
      "page": pageCount,
      "apiKey": apiKey,
      "language": "tr",
    };
    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);
    var responseData = News.fromJson(jsonDecode(response.body));
    inspect(responseData.articles);
    return responseData.articles!;
  }
}
