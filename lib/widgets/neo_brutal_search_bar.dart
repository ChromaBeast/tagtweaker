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
    this.hasBorder = true,
  });

  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: hasBorder
          ? NeoBrutalTheme.brutalBox(
              color: NeoBrutalColors.darkGrey,
              shadowColor: NeoBrutalColors.white,
            )
          : null,
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
                color: hasBorder
                    ? NeoBrutalColors.white
                    : NeoBrutalColors.black,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                hintText: hintText,
                hintStyle: NeoBrutalTheme.mono.copyWith(
                  color: hasBorder ? Colors.grey : NeoBrutalColors.mediumGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isRotated) {
      return Transform.rotate(angle: -0.02, child: searchBar);
    }

    return searchBar;
  }
}
