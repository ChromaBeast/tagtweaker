import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/widgets/favourites/favourite_product_card.dart';

import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/grid_painter.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(FavouritesController());
    
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          // Grid Pattern
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://www.transparenttextures.com/patterns/carbon-fibre.png",
                ),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: CustomPaint(painter: GridPainter(), child: Container()),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, colorScheme),

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
                            final data =
                                docs[index].data() as Map<String, dynamic>;
                            return _buildFavouriteCard(
                              context,
                              data,
                              auth,
                              colorScheme,
                              index,
                            );
                          },
                        );
                      }

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: NeoBrutalColors.black, width: 2),
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

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
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
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: NeoBrutalTheme.brutalBox(
                    color: NeoBrutalColors.white,
                    borderColor: NeoBrutalColors.black,
                    shadowColor: NeoBrutalColors.black,
                    shadowOffset: 4,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: NeoBrutalColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'YOUR\nFAVOURITES',
                style: NeoBrutalTheme.heading.copyWith(
                  fontSize: 24,
                  height: 0.9,
                  shadows: [
                    const Shadow(
                      offset: Offset(2, 2),
                      color: NeoBrutalColors.lime,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavouriteCard(
    BuildContext context,
    Map<String, dynamic> item,
    FirebaseAuth auth,
    ColorScheme colorScheme,
    int index,
  ) {
    return FavouriteProductCard(
      item: item,
      auth: auth,
      onTap: () => goToProductPage(context, item),
      onRemove: () => _showRemoveDialog(context, item, auth, colorScheme),
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    Map<String, dynamic> item,
    FirebaseAuth auth,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(auth.currentUser?.uid)
                          .collection('favourites')
                          .doc(item['id'].toString())
                          .delete();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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
      ),
    );
  }

  void goToProductPage(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductPage(product: item)),
    );
  }
}
