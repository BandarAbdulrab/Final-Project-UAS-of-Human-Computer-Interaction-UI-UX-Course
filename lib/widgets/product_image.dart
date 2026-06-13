import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade100,
      child: const Icon(
        Icons.medication_outlined,
        color: kK24Green,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget image = imagePath.startsWith('assets/')
        ? Image.asset(
            imagePath,
            fit: fit,
            errorBuilder: (_, _, _) => _placeholder(),
          )
        : Image.network(
            imagePath,
            fit: fit,
            errorBuilder: (_, _, _) => _placeholder(),
          );

    if (height == double.infinity && width == double.infinity) {
      image = SizedBox.expand(child: image);
    } else if (height != null || width != null) {
      image = SizedBox(
        height: height,
        width: width,
        child: image,
      );
    }

    if (borderRadius == null) return image;

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }
}
