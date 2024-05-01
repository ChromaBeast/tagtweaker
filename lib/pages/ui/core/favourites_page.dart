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

import '../../../widgets/functions/share_individual.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'Favourite Products',
          style: TextStyle(color: Colors.white),
        ),
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
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length, // Use snapshot.data!.length
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    goToProductPage(context, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            snapshot.data![index]
                                ['thumbnail'], // Access using index
                            fit: BoxFit.cover,
                            height: 200.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          snapshot.data![index]['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '\$${snapshot.data?[index]['price']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Remove from Favourites'),
                                          content: const Text(
                                              'Are you sure you want to remove this item from your favourites?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(auth.currentUser?.uid)
                                                    .collection('favourites')
                                                    .doc(snapshot.data![index]
                                                            ['id']
                                                        .toString())
                                                    .delete();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UIPage(
                                                            selectedIndex: 2),
                                                  ),
                                                );
                                              },
                                              child: const Text('Remove'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    genPDF(context, snapshot.data![index]);
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Please wait while we load your favourites"),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.grey[800],
        onPressed: () {
          _generatePDF(context);
        },
        child: const Icon(
          Icons.picture_as_pdf,
          color: Colors.white,
        ),
      ),
    );
  }

  _generatePDF(BuildContext context) async {
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
        // Navigate to a new screen to preview the PDF
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(pdfPath: file.path),
          ),
        );
      } catch (e) {
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
          content: const Text('Error generating PDF.'),
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
