import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/pages/ui/core/favourites_page.dart';
import 'package:tag_tweaker/pages/ui/core/home_page.dart';
import 'package:tag_tweaker/pages/ui/core/search_page.dart';

import '../../blocs/navigation_bloc.dart';

class UIPage extends StatelessWidget {
  final int selectedIndex;

  UIPage({super.key, required this.selectedIndex});

  final List<Product> products = [];

  final List<Product> favProducts = [];

  final List _widgetOptions = [
    const HomePage(),
    const SearchPage(),
    const FavouritesPage(),
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
        ],
        initialActiveIndex: selectedIndex, // Set initial index
        onTap: (index) =>
            BlocProvider.of<NavigationBloc>(context).add(TabTapped(index)),
      ),
    );
  }
}
