import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/pages/ui/core/home_page.dart';
import 'package:tag_tweaker/pages/ui/core/search_page.dart';
import 'package:tag_tweaker/pages/ui/core/favourites_page.dart';
import 'package:tag_tweaker/controllers/navigation_controller.dart';
import 'package:tag_tweaker/widgets/background_container.dart';

class UIPage extends StatelessWidget {
  final int selectedIndex;
  const UIPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController navCtrl = Get.find<NavigationController>();
    navCtrl.selectedIndex.value = selectedIndex;

    const List<Widget> widgetOptions = [
      HomePage(),
      SearchPage(),
      FavouritesPage(),
    ];

    return BackgroundContainer(
      withGlow: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Main content
            Obx(() => widgetOptions.elementAt(navCtrl.selectedIndex.value)),

            // Floating navbar
            Positioned(
              left: 32,
              right: 32,
              bottom: 24,
              child: Obx(
                () => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        context,
                        navCtrl,
                        0,
                        Icons.home_outlined,
                        Icons.home_rounded,
                        'Home',
                      ),
                      _buildNavItem(
                        context,
                        navCtrl,
                        1,
                        Icons.search_outlined,
                        Icons.search_rounded,
                        'Search',
                      ),
                      _buildNavItem(
                        context,
                        navCtrl,
                        2,
                        Icons.favorite_outline_rounded,
                        Icons.favorite_rounded,
                        'Favourites',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavigationController navCtrl,
    int index,
    IconData icon,
    IconData selectedIcon,
    String label,
  ) {
    final isSelected = navCtrl.selectedIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () => navCtrl.changeTab(index),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.white : const Color(0xFF757575),
            size: 28,
          ),
        ),
      ),
    );
  }
}
