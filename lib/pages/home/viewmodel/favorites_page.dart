import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/article.dart';

class FavoritesPage extends StatelessWidget {
  final List<Articles>? favoriteNewsList;
  const FavoritesPage({super.key, required this.favoriteNewsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
      ),
      body: Center(
        child: favoriteNewsList!.isEmpty
            ? const Text('Henüz favori haber yok.')
            : ListView.builder(
                itemCount: favoriteNewsList!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(favoriteNewsList![index].title!),
                    // Diğer özellikler...
                  );
                },
              ),
      ),
    );
  }
}
