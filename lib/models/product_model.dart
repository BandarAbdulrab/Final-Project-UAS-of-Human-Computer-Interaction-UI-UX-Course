import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String imageUrl;

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      price: (data['price'] as num).toInt(),
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
