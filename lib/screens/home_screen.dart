import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/app_logo.dart';
import '../widgets/product_card_image.dart';

class _CategoryChip {
  const _CategoryChip({
    required this.labelId,
    required this.labelEn,
    required this.category,
  });

  final String labelId;
  final String labelEn;
  final String category;
}

const _categories = [
  _CategoryChip(
    labelId: 'Obat Flu & Batuk',
    labelEn: 'Flu & Cough Medicine',
    category: 'Obat Flu',
  ),
  _CategoryChip(
    labelId: 'Vitamin & Suplemen',
    labelEn: 'Vitamins & Supplements',
    category: 'Vitamin',
  ),
  _CategoryChip(
    labelId: 'P3K',
    labelEn: 'First Aid',
    category: 'P3K',
  ),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();

    return products.where((product) {
      final matchesSearch =
          query.isEmpty || product.name.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == null ||
          product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _onAddToCart(Product product) {
    final isEnglish = ref.read(isEnglishProvider);
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEnglish ? 'Added to cart' : 'Ditambahkan ke keranjang',
        ),
      ),
    );
  }

  Widget _buildSearchNotFound(bool isEnglish) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish
                  ? 'Oops! Medicine not found.'
                  : 'Oops! Obat tidak ditemukan.',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              child: Text(
                isEnglish ? 'Clear Search' : 'Hapus Pencarian',
                style: const TextStyle(
                  color: kK24Green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(bool isEnglish, List<Product> products) {
    final filteredProducts = _filterProducts(products);
    final hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: isEnglish
                          ? 'Search medicine...'
                          : 'Cari obat...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kK24Green),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final chip = _categories[index];
                        final isSelected = _selectedCategory == chip.category;
                        return FilterChip(
                          label: Text(
                            isEnglish ? chip.labelEn : chip.labelId,
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory =
                                  selected ? chip.category : null;
                            });
                          },
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          selectedColor: kK24Green.withValues(alpha: 0.15),
                          checkmarkColor: kK24Green,
                          side: BorderSide(
                            color: isSelected
                                ? kK24Green
                                : colorScheme.outlineVariant,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? kK24Green : colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isEnglish ? 'Recommended' : 'Rekomendasi Obat',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (filteredProducts.isEmpty && hasSearchQuery)
            _buildSearchNotFound(isEnglish)
          else if (filteredProducts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  isEnglish ? 'No products found' : 'Produk tidak ditemukan',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = filteredProducts[index];
                    return _ProductCard(
                      product: product,
                      index: index,
                      priceLabel: _formatRupiah(product.price),
                      onTap: () => context.push('/detail', extra: product),
                      onAddToCart: () => _onAddToCart(product),
                    );
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(isEnglishProvider);
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(height: 50),
        centerTitle: true,
      ),
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: kK24Green),
        ),
        error: (error, _) => Center(
          child: Text(
            isEnglish ? 'Failed to load products' : 'Gagal memuat produk',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        data: (products) => _buildProductList(isEnglish, products),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
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
