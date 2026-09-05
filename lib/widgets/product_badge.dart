import 'package:flutter/material.dart';
import '../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal badge widget (e.g. NEW, BEST SELLER)
class ProductBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final double angle;

  const ProductBadge({
    super.key,
    required this.text,
    required this.color,
    required this.shadowColor,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: NeoBrutalColors.black, width: 2),
          boxShadow: [
            BoxShadow(color: shadowColor, offset: const Offset(2, 2)),
          ],
        ),
        child: Text(
          text,
          style: NeoBrutalTheme.heading.copyWith(
            color: NeoBrutalColors.black,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
