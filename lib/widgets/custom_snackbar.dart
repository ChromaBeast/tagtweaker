import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';

class CustomSnackbar {
  static void showSuccess({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      titleText: Text(
        title.toUpperCase(),
        style: NeoBrutalTheme.heading.copyWith(
          color: NeoBrutalColors.black,
          fontSize: 16,
        ),
      ),
      messageText: Text(
        message,
        style: NeoBrutalTheme.mono.copyWith(
          color: NeoBrutalColors.black,
          fontSize: 12,
        ),
      ),
      backgroundColor: NeoBrutalColors.lime,
      colorText: NeoBrutalColors.black,
      snackPosition: SnackPosition.TOP,
      borderRadius: 0,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      borderColor: NeoBrutalColors.black,
      borderWidth: 3,
      boxShadows: [
        const BoxShadow(
          color: NeoBrutalColors.black,
          offset: Offset(4, 4),
          blurRadius: 0,
        ),
      ],
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      titleText: Text(
        title.toUpperCase(),
        style: NeoBrutalTheme.heading.copyWith(
          color: NeoBrutalColors.black,
          fontSize: 16,
        ),
      ),
      messageText: Text(
        message,
        style: NeoBrutalTheme.mono.copyWith(
          color: NeoBrutalColors.black,
          fontSize: 12,
        ),
      ),
      backgroundColor: NeoBrutalColors.orange,
      colorText: NeoBrutalColors.black,
      snackPosition: SnackPosition.TOP,
      borderRadius: 0,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      borderColor: NeoBrutalColors.black,
      borderWidth: 3,
      boxShadows: [
        const BoxShadow(
          color: NeoBrutalColors.black,
          offset: Offset(4, 4),
          blurRadius: 0,
        ),
      ],
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      icon: const Icon(Icons.warning_amber_rounded, color: NeoBrutalColors.black, size: 28),
    );
  }
}
