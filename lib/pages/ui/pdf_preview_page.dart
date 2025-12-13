import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../themes/neo_brutal_theme.dart';
import '../../controllers/pdf_preview_controller.dart';

class PdfPreviewPage extends GetView<PdfPreviewController> {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      appBar: AppBar(
        backgroundColor: NeoBrutalColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(color: NeoBrutalColors.black, height: 4),
        ),
        title: Text(
          'PDF PREVIEW',
          style: NeoBrutalTheme.heading.copyWith(fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: NeoBrutalColors.white),
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: NeoBrutalColors.white,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.pdfPath.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: controller.shareFile,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: NeoBrutalTheme.brutalBox(
                    color: NeoBrutalColors.purple,
                    borderColor: NeoBrutalColors.white,
                    borderWidth: 2,
                    shadowOffset: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.share_rounded,
                        size: 18,
                        color: NeoBrutalColors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SHARE',
                        style: NeoBrutalTheme.mono.copyWith(
                          color: NeoBrutalColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: NeoBrutalColors.lime,
                  strokeWidth: 4,
                ),
                const SizedBox(height: 24),
                Text(
                  'GENERATING PDF...',
                  style: NeoBrutalTheme.mono.copyWith(fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: NeoBrutalTheme.brutalBox(
                  color: NeoBrutalColors.darkGrey,
                  borderColor: NeoBrutalColors.orange,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: NeoBrutalColors.orange,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ERROR',
                      style: NeoBrutalTheme.heading.copyWith(
                        color: NeoBrutalColors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage.value,
                      style: NeoBrutalTheme.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SfPdfViewer.file(
          File(controller.pdfPath.value),
          key: Key(controller.pdfPath.value),
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
        );
      }),
    );
  }
}
