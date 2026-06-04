import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Helper to determine if Firebase is initialized.
bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

class VendedoresRecord {
  final String id;
  final String nombre;
  final String miniatura;
  final String telefono;
  final String vendedorId;

  VendedoresRecord({
    required this.id,
    required this.nombre,
    required this.miniatura,
    required this.telefono,
    required this.vendedorId,
  });

  factory VendedoresRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return VendedoresRecord(
      id: doc.id,
      nombre: data['nombre'] ?? 'Vendedor',
      miniatura: data['miniatura'] ?? '',
      telefono: data['telefono'] ?? '',
      vendedorId: data['vendedor_id'] ?? '',
    );
  }
}

class CategoriasRecord {
  final String id;
  final String nombre;
  final String imagen;

  CategoriasRecord({
    required this.id,
    required this.nombre,
    required this.imagen,
  });

  factory CategoriasRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CategoriasRecord(
      id: doc.id,
      nombre: data['nombre'] ?? doc.id,
      imagen: data['imagen'] ?? '',
    );
  }
}

class ProductosRecord {
  final String id;
  final String nombre;
  final double precio;
  final String foto;
  final String categoriaId;
  final String descripcion;
  final String codigo;
  final DocumentReference reference;

  ProductosRecord({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.foto,
    required this.categoriaId,
    required this.descripcion,
    required this.codigo,
    required this.reference,
  });

  factory ProductosRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductosRecord(
      id: doc.id,
      nombre: data['nombre'] ?? 'Producto',
      precio: (data['precio'] ?? 0.0).toDouble(),
      foto: data['foto'] ?? '',
      categoriaId: data['categoria_id'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      reference: doc.reference,
    );
  }
}

// Mock DocumentReference for when Firebase is not initialized
// ignore: subtype_of_sealed_class
class MockDocumentReference implements DocumentReference<Map<String, dynamic>> {
  @override
  final String id;
  @override
  final String path;

  MockDocumentReference(this.id, this.path);

  @override
  CollectionReference<Map<String, dynamic>> get parent => throw UnimplementedError();

  @override
  FirebaseFirestore get firestore => throw UnimplementedError();

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) => throw UnimplementedError();

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) => throw UnimplementedError();

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource source = ListenSource.defaultSource,
  }) => throw UnimplementedError();

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) => throw UnimplementedError();

  @override
  Future<void> update(Map<Object, Object?> data) => throw UnimplementedError();

  @override
  Future<void> delete() => throw UnimplementedError();

  @override
  DocumentReference<R> withConverter<R>({
    required FromFirestore<R> fromFirestore,
    required ToFirestore<R> toFirestore,
  }) {
    throw UnimplementedError();
  }
}

// Mock Data definitions using Googleusercontent cache endpoint (bypasses Google Drive download block and CORS issues)
final List<VendedoresRecord> mockVendedores = [
  VendedoresRecord(
    id: 'vendedor_component',
    nombre: 'Component New House',
    miniatura: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq',
    telefono: '5491173564074',
    vendedorId: 'vendedor_component',
  ),
];

final List<CategoriasRecord> mockCategorias = [
  CategoriasRecord(
    id: 'Velas',
    nombre: 'Velas',
    imagen: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq',
  ),
  CategoriasRecord(
    id: 'Vidrios',
    nombre: 'Vidrios',
    imagen: 'https://lh3.googleusercontent.com/d/1ebuXB_EbgPhsZefF7RiE0FRLKEAP3raC',
  ),
];

