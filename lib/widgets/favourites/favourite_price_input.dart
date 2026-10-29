import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/utils/money.dart';

/// Editable price input for a favourite item. Empty means "use the pricing
/// rules" (shown as the hint); any typed value is a manual override.
class FavouritePriceInput extends StatefulWidget {
  final Product item;

  const FavouritePriceInput({super.key, required this.item});

  @override
  State<FavouritePriceInput> createState() => _FavouritePriceInputState();
}

class _FavouritePriceInputState extends State<FavouritePriceInput> {
  late final TextEditingController _priceController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<FavouritesController>();
    _priceController = TextEditingController(
      text: controller.getPrice(widget.item.id, ''),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _priceController.dispose();
    super.dispose();
  }

  void _onPriceChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      Get.find<FavouritesController>().updatePrice(widget.item.id, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavouritesController>();
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: NeoBrutalColors.white,
        border: Border.all(color: NeoBrutalColors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: NeoBrutalColors.black, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: NeoBrutalColors.black, width: 2),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '₹',
              style: NeoBrutalTheme.heading.copyWith(
                fontSize: 14,
                color: NeoBrutalColors.black,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => TextField(
                key: Key('priceInput_${widget.item.id}'),
                controller: _priceController,
                onChanged: _onPriceChanged,
                style: NeoBrutalTheme.mono.copyWith(
                  fontSize: 14,
                  color: NeoBrutalColors.black,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  hintText: formatMoney(controller.rulePrice(widget.item)),
                  hintStyle: NeoBrutalTheme.mono.copyWith(
                    fontSize: 14,
                    color: NeoBrutalColors.mediumGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
