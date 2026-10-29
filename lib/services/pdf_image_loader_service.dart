import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:tag_tweaker/models/product_model.dart';

/// High-performance concurrent image loader with in-memory caching for PDF generation.
class PdfImageLoaderService {
  /// Max images kept in memory (least recently used evicted first).
  static const int _maxCacheEntries = 40;

  /// Images larger than this are skipped to protect memory and PDF size.
  static const int _maxImageBytes = 5 * 1024 * 1024;

  /// Max simultaneous downloads, so large catalogs don't flood the network.
  static const int _maxConcurrent = 6;

  static const Duration _timeout = Duration(seconds: 15);

  static final Map<String, Uint8List> _cache = {};

  /// Client used for downloads; overridable for tests.
  @visibleForTesting
  static http.Client client = http.Client();

  /// Preloads images concurrently (bounded) and returns them keyed by product id.
  /// Reuses cached memory bytes when available to eliminate network I/O.
  static Future<Map<String, pw.MemoryImage?>> loadImagesConcurrently(
    List<Product> items,
  ) async {
    final Map<String, pw.MemoryImage?> result = {};

    for (var i = 0; i < items.length; i += _maxConcurrent) {
      final batch = items.skip(i).take(_maxConcurrent);
      final entries = await Future.wait(
        batch.map(
          (item) async => MapEntry(item.id, await fetchImage(item.thumbnail)),
        ),
      );
      result.addEntries(entries);
    }

    return result;
  }

  /// Fetches an image from memory cache or network.
  /// Only HTTPS URLs are accepted.
  static Future<pw.MemoryImage?> fetchImage(String? url) async {
    if (url == null || url.trim().isEmpty) return null;

    final cached = _cache.remove(url);
    if (cached != null) {
      _cache[url] = cached; // mark as most recently used
      return pw.MemoryImage(cached);
    }

    final uri = Uri.tryParse(url.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      debugPrint('PdfImageLoaderService: Rejected non-HTTPS image URL $url');
      return null;
    }

    try {
      final response = await client.get(uri).timeout(_timeout);
      final bytes = response.bodyBytes;
      if (response.statusCode == 200 &&
          bytes.isNotEmpty &&
          bytes.length <= _maxImageBytes) {
        _cache[url] = bytes;
        while (_cache.length > _maxCacheEntries) {
          _cache.remove(_cache.keys.first);
        }
        return pw.MemoryImage(bytes);
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
