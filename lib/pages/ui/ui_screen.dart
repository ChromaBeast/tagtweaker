import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/navigation_controller.dart';
import 'package:tag_tweaker/pages/ui/core/favourites_page.dart';
import 'package:tag_tweaker/pages/ui/core/home_page.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

class UIPage extends StatelessWidget {
  final int selectedIndex;
  const UIPage({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not found (failsafe) or find existing
    final NavigationController navCtrl = Get.put(NavigationController());

    // Set initial index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navCtrl.selectedIndex.value = selectedIndex;
    });

    final List<Widget> pages = [const HomePage(), const FavouritesPage()];

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          // Content
          Obx(() => pages[navCtrl.selectedIndex.value]),

          // Fixed Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                color: NeoBrutalColors.black,
                border: Border(
                  top: BorderSide(color: NeoBrutalColors.white, width: 4),
                ),
              ),
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.home,
                    label: "HOME",
                    index: 0,
                    controller: navCtrl,
                  ),
                  // Vertical Divider
                  Container(width: 4, color: NeoBrutalColors.white),
                  _NavItem(
                    icon: Icons.favorite,
                    label: "FAVOURITES",
                    index: 1,
                    controller: navCtrl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final NavigationController controller;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final bool isSelected = controller.selectedIndex.value == index;
        return GestureDetector(
          onTap: () => controller.changeTab(index),
          child: Container(
            color: isSelected ? NeoBrutalColors.lime : NeoBrutalColors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? NeoBrutalColors.black
                      : NeoBrutalColors.white,
                  size: 32,
                ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 12,
                      color: NeoBrutalColors.black,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
