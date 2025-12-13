import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class PdfPreviewController extends GetxController {
  final Future<String> Function() pdfGenerator;
  final RxBool isLoading = true.obs;
  final RxString pdfPath = ''.obs;
  final RxString errorMessage = ''.obs;

  PdfPreviewController({required this.pdfGenerator});

  @override
  void onInit() {
    super.onInit();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final path = await pdfGenerator();
      pdfPath.value = path;
    } catch (e) {
      errorMessage.value = 'Failed to generate PDF: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareFile() async {
    if (pdfPath.value.isEmpty) return;
    
    final file = File(pdfPath.value);
    if (await file.exists()) {
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(pdfPath.value)]);
    }
  }
}
