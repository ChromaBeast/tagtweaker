import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/pages/ui/core/home_page.dart';
import 'package:tag_tweaker/pages/ui/core/search_page.dart';
import 'package:tag_tweaker/pages/ui/core/favourites_page.dart';
import 'package:tag_tweaker/app/controllers/navigation_controller.dart';

class UIPage extends StatelessWidget {
  final int selectedIndex;
  const UIPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController navCtrl = Get.find<NavigationController>();
    navCtrl.selectedIndex.value = selectedIndex;
    final colorScheme = Theme.of(context).colorScheme;

    const List<Widget> widgetOptions = [
      HomePage(),
      SearchPage(),
      FavouritesPage(),
    ];

    return Scaffold(
      body: Obx(() => widgetOptions.elementAt(navCtrl.selectedIndex.value)),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          elevation: 3,
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.surfaceTint,
          indicatorColor: colorScheme.primaryContainer,
          selectedIndex: navCtrl.selectedIndex.value,
          onDestinationSelected: (index) => navCtrl.changeTab(index),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 500),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.search_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_outline_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
              label: 'Favourites',
            ),
          ],
        ),
      ),
    );
  }
}
