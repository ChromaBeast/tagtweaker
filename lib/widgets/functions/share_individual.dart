import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/pdf_preview_controller.dart';
import '../../models/product_model.dart';
import '../../pages/ui/pdf_preview_page.dart';
import '../../services/catalog_pdf_service.dart';

/// Generates and previews a single product PDF
Future<void> genPDF(BuildContext context, Product product) async {
  Get.to(
    () => const PdfPreviewPage(),
    binding: BindingsBuilder(() {
      Get.put(
        PdfPreviewController(
          pdfGenerator: () => CatalogPdfService.generateCatalogPdf([product]),
        ),
      );
    }),
  );
}
