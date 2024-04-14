import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/pages/ui/favourites_page.dart';
import 'package:tag_tweaker/pages/ui/home_page.dart';
import 'package:tag_tweaker/pages/ui/pdf_gen_page.dart';
import 'package:tag_tweaker/pages/ui/search_page.dart';

class UIPage extends StatefulWidget {
  const UIPage({super.key});
  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  int _selectedIndex = 0;
  List<Product> products = [];
  List<Product> favProducts = [];
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const SearchPage(),
    const FavouritesPage(),
    const PDFGenPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: GNav(
        haptic: true,
        curve: Curves.fastEaseInToSlowEaseOut,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        backgroundColor: Colors.black,
        gap: 8,
        activeColor: Colors.white,
        iconSize: 24,
        rippleColor: Colors.transparent,
        padding: const EdgeInsets.all(12),
        tabMargin: const EdgeInsets.all(12),
        tabBackgroundColor: Colors.grey.shade900,
        textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        color: Colors.white,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.favorite,
            text: 'Favourites',
          ),
          GButton(
            icon: Icons.picture_as_pdf,
            text: 'PDF',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
