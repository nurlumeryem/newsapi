import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/model/article.dart';
import 'package:newsapi/pages/web_view/web_view.dart';
import 'package:newsapi/widgets/wrapper/statefull_wrapper.dart';

import '../../../riverpod_manager.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int? selectItem;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeViewModelProvider);
    final favoriteNewsList = viewModel.favoriteNewsList;
    final newsList = viewModel.newsList;
    final pageCount = viewModel.pageCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Haberler"),
        actions: [
          Center(child: Text("(${viewModel.favoriteNewsList!.length})")),
          IconButton(
            onPressed: () {
              if (selectItem != null) {
                // Burada favori listesindeki indexi bulun
                if (favoriteNewsList?.contains(newsList[selectItem!]) ??
                    false) {
                  viewModel.removeFromFavorite(newsList[selectItem!]);
                } else {
                  viewModel.addToFavorite(newsList[selectItem!]);
                }
              }
              print("favorite length ${favoriteNewsList!.length}");
            },
            icon: selectItem != null &&
                    (favoriteNewsList?.contains(newsList[selectItem!]) ?? false)
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border_outlined),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: StatefulWrapper(
          onInit: () async {
            await viewModel.getNewList();
            viewModel.searchController?.clear();
          },
          child: (viewModel.isLoading ?? false)
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    TextField(controller: viewModel.searchController),
                    ElevatedButton(
                      onPressed: () async {
                        viewModel.category = viewModel.searchController?.text;
                        FocusScope.of(context).unfocus();
                        viewModel.pageCount = 1;
                        await viewModel.getNewList();
                      },
                      child: const Text("Ara"),
                    ),
                    if (newsList.isEmpty ?? false)
                      Expanded(child: Center(child: Text("Haber yok")))
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: newsList.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //if()
                                  setState(() {
                                    selectItem = index;
                                    print('secilen item $index');
                                  });
                                },
                                onDoubleTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyWebView(
                                        news: newsList?[index] ?? Articles(),
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Image.network(
                                      newsList[index].urlToImage ??
                                          "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                                      height: 50,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(newsList[index].title ?? ""),
                                          Text(newsList[index].description ??
                                              ""),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (pageCount != 1)
                          IconButton(
                            onPressed: viewModel.pageCountMinus,
                            icon: const Icon(Icons.arrow_back),
                          ),
                        Text(pageCount.toString()),
                        if (!(newsList?.isEmpty ?? true))
                          IconButton(
                            onPressed: viewModel.pageCountPlus,
                            icon: const Icon(Icons.arrow_forward),
                          ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
