import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/main_tab_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_image.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

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
    final cartItems = ref.watch(cartProvider).values.toList();
    final total = ref.watch(cartTotalProvider);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Cart' : 'Keranjang'),
      ),
      body: cartItems.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: isEnglish ? 'Empty Cart' : 'Keranjang Kosong',
              subtitle: isEnglish
                  ? 'Add medicines to your cart and checkout easily.'
                  : 'Yuk, tambahkan obat ke keranjang dan checkout dengan mudah.',
              buttonLabel: isEnglish ? 'Shop Now' : 'Belanja Sekarang',
              onShopNow: () =>
                  ref.read(mainTabProvider.notifier).state = 0,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _CartItemTile(
                        item: cartItems[index],
                        priceLabel: _formatRupiah(cartItems[index].product.price),
                        onDecrease: () => ref
                            .read(cartProvider.notifier)
                            .decreaseQuantity(cartItems[index].product.id),
                        onIncrease: () => ref
                            .read(cartProvider.notifier)
                            .increaseQuantity(cartItems[index].product.id),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEnglish ? 'Total Price' : 'Total Harga',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _formatRupiah(total),
                              style: const TextStyle(
                                color: kK24Green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.push('/checkout'),
                          style: FilledButton.styleFrom(
                            backgroundColor: kK24Green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            isEnglish ? 'Checkout' : 'Lanjut Pembayaran',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.priceLabel,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CartItem item;
  final String priceLabel;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          ProductImage(
            imagePath: item.product.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  priceLabel,
                  style: const TextStyle(
                    color: kK24Green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: kK24Green,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrease,
                      icon: const Icon(Icons.add_circle_outline),
                      color: kK24Green,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
