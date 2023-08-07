import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:newsapi/widgets/wrapper/statefull_wrapper.dart';

import '../model/news.dart';
import '../riverpod_manager.dart';
import 'home_view.dart';
import 'web_view.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);
    List<News>? searchFavorites(String query) {
      if (query.isEmpty) {
        return viewModel.favoriteList
            ?.map((article) => News(
                  title: article.title,
                  description: article.description,
                  urlToImage: article.urlToImage,
                ))
            .toList();
      } else {
        return viewModel.favoriteList
            ?.where((article) =>
                article.title?.toLowerCase().contains(query.toLowerCase()) ??
                false ||
                    article.description!
                        .toLowerCase()
                        .contains(query.toLowerCase()))
            .map((article) => News(
                  title: article.title,
                  description: article.description,
                  urlToImage: article.urlToImage,
                ))
            .toList();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAVORİLER',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 249, 253, 255),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(
                  context: context, delegate: ArticleSearchDelegate(ref));
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 238, 242, 244),
      body: StatefulWrapper(
        onInit: () async {
          await viewModel.sharredLoad();
        },
        child: Center(
          child: viewModel.favoriteList?.isEmpty ?? false
              ? const Text('Henüz favori haber yok.')
              : ListView.builder(
                  itemCount: viewModel.favoriteList?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: IconButton(
                          onPressed: () async {
                            viewModel.removeFromList(
                                viewModel.favoriteList ?? [], index);
                            await viewModel.sharredSave();
                          },
                          icon: const Icon(Icons.delete)),
                      leading: Image.network(
                          viewModel.favoriteList?[index].urlToImage ?? ""),
                      title: Text(viewModel.favoriteList?[index].title ?? ""),
                      subtitle:
                          Text(viewModel.favoriteList?[index].title ?? ""),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyWebView(
                              news: viewModel.favoriteList![index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
