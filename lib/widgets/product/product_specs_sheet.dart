import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal specs sheet widget for product details
class ProductSpecsSheet extends StatelessWidget {
  final String description;

  const ProductSpecsSheet({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.lime,
        borderColor: NeoBrutalColors.white,
        shadowColor: NeoBrutalColors.white,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: NeoBrutalColors.black, width: 4),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.black,
                    border: Border.all(color: NeoBrutalColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: NeoBrutalColors.lime,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "SPECS SHEET",
                  style: NeoBrutalTheme.heading.copyWith(
                    color: NeoBrutalColors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: NeoBrutalTheme.mono.copyWith(
              color: NeoBrutalColors.black,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
