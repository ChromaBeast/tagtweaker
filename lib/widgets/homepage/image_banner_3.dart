import 'package:flutter/material.dart';

Widget imageBanner(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/banner.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
