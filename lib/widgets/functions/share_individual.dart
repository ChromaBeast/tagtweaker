import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tag_tweaker/controllers/pdf_preview_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/pages/ui/pdf_preview_page.dart';
import 'package:tag_tweaker/services/catalog_pdf_service.dart';

/// Generates and previews a single product PDF
Future<void> genPDF(BuildContext context, Product product) async {
  unawaited(
    Get.to(
      () => const PdfPreviewPage(),
      binding: BindingsBuilder(() {
        Get.put(
          PdfPreviewController(
            pdfGenerator: () => CatalogPdfService.generateCatalogPdf([product]),
          ),
        );
      }),
    ),
  );
}
