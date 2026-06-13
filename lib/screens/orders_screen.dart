import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../models/order_model.dart';
import '../providers/locale_provider.dart';
import '../providers/main_tab_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/empty_state.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  String _formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(isEnglishProvider);
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Orders' : 'Pesanan'),
      ),
      body: orders.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long,
              title: isEnglish ? 'No orders yet' : 'Belum Ada Pesanan',
              subtitle: isEnglish
                  ? 'Your order history will appear here after checkout.'
                  : 'Riwayat pesananmu akan muncul di sini setelah checkout.',
              buttonLabel: isEnglish ? 'Shop Now' : 'Belanja Sekarang',
              onShopNow: () => ref.read(mainTabProvider.notifier).state = 0,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(
                  order: order,
                  isEnglish: isEnglish,
                  dateLabel: _formatDate(order.date),
                  priceLabel: _formatRupiah(order.totalPrice),
                );
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.isEnglish,
    required this.dateLabel,
    required this.priceLabel,
  });

  final OrderModel order;
  final bool isEnglish;
  final String dateLabel;
  final String priceLabel;

  String _formatItemsList() {
    if (order.items.isEmpty) {
      return isEnglish ? 'No items recorded' : 'Tidak ada item';
    }

    return order.items.map((item) {
      final quantity = item['quantity'] as num? ?? 1;
      final name = item['name'] as String? ??
          (isEnglish ? 'Product' : 'Produk');
      return '${quantity.toInt()}x $name';
    }).join(', ');
  }

  String _deliveryLabel() {
    switch (order.deliveryMethod) {
      case 'pickup':
        return isEnglish
            ? 'Pickup (K-24 AW Sumarmo Purbalingga)'
            : 'Pickup (K-24 AW Sumarmo Purbalingga)';
      case 'delivery':
        return isEnglish
            ? 'Delivery (Your Address)'
            : 'Delivery (Alamat Anda)';
      default:
        return order.deliveryMethod ?? '-';
    }
  }

  String _paymentLabel() {
    switch (order.paymentMethod) {
      case 'transfer':
        return isEnglish ? 'Bank Transfer' : 'Transfer Bank';
      case 'card':
        return isEnglish ? 'Debit/Credit Card' : 'Kartu Debit/Kredit';
      default:
        return order.paymentMethod ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnglish ? 'Order Date' : 'Tanggal Pesanan',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: order.status, isEnglish: isEnglish),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 14),
            Text(
              isEnglish ? 'Items' : 'Item Dibeli',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatItemsList(),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.local_shipping_outlined,
              label: isEnglish ? 'Delivery' : 'Pengiriman',
              value: _deliveryLabel(),
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.payments_outlined,
              label: isEnglish ? 'Payment' : 'Pembayaran',
              value: _paymentLabel(),
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEnglish ? 'Total' : 'Total Harga',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  priceLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kK24Green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.isEnglish,
  });

  final String status;
  final bool isEnglish;

  String _displayStatus() {
    if (status == 'Diproses') {
      return isEnglish ? 'Processing' : 'Diproses';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_top_rounded,
            size: 14,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            _displayStatus(),
            style: TextStyle(
              color: Colors.orange.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: kK24Green),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
