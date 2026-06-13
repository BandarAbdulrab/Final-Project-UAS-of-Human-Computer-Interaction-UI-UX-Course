import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(const UserModel(
          name: '',
          phone: '',
          address: '',
          photoUrl: '',
          favorites: [],
        )) {
    _subscription = _auth.authStateChanges().listen(_onAuthChanged);
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _loadUser(currentUser.uid);
    }
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _subscription;

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      state = const UserModel(
        name: '',
        phone: '',
        address: '',
        photoUrl: '',
        favorites: [],
      );
      return;
    }
    await _loadUser(user.uid);
  }

  Future<void> _loadUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      state = const UserModel(
        name: '',
        phone: '',
        address: '',
        photoUrl: '',
        favorites: [],
      );
      return;
    }

    state = UserModel.fromFirestore(doc);
  }

  Future<void> updateAddress(String address) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    await _firestore.collection('users').doc(uid).update({
      'address': address,
    });
    state = state.copyWith(address: address);
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String photoUrl,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
    });
    state = state.copyWith(
      name: name,
      phone: phone,
      address: address,
      photoUrl: photoUrl,
    );
  }

  void syncFavorites(List<String> favorites) {
    state = state.copyWith(favorites: favorites);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});
