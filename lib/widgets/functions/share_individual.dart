import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../pages/ui/pdf_preview_page.dart';

Future<void> genPDF(BuildContext context, Map<String, dynamic> map) async {
  final pdf = pw.Document();
  final image = await _getImage(map['thumbnail']);
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
                          map['title'],
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Spacer(),
                        pw.Text(
                          'ID: ${map['id']}',
                          style: const pw.TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    pw.Text(
                      'Price: \$${map['price']}',
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
                          map['description'].toString(),
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
