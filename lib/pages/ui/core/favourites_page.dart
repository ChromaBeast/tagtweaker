import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/common/app_background.dart';
import 'package:tag_tweaker/widgets/favourites/empty_favourites_view.dart';
import 'package:tag_tweaker/widgets/favourites/favourite_product_card.dart';
import 'package:tag_tweaker/widgets/favourites/remove_favourite_dialog.dart';

/// Favourites page displaying saved user products and PDF export action
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavouritesController>();
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('users')
                        .doc(auth.currentUser?.uid)
                        .collection('favourites')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: NeoBrutalColors.black,
                          ),
                        );
                      }

                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                          padding: const EdgeInsets.all(24),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final product = Product.fromSnapshot(docs[index]);
                            return FavouriteProductCard(
                              item: product,
                              auth: auth,
                              onTap: () => Get.to(() => ProductPage(product: product)),
                              onRemove: () => RemoveFavouriteDialog.show(
                                context,
                                onConfirm: () {
                                  controller.toggleFavourite(product);
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const EmptyFavouritesView();
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () => controller.generatePDF(context),
          backgroundColor: NeoBrutalColors.purple,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: NeoBrutalColors.black, width: 2),
          ),
          icon: const Icon(Icons.picture_as_pdf, color: NeoBrutalColors.white),
          label: Text(
            'EXPORT PDF',
            style: NeoBrutalTheme.heading.copyWith(
              color: NeoBrutalColors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: NeoBrutalColors.background,
        border: Border(
          bottom: BorderSide(color: NeoBrutalColors.white, width: 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'YOUR\nFAVOURITES',
            style: NeoBrutalTheme.heading.copyWith(
              fontSize: 32,
              shadows: const [
                Shadow(offset: Offset(2, 2), color: NeoBrutalColors.lime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
