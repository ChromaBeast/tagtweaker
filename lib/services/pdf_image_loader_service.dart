import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import '../models/product_model.dart';

/// High-performance concurrent image loader with in-memory caching for PDF generation.
class PdfImageLoaderService {
  static final Map<String, Uint8List> _cache = {};

  /// Preloads all images concurrently in parallel using Future.wait.
  /// Reuses cached memory bytes when available to eliminate network I/O.
  static Future<Map<String, pw.MemoryImage?>> loadImagesConcurrently(
    List<Product> items,
  ) async {
    final Map<String, pw.MemoryImage?> result = {};

    final futures = items.map((item) async {
      final img = await fetchImage(item.thumbnail);
      return MapEntry(item.id, img);
    }).toList();

    final entries = await Future.wait(futures);
    for (final entry in entries) {
      result[entry.key] = entry.value;
    }

    return result;
  }

  /// Fetches an image from memory cache or network.
  static Future<pw.MemoryImage?> fetchImage(String? url) async {
    if (url == null || url.trim().isEmpty) return null;

    if (_cache.containsKey(url)) {
      return pw.MemoryImage(_cache[url]!);
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _cache[url] = response.bodyBytes;
        return pw.MemoryImage(response.bodyBytes);
      }
    } catch (e) {
      debugPrint('PdfImageLoaderService: Failed to fetch image $url: $e');
    }
    return null;
  }

  /// Clears the in-memory image cache.
  static void clearCache() => _cache.clear();

  /// Total cached images count.
  static int get cachedCount => _cache.length;
}
