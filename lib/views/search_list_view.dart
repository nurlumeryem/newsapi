import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/views/web_view.dart';

import '../riverpod_manager.dart';

class ArticleSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  ArticleSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Haber ara';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final viewModel = ref.read(homeViewModelProvider);
    final searchResults = viewModel.favoriteList
        ?.where((article) =>
            article.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    return searchResults?.isEmpty ?? true
        ? const Center(child: Text("Haber bulunamadı."))
        : ListView.builder(
            itemCount: searchResults?.length ?? 0,
            itemBuilder: (context, index) {
              final article = searchResults![index];
              return Column(
                children: [
                  ListTile(
                    leading: Image.network(article.urlToImage ??
                        "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"),
                    title: Text(article.title ?? ""),
                    subtitle: Text(article.title ?? ""),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyWebView(
                            news: article,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}
