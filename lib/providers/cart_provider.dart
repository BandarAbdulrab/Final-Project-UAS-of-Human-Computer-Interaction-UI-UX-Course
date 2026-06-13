import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super({});

  List<CartItem> get items => state.values.toList();

  int get totalPrice =>
      state.values.fold(0, (sum, item) => sum + item.lineTotal);

  void addItem(Product product) {
    final existing = state[product.id];
    if (existing != null) {
      state = {
        ...state,
        product.id: existing.copyWith(quantity: existing.quantity + 1),
      };
    } else {
      state = {
        ...state,
        product.id: CartItem(product: product, quantity: 1),
      };
    }
  }

  void removeItem(String productId) {
    final updated = Map<String, CartItem>.from(state)..remove(productId);
    state = updated;
  }

  void increaseQuantity(String productId) {
    final item = state[productId];
    if (item == null) return;
    state = {
      ...state,
      productId: item.copyWith(quantity: item.quantity + 1),
    };
  }

  void decreaseQuantity(String productId) {
    final item = state[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      removeItem(productId);
    } else {
      state = {
        ...state,
        productId: item.copyWith(quantity: item.quantity - 1),
      };
    }
  }

  void clearCart() {
    state = {};
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.values.fold(0, (sum, item) => sum + item.lineTotal);
});
