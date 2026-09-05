import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal action button used for product actions (Save, Share, etc.)
class NeoActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color shadowColor;
  final VoidCallback onTap;

  const NeoActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: NeoBrutalTheme.brutalBox(
          color: bgColor,
          borderColor: NeoBrutalColors.black,
          shadowColor: shadowColor,
          shadowOffset: 6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: NeoBrutalTheme.heading.copyWith(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
