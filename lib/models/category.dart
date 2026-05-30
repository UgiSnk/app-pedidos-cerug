import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name;
  final String image;

  Category({
    required this.name,
    required this.image,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Category(
      name: data['nombre'] ?? doc.id,
      image: data['imagen'] ?? '',
    );
  }
}
