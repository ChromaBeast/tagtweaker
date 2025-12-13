import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NeoBrutalPdfColors {
  static const PdfColor background = PdfColor.fromInt(0xFF262626);
  static const PdfColor lime = PdfColor.fromInt(0xFFA3E635);
  static const PdfColor white = PdfColor.fromInt(0xFFFFFFFF);
  static const PdfColor black = PdfColor.fromInt(0xFF000000);
  static const PdfColor darkGrey = PdfColor.fromInt(0xFF1A1A1A);
  static const PdfColor mediumGrey = PdfColor.fromInt(0xFF333333);
  static const PdfColor lightGrey = PdfColor.fromInt(0xFF4A4A4A);
  static const PdfColor purple = PdfColor.fromInt(0xFF9333EA);
  static const PdfColor orange = PdfColor.fromInt(0xFFF97316);
}

class NeoBrutalPdfTheme {
  static pw.BoxDecoration brutalBox({
    PdfColor color = NeoBrutalPdfColors.darkGrey,
    PdfColor borderColor = NeoBrutalPdfColors.white,
    double borderWidth = 2.0,
    PdfColor shadowColor = NeoBrutalPdfColors.white,
    double shadowOffset = 4.0,
  }) {
    return pw.BoxDecoration(
      color: color,
      border: pw.Border.all(color: borderColor, width: borderWidth),
      // PDF package doesn't support complex shadows easily in the same way as Flutter
      // We will simulate it or just stick to strong borders for now. 
      // BoxShadow in pdf package is limited.
    );
  }
  
  // Helper to create a stack for the hard shadow effect if needed
  // or just use a simple border for now as shadows in PDF are tricky.
  // We'll stick to strong borders and high contrast.
}
