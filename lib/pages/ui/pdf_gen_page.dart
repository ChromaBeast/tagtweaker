import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tag_tweaker/pages/ui/pdf_preview_page.dart';

import '../../models/catalog_items.dart';
import '../../models/favourite_products.dart';

class PDFGenPage extends StatefulWidget {
  const PDFGenPage({super.key});

  @override
  State<PDFGenPage> createState() => _PDFGenPageState();
}

class _PDFGenPageState extends State<PDFGenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text('PDF Generation'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: FavouriteProducts.products.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      FavouriteProducts.products[index]['thumbnail'],
                      fit: BoxFit.cover,
                      height: 200.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    FavouriteProducts.products[index]['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${FavouriteProducts.products[index]['price'].toString()}\$",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                FavouriteProducts.toggleWishlist(
                                    FavouriteProducts.products[index]["id"]);
                              });
                            },
                            icon: FavouriteProducts.products[index]["ui"]
                                    ['isFavorite']
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,
                                  ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                CatalogItems.toggleCatalog(
                                    FavouriteProducts.products[index]["id"]);
                              });
                            },
                            icon: FavouriteProducts.products[index]["ui"]
                                    ['isInCatalog']
                                ? const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.check_box_outline_blank,
                                    color: Colors.grey,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.white,
        onPressed: () {
          _generatePDF(
            context,
          );
        },
        child: const Icon(Icons.check_sharp, color: Colors.black),
      ),
    );
  }
}

// CatalogPage class remains the same

Future<void> _generatePDF(BuildContext context) async {
  final pdf = pw.Document();
  if (CatalogItems.items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        elevation: 0,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        content: const Text('No items in the catalog to generate PDF.'),
      ),
    );
    return;
  }
  if (CatalogItems.items.isNotEmpty) {
    for (final item in CatalogItems.items) {
      final image = await _getImage(item['thumbnail']);
      if (image != null) {
        pdf.addPage(
          pw.Page(
            pageTheme: pw.PageTheme(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.all(32),
              buildBackground: (context) {
                return pw.FullPage(
                  ignoreMargins: true,
                  child: pw.Container(
                    color: PdfColors.white,
                  ),
                );
              },
            ),
            build: (pw.Context context) {
              return pw.ListView(
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: const PdfColor.fromInt(0xFFE0E0E0),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF000000),
                        width: 2,
                      ),
                      borderRadius: pw.BorderRadius.circular(16),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(image),
                        pw.Row(
                          children: [
                            pw.Text(
                              item['title'],
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Spacer(),
                            pw.Text(
                              'ID: ${item['id']}',
                              style: const pw.TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        pw.Text(
                          'Price: \$${item['price']}',
                          style: const pw.TextStyle(fontSize: 18),
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Description:',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              item['description'].toString(),
                              style: const pw.TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    }
  }

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
  try {
    // Navigate to a new screen to preview the PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(pdfPath: file.path),
      ),
    );
  } catch (e) {
    // Handle any exceptions that might occur
    debugPrint('Error navigating to PDF preview screen: $e');
  }
}

Future<pw.MemoryImage?> _getImage(String url) async {
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
