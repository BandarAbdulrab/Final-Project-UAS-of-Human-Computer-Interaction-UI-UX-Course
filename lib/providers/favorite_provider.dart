import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_provider.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier(this._ref)
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(const []) {
    _ref.listen(userProvider, (previous, next) {
      state = List<String>.from(next.favorites);
    });
    state = List<String>.from(_ref.read(userProvider).favorites);
  }

  final Ref _ref;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  bool isFavorite(String productId) => state.contains(productId);

  Future<void> toggle(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final removing = state.contains(productId);
    final previous = List<String>.from(state);

    state = removing
        ? state.where((id) => id != productId).toList()
        : [...state, productId];

    try {
      await _firestore.collection('users').doc(uid).update({
        'favorites': removing
            ? FieldValue.arrayRemove([productId])
            : FieldValue.arrayUnion([productId]),
      });
      _ref.read(userProvider.notifier).syncFavorites(state);
    } catch (_) {
      state = previous;
    }
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  return FavoriteNotifier(ref);
});
