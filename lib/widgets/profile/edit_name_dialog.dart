import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal edit display name dialog
class NeoEditNameDialog extends StatefulWidget {
  final String initialName;

  const NeoEditNameDialog({super.key, required this.initialName});

  static Future<String?> show(BuildContext context, {required String initialName}) {
    return showDialog<String>(
      context: context,
      builder: (context) => NeoEditNameDialog(initialName: initialName),
    );
  }

  @override
  State<NeoEditNameDialog> createState() => _NeoEditNameDialogState();
}

class _NeoEditNameDialogState extends State<NeoEditNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'EDIT NAME',
              style: NeoBrutalTheme.heading.copyWith(
                fontSize: 20,
                color: NeoBrutalColors.black,
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
                controller: _controller,
                style: NeoBrutalTheme.body.copyWith(
                  color: NeoBrutalColors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Enter your name',
                  hintStyle: NeoBrutalTheme.body.copyWith(
                    color: NeoBrutalColors.mediumGrey,
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
                GestureDetector(
                  onTap: () => Navigator.pop(context, null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: NeoBrutalTheme.brutalBox(
                      color: NeoBrutalColors.white,
                      borderColor: NeoBrutalColors.black,
                      shadowColor: NeoBrutalColors.black,
                      shadowOffset: 2,
                    ),
                    child: Text(
                      'CANCEL',
                      style: NeoBrutalTheme.heading.copyWith(
                        fontSize: 14,
                        color: NeoBrutalColors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, _controller.text.trim()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: NeoBrutalTheme.brutalBox(
                      color: NeoBrutalColors.lime,
                      borderColor: NeoBrutalColors.black,
                      shadowColor: NeoBrutalColors.black,
                      shadowOffset: 2,
                    ),
                    child: Text(
                      'SAVE',
                      style: NeoBrutalTheme.heading.copyWith(
                        fontSize: 14,
                        color: NeoBrutalColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
