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
    if (imageUrl.trim().isEmpty) {
      return errorWidget ?? _buildDefaultError();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, progress) {
        return loadingWidget ?? _buildDefaultLoading(progress);
      },
      errorWidget: (context, url, error) {
        return errorWidget ?? _buildDefaultError();
      },
    );
  }
}
