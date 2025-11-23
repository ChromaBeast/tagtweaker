import 'package:flutter/material.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';

import '../../../models/searched_product_model.dart';
import '../../../themes/colors.dart';
import '../../../widgets/functions/share_individual.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 72,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildSearchTextField(colorScheme),
                ),
              ),
            ];
          },
          body: _buildProductList(colorScheme),
        ),
      ),
    );
  }

  Widget _buildSearchTextField(ColorScheme colorScheme) {
    return SearchBar(
      controller: searchController,
      hintText: 'Search Products',
      hintStyle: WidgetStateProperty.all(
        Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      leading: Icon(
        Icons.search_rounded,
        color: colorScheme.primary,
      ),
      trailing: searchController.text.isNotEmpty
          ? [
              IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    searchController.clear();
                    SearchedProduct.products = [];
                  });
                },
              ),
            ]
          : null,
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(
        colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      side: WidgetStateProperty.all(
        BorderSide(color: colorScheme.outline.withOpacity(0.3)),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      onChanged: (query) {
        setState(() {
          if (query.isEmpty) {
            SearchedProduct.products = [];
          } else {
            SearchedProduct searchedProduct = SearchedProduct();
            searchedProduct.search(query);
          }
        });
      },
    );
  }

  Widget _buildProductList(ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    if (SearchedProduct.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 80,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for products',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find what you\'re looking for',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      interactive: true,
      radius: const Radius.circular(16.0),
      thickness: 4.0,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: SearchedProduct.products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(index, colorScheme, textTheme);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.65,
        ),
      ),
    );
  }

  Widget _buildProductCard(
      int index, ColorScheme colorScheme, TextTheme textTheme) {
    final product = SearchedProduct.products[index];

    return Card(
      elevation: 0,
      // color: colorScheme.surfaceContainerHighest, // Use theme default (glassmorphic)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(product: product),
              ),
            );
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: product['thumbnail'],
                      child: Image.network(
                        product['thumbnail'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Product Title
              Text(
                product['title'],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Brand
              Text(
                "By: ${product['brand']}",
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              // Rating and Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: ratingColors[product['rating'].toInt()],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product['rating'].toStringAsFixed(1),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Text(
                    '\$${product['price']}',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Share Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    genPDF(context, product);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share_rounded,
                        size: 16,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Share',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
