import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/pages/ui/quotations_page.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/common/app_background.dart';
import 'package:tag_tweaker/widgets/favourites/empty_favourites_view.dart';
import 'package:tag_tweaker/widgets/favourites/favourite_product_card.dart';
import 'package:tag_tweaker/widgets/favourites/pricing_rules_sheet.dart';
import 'package:tag_tweaker/widgets/favourites/quote_summary_bar.dart';
import 'package:tag_tweaker/widgets/favourites/remove_favourite_dialog.dart';

/// Favourites page: the quote being built. Shows saved products with
/// editable prices, live totals under the current pricing rules, and the
/// "create quote" action that saves to history and exports a PDF.
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavouritesController>();
    final auth = FirebaseAuth.instance;

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
                  _buildHeader(context, controller),
                  StreamBuilder<List<Product>>(
                    stream: controller.watchFavourites(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: NeoBrutalColors.black,
                          ),
                        );
                      }

                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final products = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.all(24),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return FavouriteProductCard(
                                  item: product,
                                  auth: auth,
                                  onTap: () => Get.to(
                                    () => ProductPage(product: product),
                                  ),
                                  onRemove: () => RemoveFavouriteDialog.show(
                                    context,
                                    onConfirm: () {
                                      controller.toggleFavourite(product);
                                    },
                                  ),
                                );
                              },
                            ),
                            Obx(
                              () => QuoteSummaryBar(
                                itemCount: products.length,
                                totals: controller.quoteTotals(products),
                              ),
                            ),
                          ],
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
          icon: const Icon(Icons.request_quote, color: NeoBrutalColors.white),
          label: Text(
            'CREATE QUOTE',
            style: NeoBrutalTheme.heading.copyWith(
              color: NeoBrutalColors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FavouritesController controller) {
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
              fontSize: 28,
              shadows: const [
                Shadow(offset: Offset(2, 2), color: NeoBrutalColors.lime),
              ],
            ),
          ),
          Row(
            children: [
              _HeaderAction(
                key: const Key('openPricingRules'),
                icon: Icons.tune,
                tooltip: 'Pricing rules',
                color: NeoBrutalColors.lime,
                onTap: () async {
                  final rules = await PricingRulesSheet.show(
                    context,
                    controller.pricingRules.value,
                  );
                  if (rules != null) await controller.updatePricingRules(rules);
                },
              ),
              const SizedBox(width: 12),
              _HeaderAction(
                key: const Key('openQuotations'),
                icon: Icons.history,
                tooltip: 'Quotation history',
                color: NeoBrutalColors.white,
                onTap: () => Get.to(() => const QuotationsPage()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _HeaderAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: NeoBrutalTheme.brutalBox(
            color: color,
            borderColor: NeoBrutalColors.black,
            borderWidth: 2,
            shadowColor: NeoBrutalColors.black,
            shadowOffset: 3,
          ),
          child: Icon(icon, color: NeoBrutalColors.black),
        ),
      ),
    );
  }
}
