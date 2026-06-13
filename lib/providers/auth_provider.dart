import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String firebaseAuthErrorMessage(
  FirebaseAuthException exception, {
  required bool isEnglish,
}) {
  switch (exception.code) {
    case 'wrong-password':
    case 'invalid-credential':
      return isEnglish
          ? 'Incorrect email or password'
          : 'Email atau kata sandi salah';
    case 'user-not-found':
      return isEnglish ? 'Account not found' : 'Akun tidak ditemukan';
    case 'email-already-in-use':
      return isEnglish ? 'Email is already registered' : 'Email sudah terdaftar';
    case 'invalid-email':
      return isEnglish ? 'Invalid email format' : 'Format email tidak valid';
    case 'weak-password':
      return isEnglish
          ? 'Password is too weak (minimum 6 characters)'
          : 'Kata sandi terlalu lemah (minimal 6 karakter)';
    case 'too-many-requests':
      return isEnglish
          ? 'Too many attempts. Please try again later'
          : 'Terlalu banyak percobaan. Coba lagi nanti';
    case 'network-request-failed':
      return isEnglish
          ? 'Connection failed. Check your network'
          : 'Koneksi gagal. Periksa jaringan Anda';
    case 'operation-not-allowed':
      return isEnglish
          ? 'This sign-in method is not allowed'
          : 'Metode masuk ini tidak diizinkan';
    default:
      return exception.message ??
          (isEnglish
              ? 'An error occurred. Please try again'
              : 'Terjadi kesalahan. Silakan coba lagi');
  }
}

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthNotifier extends StateNotifier<void> {
  AuthNotifier({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(null);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user!.uid;
    await _firestore.collection('users').doc(uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
      'photoUrl': '',
      'favorites': <String>[],
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, void>((ref) {
  return AuthNotifier();
});
