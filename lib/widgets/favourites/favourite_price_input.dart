import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favourites_controller.dart';
import '../../models/product_model.dart';
import '../../themes/neo_brutal_theme.dart';

/// Editable price input field for a favourite product item
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
    final price = controller.getPrice(
      widget.item.id,
      widget.item.price.toStringAsFixed(0),
    );
    _priceController = TextEditingController(
      text: price.isNotEmpty ? price : '0',
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
            child: TextField(
              controller: _priceController,
              onChanged: _onPriceChanged,
              style: NeoBrutalTheme.mono.copyWith(
                fontSize: 14,
                color: NeoBrutalColors.black,
              ),
              keyboardType: TextInputType.number,
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
                hintText: widget.item.price.toStringAsFixed(0),
                hintStyle: NeoBrutalTheme.mono.copyWith(
                  fontSize: 14,
                  color: NeoBrutalColors.mediumGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
