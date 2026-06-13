import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/product_image.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.product});

  final Product product;

  String _formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(isEnglishProvider);
    final isFavorite = ref.watch(favoriteProvider).contains(product.id);

    final dosageText = isEnglish
        ? 'Take as directed by your doctor or pharmacist. Do not exceed the recommended dose. Store in a cool, dry place away from direct sunlight.'
        : 'Konsumsi sesuai anjuran dokter atau apoteker. Jangan melebihi dosis yang direkomendasikan. Simpan di tempat sejuk dan kering, jauh dari sinar matahari langsung.';

    final sideEffectsText = isEnglish
        ? 'May cause mild drowsiness, nausea, or allergic reactions in sensitive individuals. Stop use and consult a doctor if severe reactions occur.'
        : 'Dapat menyebabkan kantuk ringan, mual, atau reaksi alergi pada individu yang sensitif. Hentikan penggunaan dan konsultasikan ke dokter jika terjadi reaksi berat.';

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : colorScheme.onSurface,
            ),
            onPressed: () {
              ref.read(favoriteProvider.notifier).toggle(product.id);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          ProductImage(
            imagePath: product.imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 20),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kK24Green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isEnglish ? 'In Stock' : 'Stok Tersedia',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatRupiah(product.price),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kK24Green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              isEnglish ? 'Description' : 'Deskripsi',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    product.description,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: colorScheme.outlineVariant),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              isEnglish ? 'Dosage & Usage' : 'Dosis & Aturan Pakai',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    dosageText,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: colorScheme.outlineVariant),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              isEnglish ? 'Side Effects' : 'Efek Samping',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    sideEffectsText,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.surface,
        elevation: 8,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FilledButton.icon(
              onPressed: () {
                ref.read(cartProvider.notifier).addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEnglish
                          ? 'Added to cart'
                          : 'Ditambahkan ke keranjang',
                    ),
                  ),
                );
                context.pop();
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(isEnglish ? 'Add to Cart' : '+ Keranjang'),
              style: FilledButton.styleFrom(
                backgroundColor: kK24Green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
