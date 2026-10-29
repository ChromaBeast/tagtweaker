import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable network image with disk and memory caching via CachedNetworkImage.
class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const CustomNetworkImage(
    this.imageUrl, {
    super.key,
    this.fit,
    this.width,
    this.height,
    this.errorWidget,
    this.loadingWidget,
  });

  Widget _buildDefaultError() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: Colors.grey[400],
          size: (width != null && width! < 30) ? 14 : 24,
        ),
      ),
    );
  }

  Widget _buildDefaultLoading(DownloadProgress? progress) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: progress?.progress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl.trim());
    if (uri == null || uri.scheme != 'https') {
      return errorWidget ?? _buildDefaultError();
    }

    // Decode at the displayed size instead of the source resolution, which
    // cuts image memory (and decode time) dramatically in grids/carousels.
    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final w =
            width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : null);
        final h =
            height ??
            (constraints.hasBoundedHeight ? constraints.maxHeight : null);
        // Use the larger box side so BoxFit.cover never has to upscale
        // (and blur) a decoded image.
        final side = w == null ? null : (h == null ? w : (w > h ? w : h));
        final cacheWidth = side == null || side <= 0
            ? null
            : (side * dpr).round();

        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          width: width,
          height: height,
          memCacheWidth: cacheWidth,
          fadeInDuration: const Duration(milliseconds: 200),
          progressIndicatorBuilder: (context, url, progress) {
            return loadingWidget ?? _buildDefaultLoading(progress);
          },
          errorWidget: (context, url, error) {
            return errorWidget ?? _buildDefaultError();
          },
        );
      },
    );
  }
}
