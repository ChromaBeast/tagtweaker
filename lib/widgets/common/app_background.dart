import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';
import '../grid_painter.dart';

/// Reusable Neo-Brutal background pattern widget with grid overlay.
/// Eliminates network calls for background textures and renders directly via Canvas.
class AppBackground extends StatelessWidget {
  final Widget? child;

  const AppBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: NeoBrutalColors.background,
        child: CustomPaint(
          painter: GridPainter(),
          child: child ?? const SizedBox.expand(),
        ),
      ),
    );
  }
}
