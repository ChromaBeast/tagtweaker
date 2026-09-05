import 'package:flutter/material.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

/// A styled divider with text in the middle (typically "OR").
///
/// Used to separate different sections or options in forms.
class OrDivider extends StatelessWidget {
  final String text;
  final Color lineColor;
  final double thickness;

  const OrDivider({
    super.key,
    this.text = 'OR',
    this.lineColor = NeoBrutalColors.white,
    this.thickness = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: lineColor, thickness: thickness),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: NeoBrutalTheme.mono.copyWith(color: lineColor),
          ),
        ),
        Expanded(
          child: Divider(color: lineColor, thickness: thickness),
        ),
      ],
    );
  }
}
