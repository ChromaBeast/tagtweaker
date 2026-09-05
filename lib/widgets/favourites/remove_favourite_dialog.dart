import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal dialog confirming product removal from favourites
class RemoveFavouriteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const RemoveFavouriteDialog({super.key, required this.onConfirm});

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      builder: (context) => RemoveFavouriteDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: NeoBrutalTheme.brutalBox(
          color: NeoBrutalColors.white,
          borderColor: NeoBrutalColors.black,
          shadowColor: NeoBrutalColors.black,
          shadowOffset: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'REMOVE ITEM?',
              style: NeoBrutalTheme.heading.copyWith(
                fontSize: 20,
                color: NeoBrutalColors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to remove this item from your favourites?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: NeoBrutalTheme.brutalBox(
                      color: NeoBrutalColors.white,
                      borderColor: NeoBrutalColors.black,
                      shadowColor: NeoBrutalColors.black,
                      shadowOffset: 2,
                    ),
                    child: Text(
                      'CANCEL',
                      style: NeoBrutalTheme.heading.copyWith(
                        fontSize: 14,
                        color: NeoBrutalColors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: NeoBrutalTheme.brutalBox(
                      color: NeoBrutalColors.orange,
                      borderColor: NeoBrutalColors.black,
                      shadowColor: NeoBrutalColors.black,
                      shadowOffset: 2,
                    ),
                    child: Text(
                      'REMOVE',
                      style: NeoBrutalTheme.heading.copyWith(
                        fontSize: 14,
                        color: NeoBrutalColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
