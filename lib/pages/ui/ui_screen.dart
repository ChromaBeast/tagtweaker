import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:tag_tweaker/pages/ui/core/home_page.dart';
import 'package:tag_tweaker/pages/ui/core/search_page.dart';
import 'package:tag_tweaker/pages/ui/core/favourites_page.dart';
import 'package:tag_tweaker/app/controllers/navigation_controller.dart';

class UIPage extends StatelessWidget {
  final int selectedIndex;
  const UIPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure the NavigationController is available
    final NavigationController navCtrl = Get.find<NavigationController>();
    // Set the initial selected index
    navCtrl.selectedIndex.value = selectedIndex;

    const List<Widget> _widgetOptions = [
      HomePage(),
      SearchPage(),
      FavouritesPage(),
    ];

    return Scaffold(
      body: Obx(() => _widgetOptions.elementAt(navCtrl.selectedIndex.value)),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.titled,
        backgroundColor: Colors.black,
        color: Colors.grey.shade400,
        activeColor: Colors.white,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.favorite, title: 'Favourites'),
        ],
        initialActiveIndex: selectedIndex,
        onTap: (index) => navCtrl.changeTab(index),
      ),
    );
  }
}
