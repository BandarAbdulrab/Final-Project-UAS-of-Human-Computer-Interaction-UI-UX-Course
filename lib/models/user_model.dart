import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.name,
    required this.phone,
    this.address = '',
    this.photoUrl = '',
    this.favorites = const [],
  });

  final String name;
  final String phone;
  final String address;
  final String photoUrl;
  final List<String> favorites;

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: _stringOrEmpty(data['name']),
      phone: _stringOrEmpty(data['phone']),
      address: _stringOrEmpty(data['address']),
      photoUrl: _stringOrEmpty(data['photoUrl']),
      favorites: _favoritesFromData(data['favorites']),
    );
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      return const UserModel(name: '', phone: '', address: '', photoUrl: '');
    }
    return UserModel.fromMap(data);
  }

  static String _stringOrEmpty(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static List<String> _favoritesFromData(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
      'favorites': favorites,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? photoUrl,
    List<String>? favorites,
  }) {
    return UserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      favorites: favorites ?? this.favorites,
    );
  }
}
