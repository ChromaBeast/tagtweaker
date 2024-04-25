import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/pages/ui/favourites_page.dart';
import 'package:tag_tweaker/pages/ui/home_page.dart';
import 'package:tag_tweaker/pages/ui/pdf_gen_page.dart';
import 'package:tag_tweaker/pages/ui/search_page.dart';

import '../../blocs/navigation_bloc.dart';

class UIPage extends StatefulWidget {
  const UIPage({super.key});

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  final int _selectedIndex = 0;
  List<Product> products = [];
  List<Product> favProducts = [];
  final List _widgetOptions = [
    const HomePage(),
    const SearchPage(),
    const FavouritesPage(),
    const PDFGenPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return _widgetOptions.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.titled, // Choose a curved style
        backgroundColor: Colors.black, // Background color
        color: Colors.grey.shade400, // Inactive color
        activeColor: Colors.white,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.favorite, title: 'Favourites'),
          TabItem(icon: Icons.picture_as_pdf, title: 'PDF'),
        ],
        initialActiveIndex: _selectedIndex, // Set initial index
        onTap: (index) =>
            BlocProvider.of<NavigationBloc>(context).add(TabTapped(index)),
      ),
    );
  }
}
