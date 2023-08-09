// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapi/views/search_list_view.dart';
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
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "HABERLER",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArticleSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
