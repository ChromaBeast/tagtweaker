import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import '../functions/share_individual.dart';
import 'favourite_price_input.dart';

/// Card representing a favourite item with customizable price and actions
class FavouriteProductCard extends StatelessWidget {
  final Product item;
  final FirebaseAuth auth;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FavouriteProductCard({
    super.key,
    required this.item,
    required this.auth,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.darkGrey,
        shadowColor: NeoBrutalColors.lime,
        shadowOffset: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                color: NeoBrutalColors.white,
                border: Border(
                  bottom: BorderSide(color: NeoBrutalColors.white, width: 4),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: CustomNetworkImage(
                item.thumbnail,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Container(
            color: NeoBrutalColors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    item.title,
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 16,
                      height: 1.1,
                      color: NeoBrutalColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),

                // Price Input and Actions
                Row(
                  children: [
                    Expanded(
                      child: FavouritePriceInput(item: item),
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      color: NeoBrutalColors.orange,
                      onTap: onRemove,
                      tooltip: 'Remove',
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      color: NeoBrutalColors.lime,
                      onTap: () => genPDF(context, item),
                      tooltip: 'Share',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: NeoBrutalColors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: NeoBrutalColors.black, offset: Offset(2, 2)),
          ],
        ),
        child: Icon(icon, color: NeoBrutalColors.black, size: 24),
      ),
    );
  }
}
