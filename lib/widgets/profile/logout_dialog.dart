import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal logout confirmation dialog
class NeoLogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const NeoLogoutDialog({super.key, required this.onConfirm});

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      builder: (context) => NeoLogoutDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              'LOGOUT?',
              style: NeoBrutalTheme.heading.copyWith(
                fontSize: 20,
                color: NeoBrutalColors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to log out?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  label: 'CANCEL',
                  color: NeoBrutalColors.white,
                  onTap: () => Navigator.pop(context),
                ),
                _buildButton(
                  label: 'LOGOUT',
                  color: NeoBrutalColors.lime,
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: NeoBrutalTheme.brutalBox(
          color: color,
          borderColor: NeoBrutalColors.black,
          shadowColor: NeoBrutalColors.black,
          shadowOffset: 2,
        ),
        child: Text(
          label,
          style: NeoBrutalTheme.heading.copyWith(
            fontSize: 14,
            color: NeoBrutalColors.black,
          ),
        ),
      ),
    );
  }
}
