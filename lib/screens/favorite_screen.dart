import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card_image.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

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
    final favoriteIds = ref.watch(favoriteProvider);
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Favorites' : 'Obat Favorit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: kK24Green),
        ),
        error: (_, _) => Center(
          child: Text(
            isEnglish ? 'Failed to load products' : 'Gagal memuat produk',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        data: (products) {
          final favorites = products
              .where((product) => favoriteIds.contains(product.id))
              .toList();

          if (favorites.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: isEnglish ? 'No favorites yet' : 'Belum Ada Obat Favorit',
              subtitle: isEnglish
                  ? 'Save medicines you love and find them here quickly.'
                  : 'Simpan obat favoritmu agar mudah ditemukan kembali.',
              buttonLabel: isEnglish ? 'Shop Now' : 'Belanja Sekarang',
              onShopNow: () => context.go('/home'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return _FavoriteProductCard(
                product: product,
                index: index,
                priceLabel: _formatRupiah(product.price),
                onTap: () => context.push('/detail', extra: product),
                onAddToCart: () {
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
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  const _FavoriteProductCard({
    required this.product,
    required this.index,
    required this.priceLabel,
    required this.onTap,
    required this.onAddToCart,
  });

  final Product product;
  final int index;
  final String priceLabel;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final outlineColor = Theme.of(context).colorScheme.outlineVariant;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: outlineColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProductCardImage(
                  product: product,
                  index: index,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            priceLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kK24Green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Material(
                          color: kK24Green,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: onAddToCart,
                            borderRadius: BorderRadius.circular(8),
                            child: const SizedBox(
                              width: 28,
                              height: 28,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
