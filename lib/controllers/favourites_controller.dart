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
import '../widgets/pdf/product_pdf_widget.dart';

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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favourites')
          .get();

      if (snapshot.docs.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No items in the catalog to generate PDF.'),
            ),
          );
        }
        return;
      }

      // Fetch all items and images
      final items = snapshot.docs.map((doc) {
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

      // Monochrome PDF colors
      const accentColor = PdfColor.fromInt(0xFF000000); // Black
      const darkGrey = PdfColor.fromInt(0xFF212121);
      const lightGrey = PdfColor.fromInt(0xFF757575);
      const veryLightGrey = PdfColor.fromInt(0xFFF5F5F5);

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: PdfColors.white),
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
                          color: accentColor,
                        ),
                      ),
                      pw.Text(
                        'PRODUCT CATALOG',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: lightGrey,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: accentColor,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      'OFFICIAL DOCUMENT',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: accentColor, thickness: 2),
              pw.SizedBox(height: 30),
            ],
          ),
          footer: (context) => pw.Column(
            children: [
              pw.Divider(color: lightGrey, thickness: 0.5),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Tag Tweaker © ${DateTime.now().year}',
                    style: pw.TextStyle(fontSize: 8, color: lightGrey),
                  ),
                  pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(fontSize: 8, color: lightGrey),
                  ),
                ],
              ),
            ],
          ),
          build: (pw.Context context) {
            return [
              ...items.map((map) {
                final image = images[map['id'].toString()];
                return buildProductPdfWidget(
                  map,
                  image,
                  accentColor,
                  darkGrey,
                  lightGrey,
                  veryLightGrey,
                );
              }),
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(pdfPath: file.path),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error generating PDF.')));
      }
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