final List<ProductosRecord> mockProductos = [
  // Category: Velas
  ProductosRecord(
    id: 'Vela Grande Blanco',
    nombre: 'Vela Grande Blanco',
    precio: 22000.0,
    foto: 'https://lh3.googleusercontent.com/d/1ljXdhXarysJ4_MpUwdWYg9RuyAKDRjUK',
    categoriaId: 'Velas',
    descripcion: 'Medida 18x10',
    codigo: 'VEL-GR-BL',
    reference: MockDocumentReference('Vela Grande Blanco', 'productos/Vela Grande Blanco'),
  ),
  ProductosRecord(
    id: 'Vela Grande Negro',
    nombre: 'Vela Grande Negro',
    precio: 22000.0,
    foto: 'https://lh3.googleusercontent.com/d/19p6ToRtzfrPeHGZ9xZ-AD0KwfeiY3XH-',
    categoriaId: 'Velas',
    descripcion: 'Medida 18x10',
    codigo: 'VEL-GR-NE',
    reference: MockDocumentReference('Vela Grande Negro', 'productos/Vela Grande Negro'),
  ),
  ProductosRecord(
    id: 'Vela Grande Verde',
    nombre: 'Vela Grande Verde',
    precio: 22000.0,
    foto: 'https://lh3.googleusercontent.com/d/13beVbgzBrbxs3INV-852e37rsnkzsFW-',
    categoriaId: 'Velas',
    descripcion: 'Medida 18x10',
    codigo: 'VEL-GR-VE',
    reference: MockDocumentReference('Vela Grande Verde', 'productos/Vela Grande Verde'),
  ),
  ProductosRecord(
    id: 'Vela XL Blanco',
    nombre: 'Vela XL Blanco',
    precio: 25000.0,
    foto: 'https://lh3.googleusercontent.com/d/1ZyGz0Cymz-1jupj0mMTj8zVpOBt7QY_C',
    categoriaId: 'Velas',
    descripcion: 'Medida 25x10',
    codigo: 'VEL-XL-BL',
    reference: MockDocumentReference('Vela XL Blanco', 'productos/Vela XL Blanco'),
  ),
  ProductosRecord(
    id: 'Vela XL Negro',
    nombre: 'Vela XL Negro',
    precio: 25000.0,
    foto: 'https://lh3.googleusercontent.com/d/1MDjZsrFP_BBMzb6HzbdPOWkzoSG0ard0',
    categoriaId: 'Velas',
    descripcion: 'Medida 25x10',
    codigo: 'VEL-XL-NE',
    reference: MockDocumentReference('Vela XL Negro', 'productos/Vela XL Negro'),
  ),
  ProductosRecord(
    id: 'Vela XL Verde',
    nombre: 'Vela XL Verde',
    precio: 25000.0,
    foto: 'https://lh3.googleusercontent.com/d/1DMnd1n4iJKvbZk6S4GN6Xq0NJ8RIfByc',
    categoriaId: 'Velas',
    descripcion: 'Medida 25x10',
    codigo: 'VEL-XL-VE',
    reference: MockDocumentReference('Vela XL Verde', 'productos/Vela XL Verde'),
  ),
  ProductosRecord(
    id: 'Vela XXL Blanco',
    nombre: 'Vela XXL Blanco',
    precio: 28000.0,
    foto: 'https://lh3.googleusercontent.com/d/1KIJ9KKdaMylPUTSEVXfhjTNKB5kWgVW8',
    categoriaId: 'Velas',
    descripcion: 'Medida 15x17',
    codigo: 'VEL-XXL-BL',
    reference: MockDocumentReference('Vela XXL Blanco', 'productos/Vela XXL Blanco'),
  ),
  ProductosRecord(
    id: 'Vela XXL Negro',
    nombre: 'Vela XXL Negro',
    precio: 28000.0,
    foto: 'https://lh3.googleusercontent.com/d/1IDQVzbuaUoHKwUtOf0PZNRmsdAoKvShG',
    categoriaId: 'Velas',
    descripcion: 'Medida 15x17',
    codigo: 'VEL-XXL-NE',
    reference: MockDocumentReference('Vela XXL Negro', 'productos/Vela XXL Negro'),
  ),
  ProductosRecord(
    id: 'Vela XXL Verde',
    nombre: 'Vela XXL Verde',
    precio: 28000.0,
    foto: 'https://lh3.googleusercontent.com/d/1WAKDunDwINTxXP_ac_PQeCoaUK_sukOV',
    categoriaId: 'Velas',
    descripcion: 'Medida 15x17',
    codigo: 'VEL-XXL-VE',
    reference: MockDocumentReference('Vela XXL Verde', 'productos/Vela XXL Verde'),
  ),
  ProductosRecord(
    id: 'Vaso chico con vela',
    nombre: 'Vaso chico con vela',
    precio: 32000.0,
    foto: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq',
    categoriaId: 'Velas',
    descripcion: '',
    codigo: 'VAS-CH',
    reference: MockDocumentReference('Vaso chico con vela', 'productos/Vaso chico con vela'),
  ),
  ProductosRecord(
    id: 'Vaso grande con vela',
    nombre: 'Vaso grande con vela',
    precio: 50000.0,
    foto: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq',
    categoriaId: 'Velas',
    descripcion: '',
    codigo: 'VAS-GR',
    reference: MockDocumentReference('Vaso grande con vela', 'productos/Vaso grande con vela'),
  ),

  // Category: Vidrios
  ProductosRecord(
    id: 'Vidrio 1',
    nombre: 'Vidrio 1',
    precio: 25000.0,
    foto: 'https://lh3.googleusercontent.com/d/11oF3-k-tSV7FZZz9oI3RDkMrXF4VkI8b',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-01',
    reference: MockDocumentReference('Vidrio 1', 'productos/Vidrio 1'),
  ),
  ProductosRecord(
    id: 'Vidrio 2',
    nombre: 'Vidrio 2',
    precio: 25000.0,
    foto: 'https://lh3.googleusercontent.com/d/1JN0g9JRX2A74qKVDP70hiZrsC36diV4j',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-02',
    reference: MockDocumentReference('Vidrio 2', 'productos/Vidrio 2'),
  ),
  ProductosRecord(
    id: 'Vidrio 3',
    nombre: 'Vidrio 3',
    precio: 28000.0,
    foto: 'https://lh3.googleusercontent.com/d/1lkkB3V5tNpzJbJmrZtcUkR8FiMDtEI3H',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-03',
    reference: MockDocumentReference('Vidrio 3', 'productos/Vidrio 3'),
  ),
  ProductosRecord(
    id: 'Vidrio 4',
    nombre: 'Vidrio 4',
    precio: 28000.0,
    foto: 'https://lh3.googleusercontent.com/d/1rTzwMQBTuWG8QMII4m2OvQXWyAKXvCCu',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-04',
    reference: MockDocumentReference('Vidrio 4', 'productos/Vidrio 4'),
  ),
  ProductosRecord(
    id: 'Vidrio 5',
    nombre: 'Vidrio 5',
    precio: 28000.0,
    foto: 'https://lh3.googleusercontent.com/d/1h4WXu0gKNpoAraSkcGSGJS61Lp-vJ-Lh',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-05',
    reference: MockDocumentReference('Vidrio 5', 'productos/Vidrio 5'),
  ),
  ProductosRecord(
    id: 'Vidrio 6',
    nombre: 'Vidrio 6',
    precio: 32000.0,
    foto: 'https://lh3.googleusercontent.com/d/1RE3w4WGCl8n9qj1UXUA4SZGzDQuuBWCp',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-06',
    reference: MockDocumentReference('Vidrio 6', 'productos/Vidrio 6'),
  ),
  ProductosRecord(
    id: 'Vidrio 7',
    nombre: 'Vidrio 7',
    precio: 50000.0,
    foto: 'https://lh3.googleusercontent.com/d/1SENQbB7MMbJz5IDNsg7cXlaeNpgYXHWO',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-07',
    reference: MockDocumentReference('Vidrio 7', 'productos/Vidrio 7'),
  ),
  ProductosRecord(
    id: 'Vidrio 8',
    nombre: 'Vidrio 8',
    precio: 50000.0,
    foto: 'https://lh3.googleusercontent.com/d/1HWGPGJvXRpjCSE1MTSW6tBuGgf3NjMMu',
    categoriaId: 'Vidrios',
    descripcion: '',
    codigo: 'VID-08',
    reference: MockDocumentReference('Vidrio 8', 'productos/Vidrio 8'),
  ),
];

