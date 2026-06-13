import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  const OrderModel({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.status,
    this.uid,
    this.deliveryMethod,
    this.paymentMethod,
    this.items = const [],
  });

  final String id;
  final DateTime date;
  final int totalPrice;
  final String status;
  final String? uid;
  final String? deliveryMethod;
  final String? paymentMethod;
  final List<Map<String, dynamic>> items;

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final rawItems = data['items'];
    return OrderModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] as num).toInt(),
      status: data['status'] as String,
      uid: data['uid'] as String?,
      deliveryMethod: data['deliveryMethod'] as String?,
      paymentMethod: data['paymentMethod'] as String?,
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
          : const [],
    );
  }
}
