import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapi/views/home_view.dart';
import 'package:newsapi/views/favorites_page.dart';
import 'package:newsapi/service/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/article.dart';

class HomeViewModel extends ChangeNotifier {
  List<Articles>? newsList = [];
  int pageCount = 1;
  bool? isLoading = false;
  int currentPageCount = 0;
  List<Articles>? favoriteList = [];

  List<Widget> currentPage = [
    const HomeView(),
    const FavoritesPage(),
  ];

  Future<void> sharredSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var encodedList = favoriteList?.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList("favoriteList", encodedList ?? []);
  }

  Future<List<Articles>?> sharredLoad() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("favoriteList");
    favoriteList = list?.isNotEmpty ?? false
        ? list?.map((e) => Articles.fromJson(jsonDecode(e))).toList()
        : [];
    notifyListeners();
    return favoriteList;
  }

  removeFromList(List<Articles> list, int index) {
    list.removeAt(index);
    notifyListeners();
  }

  changePage(int pageIndex) {
    currentPageCount = pageIndex;
    notifyListeners();
  }

  // SİLME İŞLEMİ İÇİN ÖNCE LİSTEDEN SİLECEKSİN. SONRA SHARREDSAVE FONKSİYONUNU ÇAĞIRACAKSIN.

  getNewList({String? category}) async {
    isLoading = true;
    newsList = await HttpService.instance.getNews(
        category: category ?? "haber", pageCount: pageCount.toString());
    isLoading = false;

    notifyListeners();
  }

  pageCountPlus() async {
    pageCount++;
    await getNewList();
    notifyListeners();
  }

  pageCountMinus() async {
    if (pageCount != 1) pageCount--;
    await getNewList();
    notifyListeners();
  }
}
