import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RasoiImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const RasoiImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    Widget imageWidget;

    if (imageUrl!.startsWith('data:image')) {
      // Handle Base64 Data URI
      try {
        final commaIndex = imageUrl!.indexOf(',');
        final base64String = commaIndex != -1 ? imageUrl!.substring(commaIndex + 1) : imageUrl!;
        final imageBytes = base64Decode(base64String);
        imageWidget = Image.memory(
          imageBytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      } catch (e) {
        imageWidget = _buildError();
      }
    } else if (imageUrl!.startsWith('http')) {
      // Handle Network URL
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildError(),
      );
    } else {
      // Fallback or local file path if we ever support that directly here
      imageWidget = _buildError();
    }

    if (borderRadius > 0) {
      return ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.image, color: Colors.grey)),
        );
  }

  Widget _buildError() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        );
  }
}
