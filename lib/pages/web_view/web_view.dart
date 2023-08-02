import 'package:flutter/material.dart';
import 'package:newsapi/model/article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  const MyWebView({super.key, required this.news});

  final Articles news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(news.title ?? ""),
          centerTitle: true,
        ),
        body: WebView(
          initialUrl: news.url,
        ));
  }
}
