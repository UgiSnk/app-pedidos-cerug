import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String id;
  final String name;
  final String miniature;
  final String phone;

  Seller({
    required this.id,
    required this.name,
    required this.miniature,
    required this.phone,
  });

  factory Seller.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Seller(
      id: doc.id,
      name: data['nombre'] ?? 'Vendedor',
      miniature: data['miniatura'] ?? '',
      phone: data['telefono'] ?? '',
    );
  }
}
