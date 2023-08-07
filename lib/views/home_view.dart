import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/views/web_view.dart';

import '../riverpod_manager.dart';
import '../widgets/wrapper/statefull_wrapper.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HABERLER",
          style: TextStyle(
            fontSize: 22, // Yazı boyutunu 24 olarak ayarladık
            fontWeight: FontWeight.normal, // Yazıyı kalın hale getirdik
            color: Color.fromARGB(255, 90, 144, 177),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StatefulWrapper(
        onInit: () async {
          await viewModel.getNewList();
        },
        child: SafeArea(
          child: FutureBuilder<void>(builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print("Hata Mesajı: ${snapshot.error}");
              return const Center(
                  child: Text("Haberler yüklenirken bir hata oluştu."));
            } else {
              return Column(children: [
                (viewModel.newsList?.isEmpty ?? false)
                    ? const Center(child: Text("Haber yok"))
                    : Expanded(
                        child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image.network(
                                        viewModel.newsList?[index].urlToImage ??
                                            ""),
                                    title: Text(
                                        viewModel.newsList?[index].title ?? ""),
                                    subtitle: Text(
                                        viewModel.newsList?[index].title ?? ""),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyWebView(
                                            news: viewModel.newsList![index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: viewModel.pageCountMinus,
                        icon: const Icon(Icons.arrow_back)),
                    Text(viewModel.pageCount.toString()),
                    IconButton(
                        onPressed: viewModel.pageCountPlus,
                        icon: const Icon(Icons.arrow_forward)),
                  ],
                )
              ]);
            }
          }),
        ),
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  ArticleSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Search articles';

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
    // Implement the logic to show the search results based on the query.
    // You can use the `query` property to get the search query.
    final viewModel = ref.read(homeViewModelProvider);
    final searchResults = viewModel.newsList
        ?.where((article) =>
            article.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    return searchResults?.isEmpty ?? true
        ? const Center(child: Text("No results found."))
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
    // Implement the logic to show search suggestions while typing.
    // You can use the `query` property to get the search query.
    return Container();
  }
}
