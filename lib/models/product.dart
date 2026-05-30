import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String photo;
  final String categoryId;
  final String description;
  final DocumentReference reference;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.photo,
    required this.categoryId,
    required this.description,
    required this.reference,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Product(
      id: doc.id,
      name: data['nombre'] ?? 'Producto',
      price: (data['precio'] ?? 0.0).toDouble(),
      photo: data['foto'] ?? '',
      categoryId: data['categoria_id'] ?? '',
      description: data['descripcion'] ?? '',
      reference: doc.reference,
    );
  }
}
