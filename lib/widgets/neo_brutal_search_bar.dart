import 'package:flutter/material.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

class NeoBrutalSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool isRotated;

  const NeoBrutalSearchBar({
    super.key,
    this.controller,
    this.hintText = 'SEARCH...',
    this.onChanged,
    this.isRotated = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.darkGrey,
        shadowColor: NeoBrutalColors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: NeoBrutalColors.lime, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: NeoBrutalColors.lime,
              style: NeoBrutalTheme.mono.copyWith(
                color: NeoBrutalColors.white,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: NeoBrutalTheme.mono.copyWith(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );

    if (isRotated) {
      return Transform.rotate(
        angle: -0.02, 
        child: searchBar,
      );
    }

    return searchBar;
  }
}
