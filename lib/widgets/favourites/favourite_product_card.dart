import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../functions/share_individual.dart';
import '../../widgets/custom_network_image.dart';

class FavouriteProductCard extends StatelessWidget {
  final Map<String, dynamic> item;
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomNetworkImage(
                  item['thumbnail'],
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              // Product Title
              Text(
                item['title'],
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Price Input and Actions Row
              Row(
                children: [
                  // Price Input
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(auth.currentUser?.uid)
                                    .collection('favourites')
                                    .doc(item['id'].toString())
                                    .update({'price': value});
                              },
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                hintText: item['price'].toString(),
                                hintStyle: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '\$',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Action Buttons
                  IconButton.filled(
                    onPressed: onRemove,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.favoriteColor.withOpacity(0.2),
                    ),
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: AppColors.favoriteColor,
                    ),
                    tooltip: 'Remove from Favourites',
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => genPDF(context, item),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.shareColor.withOpacity(0.2),
                    ),
                    icon: Icon(
                      Icons.share_rounded,
                      color: AppColors.shareColor,
                    ),
                    tooltip: 'Share Product',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
