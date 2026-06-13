import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/order_model.dart';

class OrderNotifier extends StateNotifier<List<OrderModel>> {
  OrderNotifier({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(const []) {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _listenToUserOrders(currentUser.uid);
    }
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;

  void _onAuthChanged(User? user) {
    _ordersSubscription?.cancel();
    if (user == null) {
      state = const [];
      return;
    }
    _listenToUserOrders(user.uid);
  }

  void _listenToUserOrders(String uid) {
    _ordersSubscription = _firestore
        .collection('orders')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      final orders = snapshot.docs.map(OrderModel.fromFirestore).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      state = orders;
    });
  }

  Future<void> addOrder({
    required List<CartItem> items,
    required int totalPrice,
    required String deliveryMethod,
    required String paymentMethod,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    await _firestore.collection('orders').add({
      'uid': uid,
      'items': items
          .map(
            (item) => {
              'productId': item.product.id,
              'name': item.product.name,
              'price': item.product.price,
              'quantity': item.quantity,
              'imageUrl': item.product.imageUrl,
            },
          )
          .toList(),
      'totalPrice': totalPrice,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'date': FieldValue.serverTimestamp(),
      'status': 'Diproses',
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _ordersSubscription?.cancel();
    super.dispose();
  }
}

final orderProvider =
    StateNotifierProvider<OrderNotifier, List<OrderModel>>((ref) {
  return OrderNotifier();
});
