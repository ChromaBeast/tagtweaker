import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal empty state view when no favourites are present
class EmptyFavouritesView extends StatelessWidget {
  const EmptyFavouritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: NeoBrutalTheme.brutalBox(
          color: NeoBrutalColors.white,
          borderColor: NeoBrutalColors.black,
          shadowColor: NeoBrutalColors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 64,
              color: NeoBrutalColors.mediumGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'NO FAVOURITES YET',
              style: NeoBrutalTheme.heading.copyWith(
                color: NeoBrutalColors.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ADD PRODUCTS TO YOUR FAVOURITES TO SEE THEM HERE',
              style: NeoBrutalTheme.mono.copyWith(
                color: NeoBrutalColors.mediumGrey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
