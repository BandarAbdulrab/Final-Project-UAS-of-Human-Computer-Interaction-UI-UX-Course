import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

const _seedProducts = [
  Product(
    id: '1',
    name: 'Panadol Biru',
    category: 'Obat Flu',
    price: 12174,
    description: 'Obat untuk meredakan demam dan nyeri.',
    imageUrl: 'assets/images/panadol.png',
  ),
  Product(
    id: '2',
    name: 'Mixagrip Flu & Batuk',
    category: 'Obat Flu',
    price: 4276,
    description: 'Obat flu dan batuk untuk meredakan gejala pilek.',
    imageUrl: 'assets/images/mixagrip.png',
  ),
  Product(
    id: '3',
    name: 'Panadol Extra',
    category: 'Obat Flu',
    price: 10925,
    description:
        'Obat yang digunakan untuk meredakan demam dan rasa nyeri atau sakit kepala.',
    imageUrl: 'assets/images/panadol_extra.png',
  ),
  Product(
    id: '4',
    name: 'Sanmol Sirup',
    category: 'Obat Flu',
    price: 35000,
    description: 'Sirup penurun demam dan pereda nyeri untuk anak.',
    imageUrl: 'assets/images/sanmol.png',
  ),
  Product(
    id: '5',
    name: 'Beworths Multivitamin',
    category: 'Vitamin',
    price: 102704,
    description: 'Suplemen kesehatan untuk menjaga daya tahan tubuh.',
    imageUrl: 'assets/images/beworths.png',
  ),
  Product(
    id: '6',
    name: 'Enervon-C',
    category: 'Vitamin',
    price: 45000,
    description: 'Vitamin C untuk meningkatkan daya tahan tubuh.',
    imageUrl: 'assets/images/enervon.png',
  ),
];

Future<void> seedProductsIfEmpty(FirebaseFirestore firestore) async {
  final snapshot = await firestore.collection('products').limit(1).get();
  if (snapshot.docs.isNotEmpty) return;

  final batch = firestore.batch();
  for (final product in _seedProducts) {
    final docRef = firestore.collection('products').doc(product.id);
    batch.set(docRef, product.toFirestore());
  }
  await batch.commit();
}

Stream<List<Product>> _productsStream(FirebaseFirestore firestore) async* {
  await seedProductsIfEmpty(firestore);
  yield* firestore.collection('products').snapshots().map(
        (snapshot) => snapshot.docs.map(Product.fromFirestore).toList(),
      );
}

const _appendProducts = [
  Product(
    id: 'new_prod_1',
    name: 'Promag',
    category: 'Pencernaan',
    price: 18500,
    description: 'Obat maag dan gangguan pencernaan akibat asam lambung berlebih.',
    imageUrl: 'assets/images/promag.png',
  ),
  Product(
    id: 'new_prod_2',
    name: 'Polysilane',
    category: 'Pencernaan',
    price: 32000,
    description: 'Obat pelindung lambung untuk mengatasi nyeri ulu hati dan maag.',
    imageUrl: 'assets/images/polysilane.png',
  ),
  Product(
    id: 'new_prod_3',
    name: 'Entrostop',
    category: 'Pencernaan',
    price: 12500,
    description: 'Obat antidiare untuk menghentikan diare akut.',
    imageUrl: 'assets/images/entrostop.png',
  ),
  Product(
    id: 'new_prod_4',
    name: 'Tensimeter Digital',
    category: 'Alat Kesehatan',
    price: 285000,
    description: 'Alat pengukur tekanan darah digital dengan layar LCD.',
    imageUrl: 'assets/images/tensimeter.png',
  ),
  Product(
    id: 'new_prod_5',
    name: 'Termometer Digital',
    category: 'Alat Kesehatan',
    price: 75000,
    description: 'Termometer digital untuk mengukur suhu tubuh dengan cepat.',
    imageUrl: 'assets/images/termometer.png',
  ),
  Product(
    id: 'new_prod_6',
    name: 'Masker Medis (50 pcs)',
    category: 'Alat Kesehatan',
    price: 35000,
    description: 'Masker medis 3 lapis untuk perlindungan sehari-hari.',
    imageUrl: 'assets/images/masker.png',
  ),
];

Future<void> appendNewProducts({FirebaseFirestore? firestore}) async {
  final db = firestore ?? FirebaseFirestore.instance;

  final batch = db.batch();
  var hasWrites = false;

  for (final product in _appendProducts) {
    final docRef = db.collection('products').doc(product.id);
    final snapshot = await docRef.get();
    if (snapshot.exists) continue;

    batch.set(docRef, product.toFirestore());
    hasWrites = true;
  }

  if (hasWrites) {
    await batch.commit();
  }
}

final productProvider = StreamProvider<List<Product>>((ref) {
  return _productsStream(FirebaseFirestore.instance);
});
