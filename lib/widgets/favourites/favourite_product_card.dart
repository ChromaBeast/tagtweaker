import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import '../functions/share_individual.dart';

class FavouriteProductCard extends StatefulWidget {
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
  State<FavouriteProductCard> createState() => _FavouriteProductCardState();
}

class _FavouriteProductCardState extends State<FavouriteProductCard> {
  late TextEditingController _priceController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<FavouritesController>();
    final productId = widget.item.id;
    final price = controller.getPrice(
      productId,
      widget.item.price.toStringAsFixed(0),
    );

    _priceController = TextEditingController(
      text: (price.isNotEmpty) ? price : '0',
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _priceController.dispose();
    super.dispose();
  }

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
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: NeoBrutalColors.white,
              border: Border(
                bottom: BorderSide(color: NeoBrutalColors.white, width: 4),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: CustomNetworkImage(
              widget.item.thumbnail,
              fit: BoxFit.contain,
            ),
          ),

          Container(
            color: NeoBrutalColors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: NeoBrutalTheme.heading.copyWith(
                    fontSize: 16,
                    height: 1.1,
                    color: NeoBrutalColors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Price Input and Actions
                Row(
                  children: [
                    // Price Input
                    Expanded(
                      child: Container(
                        // height: 48, // Removed fixed height to avoid clipping
                        constraints: const BoxConstraints(minHeight: 48),
                        decoration: BoxDecoration(
                          color: NeoBrutalColors.white,
                          border: Border.all(
                            color: NeoBrutalColors.black,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: NeoBrutalColors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12, // Added vertical padding
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: NeoBrutalColors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '₹',
                                style: NeoBrutalTheme.heading.copyWith(
                                  fontSize: 14,
                                  color: NeoBrutalColors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _priceController,
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) {
                                    _debounce!.cancel();
                                  }
                                  _debounce = Timer(
                                    const Duration(milliseconds: 500),
                                    () {
                                      Get.find<FavouritesController>()
                                          .updatePrice(widget.item.id, value);
                                    },
                                  );
                                },
                                style: NeoBrutalTheme.mono.copyWith(
                                  fontSize: 14,
                                  color: NeoBrutalColors.black,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  hintText: widget.item.price.toStringAsFixed(
                                    0,
                                  ),
                                  hintStyle: NeoBrutalTheme.mono.copyWith(
                                    fontSize: 14,
                                    color: NeoBrutalColors.mediumGrey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Remove Button
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      color: NeoBrutalColors.orange,
                      onTap: widget.onRemove,
                      tooltip: 'Remove',
                    ),
                    const SizedBox(width: 8),

                    // Share Button
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      color: NeoBrutalColors.lime,
                      onTap: () => genPDF(context, widget.item.toMap()),
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
