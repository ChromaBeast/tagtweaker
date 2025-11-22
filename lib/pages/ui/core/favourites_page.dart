import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tag_tweaker/pages/ui/pdf_preview_page.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/pages/ui/ui_screen.dart';

import '../../../themes/colors.dart';
import '../../../widgets/functions/share_individual.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Favourite Products',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _generatePDF(context, colorScheme),
            icon: Icon(
              Icons.picture_as_pdf_rounded,
              color: colorScheme.primary,
            ),
            tooltip: 'Export All to PDF',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .collection('favourites')
            .get()
            .then((value) => value.docs.map((doc) => doc.data()).toList()),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading your favourites...',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildFavouriteCard(
                  context,
                  snapshot.data![index],
                  auth,
                  colorScheme,
                  textTheme,
                  index,
                );
              },
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_outline_rounded,
                  size: 80,
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No favourites yet',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add products to your favourites to see them here',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generatePDF(context, colorScheme),
        icon: Icon(
          Icons.picture_as_pdf_rounded,
          color: colorScheme.onPrimaryContainer,
        ),
        label: Text(
          'Export PDF',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteCard(
    BuildContext context,
    Map<String, dynamic> item,
    FirebaseAuth auth,
    ColorScheme colorScheme,
    TextTheme textTheme,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => goToProductPage(context, index),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item['thumbnail'],
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              // Product Title
              Text(
                item['title'],
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Price Input and Actions Row
              Row(
                children: [
                  // Price Input
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(auth.currentUser?.uid)
                                    .collection('favourites')
                                    .doc(item['id'].toString())
                                    .update({'price': value});
                              },
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                hintText: item['price'].toString(),
                                hintStyle: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '\$',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Action Buttons
                  IconButton.filled(
                    onPressed: () =>
                        _showRemoveDialog(context, item, auth, colorScheme),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.favoriteColor.withOpacity(0.2),
                    ),
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: AppColors.favoriteColor,
                    ),
                    tooltip: 'Remove from Favourites',
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => genPDF(context, item),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.shareColor.withOpacity(0.2),
                    ),
                    icon: Icon(
                      Icons.share_rounded,
                      color: AppColors.shareColor,
                    ),
                    tooltip: 'Share Product',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    Map<String, dynamic> item,
    FirebaseAuth auth,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favourites'),
        content: const Text(
            'Are you sure you want to remove this item from your favourites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser?.uid)
                  .collection('favourites')
                  .doc(item['id'].toString())
                  .delete();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UIPage(selectedIndex: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            child: Text(
              'Remove',
              style: TextStyle(color: colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  _generatePDF(BuildContext context, ColorScheme colorScheme) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favourites')
        .get()
        .then((snapshot) async {
      final pdf = pw.Document();
      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No items in the catalog to generate PDF.'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
        return;
      }
      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          final item = doc.data();
          final image = await _getImage(item['thumbnail']);
          if (image != null) {
            pdf.addPage(
              pw.Page(
                pageTheme: pw.PageTheme(
                  pageFormat: PdfPageFormat.a4,
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
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          color: const PdfColor.fromInt(0xFFE0E0E0),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                          borderRadius: pw.BorderRadius.circular(16),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Image(image,
                                height: 300, fit: pw.BoxFit.contain),
                            pw.Row(
                              children: [
                                pw.Text(
                                  item['title'],
                                  style: pw.TextStyle(
                                    fontSize: 24,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text(
                                  'Price: ${item['price']}\$',
                                  style: const pw.TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                                  pw.SizedBox(height: 20),
                                ])
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(pdfPath: file.path),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error generating PDF.'),
          ),
        );
      }
    });
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

  goToProductPage(BuildContext context, int index) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favourites')
        .get();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
          product: snapshot.docs[index].data() as Map<String, dynamic>,
        ),
      ),
    );
  }
}
