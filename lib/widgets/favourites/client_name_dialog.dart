import 'package:flutter/material.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

/// Asks which client a quotation is for. Returns the trimmed name (possibly
/// empty for a walk-in client), or null if the user cancelled.
class ClientNameDialog extends StatefulWidget {
  const ClientNameDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const ClientNameDialog(),
    );
  }

  @override
  State<ClientNameDialog> createState() => _ClientNameDialogState();
}

class _ClientNameDialogState extends State<ClientNameDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text.trim());

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'NEW QUOTATION',
              style: NeoBrutalTheme.heading.copyWith(
                fontSize: 20,
                color: NeoBrutalColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Saved to your quotation history and exported as PDF.',
              style: NeoBrutalTheme.body.copyWith(
                fontSize: 13,
                color: NeoBrutalColors.lightGrey,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.white,
                borderColor: NeoBrutalColors.black,
                shadowOffset: 0,
              ),
              child: TextField(
                key: const Key('clientNameField'),
                controller: _controller,
                autofocus: true,
                maxLength: 100,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (_) => _submit(),
                style: NeoBrutalTheme.body.copyWith(
                  color: NeoBrutalColors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: '',
                  hintText: 'Client name (optional)',
                  hintStyle: NeoBrutalTheme.body.copyWith(
                    color: NeoBrutalColors.lightGrey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DialogButton(
                  label: 'CANCEL',
                  color: NeoBrutalColors.white,
                  onTap: () => Navigator.pop(context),
                ),
                _DialogButton(
                  label: 'CREATE',
                  color: NeoBrutalColors.lime,
                  onTap: _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
