import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../pages/ui/pdf_preview_page.dart';
import '../controllers/pdf_preview_controller.dart';
import '../widgets/pdf/product_pdf_widget.dart';
import '../widgets/pdf/neo_brutal_pdf_theme.dart';
import '../widgets/custom_snackbar.dart';

class FavouritesController extends GetxController {
  // Map to store local price overrides: ProductID -> New Price
  final RxMap<String, String> modifiedPrices = <String, String>{}.obs;

  void updatePrice(String productId, String newPrice) {
    if (newPrice.isEmpty) {
      modifiedPrices.remove(productId);
    } else {
      modifiedPrices[productId] = newPrice;
    }
  }

  String getPrice(String productId, String originalPrice) {
    return modifiedPrices[productId] ?? originalPrice;
  }

  Future<void> generatePDF(BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favourites')
        .get();

    if (snapshot.docs.isEmpty) {
      if (context.mounted) {
        CustomSnackbar.showError(
          title: 'EMPTY CATALOG',
          message: 'No items in the catalog to generate PDF.',
        );
      }
      return;
    }

    // Navigate immediately to the preview page
    Get.to(
      () => const PdfPreviewPage(),
      binding: BindingsBuilder(() {
        Get.put(
          PdfPreviewController(
            pdfGenerator: () => _generatePdfFile(snapshot.docs),
          ),
        );
      }),
    );
  }

  Future<String> _generatePdfFile(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    try {
      // Fetch all items and images
      final items = docs.map((doc) {
        final data = doc.data();
        // Override price if modified locally
        final id = data['id'].toString();
        if (modifiedPrices.containsKey(id)) {
          final modPrice = modifiedPrices[id]!;
          // Map is usually immutable from Firestore, so we create a copy
          final mutableData = Map<String, dynamic>.from(data);
          mutableData['price'] = modPrice;
          return mutableData;
        }
        return data;
      }).toList();

      final Map<String, pw.MemoryImage?> images = {};
      for (final item in items) {
        images[item['id'].toString()] = await _getImage(item['thumbnail']);
      }

      final pdf = pw.Document();

      final List<pw.Widget> pdfContent = [];
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final image = images[item['id'].toString()];

        pdfContent.add(buildProductPdfWidget(item, image));

        // Add spacing between items, but not after the last one
        if (i < items.length - 1) {
          pdfContent.add(pw.SizedBox(height: 20));
          pdfContent.add(
            pw.Divider(color: NeoBrutalPdfColors.mediumGrey, thickness: 1),
          );
          pdfContent.add(pw.SizedBox(height: 20));
        }
      }

      debugPrint('Generated PDF content for ${items.length} items.');

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: NeoBrutalPdfColors.background),
            ),
          ),
          header: (context) => pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'TAG TWEAKER',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: NeoBrutalPdfColors.white,
                        ),
                      ),
                      pw.Text(
                        'PRODUCT CATALOG',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: NeoBrutalPdfColors.lime,
                          letterSpacing: 2,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: NeoBrutalPdfTheme.brutalBox(
                      color: NeoBrutalPdfColors.purple,
                      borderColor: NeoBrutalPdfColors.white,
                    ),
                    child: pw.Text(
                      'OFFICIAL DOCUMENT',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: NeoBrutalPdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: NeoBrutalPdfColors.white, thickness: 2),
              pw.SizedBox(height: 30),
            ],
          ),
          footer: (context) => pw.Column(
            children: [
              pw.Divider(color: NeoBrutalPdfColors.lightGrey, thickness: 0.5),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Tag Tweaker © ${DateTime.now().year}',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: NeoBrutalPdfColors.lightGrey,
                    ),
                  ),
                  pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: NeoBrutalPdfColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          build: (pw.Context context) {
            return pdfContent;
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${output.path}/tag_tweaker_catalog_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      throw Exception('Error generating PDF: $e');
    }
  }

  Future<pw.MemoryImage?> _getImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return pw.MemoryImage(response.bodyBytes);
      }
    } catch (e) {
      debugPrint('Error loading image from URL: $e');
    }
    return null;
  }
}
