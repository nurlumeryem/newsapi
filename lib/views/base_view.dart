import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../riverpod_manager.dart';

class BaseView extends ConsumerWidget {
  const BaseView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
        bottomNavigationBar: GNav(
          selectedIndex: viewModel.currentPageCount,
          onTabChange: viewModel.changePage,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          color: const Color.fromARGB(255, 53, 49, 49),
          activeColor: Colors.white,
          tabBackgroundColor: Colors.blueGrey,
          gap: 5,
          padding: const EdgeInsets.all(16),
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Anasayfa',
              onPressed: () {},
            ),
            GButton(
              icon: Icons.favorite_border,
              text: 'Favoriler',
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 249, 252, 252),
        body: viewModel.currentPage[viewModel.currentPageCount]);
  }
}
