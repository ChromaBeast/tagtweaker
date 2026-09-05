import 'package:flutter/material.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

/// A reusable neo-brutalist styled button with icon support.
///
/// Supports both asset icons and icon data, with customizable colors
/// for background, text, and shadow.
class NeoBrutalButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String? icon;
  final IconData? iconData;
  final bool isAssetIcon;
  final Color bgColor;
  final Color textColor;
  final Color shadowColor;
  final double shadowOffset;
  final double borderWidth;

  const NeoBrutalButton({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
    this.iconData,
    this.isAssetIcon = false,
    required this.bgColor,
    required this.textColor,
    this.shadowColor = NeoBrutalColors.black,
    this.shadowOffset = 4,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: NeoBrutalTheme.brutalBox(
          color: bgColor,
          borderColor: NeoBrutalColors.black,
          shadowColor: shadowColor,
          shadowOffset: shadowOffset,
          borderWidth: borderWidth,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isAssetIcon && icon != null)
              Image.asset(icon!, height: 24)
            else if (iconData != null)
              Icon(iconData, color: textColor, size: 24),
            if (icon != null || iconData != null) const SizedBox(width: 12),
            Text(
              text.toUpperCase(),
              style: NeoBrutalTheme.heading.copyWith(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
