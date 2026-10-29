import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

/// Bottom sheet for editing quote-wide pricing rules. Returns the new rules,
/// or null if dismissed.
class PricingRulesSheet extends StatefulWidget {
  final PricingRules initial;

  const PricingRulesSheet({super.key, required this.initial});

  static Future<PricingRules?> show(
    BuildContext context,
    PricingRules initial,
  ) {
    return showModalBottomSheet<PricingRules>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PricingRulesSheet(initial: initial),
    );
  }

  @override
  State<PricingRulesSheet> createState() => _PricingRulesSheetState();
}

class _PricingRulesSheetState extends State<PricingRulesSheet> {
  late final TextEditingController _markup;
  late final TextEditingController _tax;
  late PriceRounding _rounding;

  static const _roundingLabels = {
    PriceRounding.none: 'EXACT',
    PriceRounding.nearestOne: '₹1',
    PriceRounding.nearestTen: '₹10',
    PriceRounding.endingIn9: '…9',
  };

  @override
  void initState() {
    super.initState();
    _markup = TextEditingController(text: _fmt(widget.initial.markupPercent));
    _tax = TextEditingController(text: _fmt(widget.initial.taxPercent));
    _rounding = widget.initial.rounding;
  }

  @override
  void dispose() {
    _markup.dispose();
    _tax.dispose();
    super.dispose();
  }

  static String _fmt(double v) => v == 0
      ? ''
      : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString());

  static double _parse(String raw, {required double min, required double max}) {
    final v = double.tryParse(raw.trim()) ?? 0;
    return v.clamp(min, max).toDouble();
  }

  void _apply() {
    Navigator.pop(
      context,
      widget.initial.copyWith(
        markupPercent: _parse(_markup.text, min: -90, max: 500),
        taxPercent: _parse(_tax.text, min: 0, max: 100),
        rounding: _rounding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: NeoBrutalColors.white,
          border: Border(
            top: BorderSide(color: NeoBrutalColors.black, width: 4),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PRICING RULES',
                style: NeoBrutalTheme.heading.copyWith(
                  fontSize: 22,
                  color: NeoBrutalColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Applied to every item without a manual price.',
                style: NeoBrutalTheme.body.copyWith(
                  fontSize: 13,
                  color: NeoBrutalColors.lightGrey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _PercentField(
                      key: const Key('markupField'),
                      label: 'MARKUP %',
                      hint: '0 (use - for discount)',
                      controller: _markup,
                      allowNegative: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PercentField(
                      key: const Key('taxField'),
                      label: 'TAX / GST %',
                      hint: '0',
                      controller: _tax,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'ROUNDING',
                style: NeoBrutalTheme.heading.copyWith(
                  fontSize: 12,
                  color: NeoBrutalColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final mode in PriceRounding.values)
                    GestureDetector(
                      onTap: () => setState(() => _rounding = mode),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: NeoBrutalTheme.brutalBox(
                          color: _rounding == mode
                              ? NeoBrutalColors.lime
                              : NeoBrutalColors.white,
                          borderColor: NeoBrutalColors.black,
                          borderWidth: 2,
                          shadowColor: NeoBrutalColors.black,
                          shadowOffset: _rounding == mode ? 0 : 2,
                        ),
                        child: Text(
                          _roundingLabels[mode]!,
                          style: NeoBrutalTheme.heading.copyWith(
                            fontSize: 13,
                            color: NeoBrutalColors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                key: const Key('applyRules'),
                onTap: _apply,
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: NeoBrutalTheme.brutalBox(
                    color: NeoBrutalColors.purple,
                    borderColor: NeoBrutalColors.black,
                    shadowColor: NeoBrutalColors.black,
                    shadowOffset: 4,
                  ),
                  child: Text(
                    'APPLY RULES',
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 16,
                      color: NeoBrutalColors.white,
                    ),
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

class _PercentField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool allowNegative;

  const _PercentField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.allowNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: NeoBrutalTheme.heading.copyWith(
            fontSize: 12,
            color: NeoBrutalColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: NeoBrutalTheme.brutalBox(
            color: NeoBrutalColors.white,
            borderColor: NeoBrutalColors.black,
            borderWidth: 2,
            shadowColor: NeoBrutalColors.black,
            shadowOffset: 2,
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: allowNegative,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(allowNegative ? r'^-?\d*\.?\d*' : r'^\d*\.?\d*'),
              ),
            ],
            style: NeoBrutalTheme.mono.copyWith(
              fontSize: 14,
              color: NeoBrutalColors.black,
            ),
            decoration: InputDecoration(
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              hintText: hint,
              hintStyle: NeoBrutalTheme.mono.copyWith(
                fontSize: 12,
                color: NeoBrutalColors.lightGrey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
