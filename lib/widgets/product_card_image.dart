import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'product_image.dart';

class ProductCardImage extends StatelessWidget {
  const ProductCardImage({
    super.key,
    required this.product,
    required this.index,
  });

  final Product product;
  final int index;

  static bool showPromoBadge(Product product, int index) {
    return product.price < 30000 || index % 3 == 0;
  }

  @override
  Widget build(BuildContext context) {
    final showPromo = showPromoBadge(product, index);

    return Stack(
      children: [
        ProductImage(
          imagePath: product.imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        if (showPromo)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'PROMO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
