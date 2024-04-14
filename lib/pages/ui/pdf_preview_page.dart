import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String pdfPath;

  const PdfPreviewScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Preview'),
        ),
        body: PDFView(
          filePath: pdfPath,
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.black,
          shape: const CircleBorder(
            eccentricity: 0.5,
          ),
          onPressed: () {
            _shareFile(pdfPath);
          },
          child: const Icon(Icons.ios_share_rounded),
        ));
  }
}

Future<void> _shareFile(String pdfPath) async {
  final file = File(pdfPath);
  if (await file.exists()) {
    XFile xFile = XFile(pdfPath);
    await Share.shareXFiles([xFile]);
  }
}