// Look up a product in the mock catalog by its reference path
ProductosRecord? getProductByRef(DocumentReference ref) {
  try {
    return mockProductos.firstWhere((p) => p.reference.path == ref.path);
  } catch (e) {
    return null;
  }
}

Stream<List<VendedoresRecord>> queryVendedoresRecord({
  Query Function(Query)? queryBuilder,
  bool singleRecord = false,
}) {
  if (!isFirebaseInitialized) {
    return Stream.value(mockVendedores);
  }

  Query query = FirebaseFirestore.instance.collection('vendedores');
  if (queryBuilder != null) {
    query = queryBuilder(query);
  }
  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => VendedoresRecord.fromFirestore(doc)).toList();
  });
}

Stream<List<CategoriasRecord>> queryCategoriasRecord() {
  if (!isFirebaseInitialized) {
    return Stream.value(mockCategorias);
  }

  return FirebaseFirestore.instance
      .collection('categorias')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => CategoriasRecord.fromFirestore(doc)).toList();
  });
}

Stream<List<ProductosRecord>> queryProductosRecord({
  Query Function(Query)? queryBuilder,
}) {
  if (!isFirebaseInitialized) {
    List<ProductosRecord> filtered = mockProductos;
    return Stream.value(filtered);
  }

  Query query = FirebaseFirestore.instance.collection('productos');
  if (queryBuilder != null) {
    query = queryBuilder(query);
  }
  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => ProductosRecord.fromFirestore(doc)).toList();
  });
}
