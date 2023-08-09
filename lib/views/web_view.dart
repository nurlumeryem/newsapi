import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/model/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../riverpod_manager.dart';

class MyWebView extends ConsumerWidget {
  const MyWebView({super.key, required this.news});

  final Articles news;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(news.title ?? ""),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Share.share(news.url ?? "");
              },
              icon: const Icon(Icons.ios_share_rounded),
            ),
            IconButton(
              icon: Icon(
                // Use Icons.favorite if news is in favoriteList, otherwise use Icons.favorite_border_outlined
                viewModel.favoriteList?.contains(news) ?? false
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: viewModel.favoriteList?.contains(news) ?? false
                    ? Colors.white
                    : Colors.white,
              ),
              onPressed: () async {
                viewModel.favoriteList?.add(news);
                await viewModel.sharredSave();
              },
            ),
          ],
        ),
        body: WebView(
          initialUrl: news.url,
        ));
  }
}
