import 'package:flutter/material.dart';
import 'package:newsapi/service/http_service.dart';
import 'package:flutter/foundation.dart';

import '../../../model/article.dart';

class HomeViewModel extends ChangeNotifier {
  List<Articles> newsList = [];
  List<Articles>? favoriteNewsList = [];
  int pageCount = 1;
  bool? isLoading = false;
  TextEditingController? searchController = TextEditingController();
  String? category = "";

  Future<void> getNewList() async {
    isLoading = true;
    newsList = await HttpService.instance.getNews(
        category: category == "" ? "haber" : category,
        pageCount: pageCount.toString());

    print(newsList.length);
    isLoading = false;

    for (var article in favoriteNewsList!) {
      if (favoriteNewsList!.contains(article)) {
        article.isFavorite = true;
      }
    }

    notifyListeners();
  }

  pageCountPlus() async {
    pageCount++;
    await getNewList();
    print(pageCount);
    notifyListeners();
  }

  pageCountMinus() async {
    if (pageCount != 1) pageCount--;
    await getNewList();
    print(pageCount);
    notifyListeners();
  }

  addToFavorite(Articles article) async {
    if (!favoriteNewsList!.contains(article)) {
      favoriteNewsList!.add(article);
      article.isFavorite = true;

      notifyListeners();
    }
  }

  removeFromFavorite(Articles article) {
    favoriteNewsList!.remove(article);
    article.isFavorite = false;
    notifyListeners();
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Articles>? favoriteNewsList;

  const FavoritesPage({super.key, required this.favoriteNewsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Sayfadan çıkış yaparak geri dön
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: favoriteNewsList!.isEmpty
            ? const Text('Henüz favori haber yok.')
            : ListView.builder(
                itemCount: favoriteNewsList!.length,
                itemBuilder: (context, index) {
                  final article = favoriteNewsList![index];
                  return ListTile(
                    title: Text(article.title!),
                  );
                },
              ),
      ),
    );
  }
}
