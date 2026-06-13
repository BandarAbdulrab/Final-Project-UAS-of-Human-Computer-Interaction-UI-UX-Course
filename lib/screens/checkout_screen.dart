import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  static const _adminFee = 2000;
  static const _deliveryFee = 15000;

  static const _pickupAddress =
      'K-24 AW SUMARMO PURBALINGGA, Jl. AW Sumarmo No 31, Kembaran Kulon, Purbalingga, Kab Purbalingga';

  String _deliveryMethod = 'delivery';
  String _paymentMethod = 'transfer';
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  int get _shippingFee =>
      _deliveryMethod == 'delivery' ? _deliveryFee : 0;

  Future<void> _onConfirm() async {
    final isEnglish = ref.read(isEnglishProvider);
    final user = ref.read(userProvider);
    final cartItems = ref.read(cartProvider.notifier).items;
    final subtotal = ref.read(cartTotalProvider);
    final total = subtotal + _adminFee + _shippingFee;

    if (_deliveryMethod == 'delivery' && user.address.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish
                ? 'Please enter your delivery address'
                : 'Harap masukkan alamat pengiriman',
          ),
        ),
      );
      return;
    }

    try {
      await ref.read(orderProvider.notifier).addOrder(
            items: cartItems,
            totalPrice: total,
            deliveryMethod: _deliveryMethod,
            paymentMethod: _paymentMethod,
          );
      ref.read(cartProvider.notifier).clearCart();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish ? 'Order Successful!' : 'Pesanan Berhasil!',
          ),
        ),
      );
      context.go('/home');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish
                ? 'Failed to place order. Please try again.'
                : 'Gagal membuat pesanan. Silakan coba lagi.',
          ),
        ),
      );
    }
  }

  Widget _priceRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? kK24Green : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLocation(bool isEnglish) {
    final user = ref.watch(userProvider);
    final hasAddress = user.address.trim().isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    if (_deliveryMethod != 'delivery') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Text(
          _pickupAddress,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasAddress) ...[
          Text(
            isEnglish
                ? 'Delivery address is required'
                : 'Alamat pengiriman wajib diisi',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _addressController,
            maxLines: 3,
            onChanged: (value) {
              ref.read(userProvider.notifier).updateAddress(value);
            },
            decoration: InputDecoration(
              labelText: isEnglish ? 'Delivery Address' : 'Alamat Pengiriman',
              hintText: isEnglish
                  ? 'Enter your full address'
                  : 'Masukkan alamat lengkap',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ] else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: Text(
              '${user.name}\n${user.address}\n${user.phone}',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(isEnglishProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final total = subtotal + _adminFee + _shippingFee;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Order Confirmation' : 'Konfirmasi Pesanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.yellow.shade200),
                  ),
                  child: Text(
                    isEnglish
                        ? '⚠️ Payment Simulation: Please DO NOT enter real credit card or personal information.'
                        : '⚠️ Simulasi Pembayaran: Harap JANGAN memasukkan data kartu kredit atau informasi pribadi yang asli.',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isEnglish ? 'Delivery Method' : 'Metode Pengiriman',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  value: 'delivery',
                  groupValue: _deliveryMethod,
                  activeColor: kK24Green,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    isEnglish
                        ? 'Delivery (Your Address)'
                        : 'Delivery (Alamat Anda)',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _deliveryMethod = value);
                    }
                  },
                ),
                RadioListTile<String>(
                  value: 'pickup',
                  groupValue: _deliveryMethod,
                  activeColor: kK24Green,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    isEnglish
                        ? 'Pickup (K-24 AW Sumarmo Purbalingga)'
                        : 'Pickup (K-24 AW Sumarmo Purbalingga)',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _deliveryMethod = value);
                    }
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  isEnglish ? 'Delivery Location' : 'Lokasi Pengiriman',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDeliveryLocation(isEnglish),
                const SizedBox(height: 24),
                Text(
                  isEnglish ? 'Payment Method' : 'Metode Pembayaran',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  value: 'transfer',
                  groupValue: _paymentMethod,
                  activeColor: kK24Green,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    isEnglish ? 'Bank Transfer' : 'Transfer Bank',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _paymentMethod = value);
                    }
                  },
                ),
                if (_paymentMethod == 'transfer')
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant),
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: Text(
                      isEnglish
                          ? 'Virtual Account BRI: 8806 0821 3016 9011 (a.n. Bandar Abdulrab)'
                          : 'Virtual Account BRI: 8806 0821 3016 9011 (a.n. Bandar Abdulrab)',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                  ),
                RadioListTile<String>(
                  value: 'card',
                  groupValue: _paymentMethod,
                  activeColor: kK24Green,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    isEnglish
                        ? 'Debit/Credit Card'
                        : 'Kartu Debit/Kredit',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _paymentMethod = value);
                    }
                  },
                ),
                if (_paymentMethod == 'card') ...[
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: isEnglish ? 'Card Number' : 'Nomor Kartu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _expiryController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: isEnglish
                          ? 'Valid Until (MM/YY)'
                          : 'Berlaku Hingga (MM/YY)',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 24),
                Text(
                  isEnglish ? 'Price Details' : 'Rincian Harga',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      _priceRow(
                        context,
                        label: isEnglish ? 'Subtotal' : 'Subtotal',
                        value: _formatRupiah(subtotal),
                      ),
                      _priceRow(
                        context,
                        label: isEnglish ? 'Shipping Fee' : 'Biaya Pengiriman',
                        value: _formatRupiah(_shippingFee),
                      ),
                      _priceRow(
                        context,
                        label: isEnglish ? 'Admin Fee' : 'Biaya Admin',
                        value: _formatRupiah(_adminFee),
                      ),
                      const Divider(height: 24),
                      _priceRow(
                        context,
                        label: isEnglish ? 'Total Price' : 'Total Harga',
                        value: _formatRupiah(total),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: SafeArea(
              top: false,
              child: FilledButton(
                onPressed: _onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: kK24Green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  isEnglish ? 'Confirm' : 'Konfirmasi',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
