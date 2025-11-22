import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String pdfPath;

  const PdfPreviewScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF Preview',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          FilledButton.tonal(
            onPressed: () => _shareFile(pdfPath),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.share_rounded,
                  size: 18,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Share',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _shareFile(pdfPath),
        icon: Icon(
          Icons.share_rounded,
          color: colorScheme.onPrimaryContainer,
        ),
        label: Text(
          'Share PDF',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

Future<void> _shareFile(String pdfPath) async {
  final file = File(pdfPath);
  if (await file.exists()) {
    XFile xFile = XFile(pdfPath);
    await Share.shareXFiles([xFile]);
  }
}
