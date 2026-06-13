import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Helper to determine if Firebase is initialized.
const bool forceMockMode = false;
bool get isFirebaseInitialized => Firebase.apps.isNotEmpty && !forceMockMode;

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
  final int stock;
  final bool controlStock;

  ProductosRecord({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.foto,
    required this.categoriaId,
    required this.descripcion,
    required this.codigo,
    required this.reference,
    this.stock = 0,
    this.controlStock = false,
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
      stock: data['stock'] as int? ?? 0,
      controlStock: data['control_stock'] as bool? ?? false,
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
    id: 'vendedor_matias',
    nombre: 'Matias Cermesoni',
    miniatura: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq',
    telefono: '5491100000000',
    vendedorId: 'vendedor_matias',
  ),
  VendedoresRecord(
    id: 'vendedor_lucas',
    nombre: 'Lucas Ugolini',
    miniatura: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    telefono: '5491173564074',
    vendedorId: 'vendedor_lucas',
  ),
];

final List<CategoriasRecord> mockCategorias = [
  CategoriasRecord(
    id: 'Zapatillas',
    nombre: 'Zapatillas',
    imagen: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500',
  ),
  CategoriasRecord(
    id: 'Buzos',
    nombre: 'Buzos',
    imagen: 'https://images.unsplash.com/photo-1608063615781-e5ef77d3cf11?w=500',
  ),
];

final List<ProductosRecord> mockProductos = [
  ProductosRecord(
    id: 'zapatillas-deportivas-run',
    nombre: 'Zapatillas Deportivas Run',
    precio: 45000.0,
    foto: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
    categoriaId: 'Zapatillas',
    descripcion: 'Amortiguación reactiva y mesh transpirable',
    codigo: 'ZAP-RUN',
    stock: 15,
    controlStock: true,
    reference: MockDocumentReference('zapatillas-deportivas-run', 'productos/zapatillas-deportivas-run'),
  ),
  ProductosRecord(
    id: 'zapatillas-urbanas-street',
    nombre: 'Zapatillas Urbanas Street',
    precio: 52000.0,
    foto: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500',
    categoriaId: 'Zapatillas',
    descripcion: 'Diseño clásico retro en cuero sintético',
    codigo: 'ZAP-ST',
    stock: 8,
    controlStock: true,
    reference: MockDocumentReference('zapatillas-urbanas-street', 'productos/zapatillas-urbanas-street'),
  ),
  ProductosRecord(
    id: 'buzo-hoodie-over',
    nombre: 'Buzo Hoodie Over',
    precio: 38000.0,
    foto: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500',
    categoriaId: 'Buzos',
    descripcion: 'Algodón rústico oversize con capucha',
    codigo: 'BUZ-HO',
    stock: 12,
    controlStock: true,
    reference: MockDocumentReference('buzo-hoodie-over', 'productos/buzo-hoodie-over'),
  ),
  ProductosRecord(
    id: 'buzo-classic-crew',
    nombre: 'Buzo Classic Crew',
    precio: 32000.0,
    foto: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=500',
    categoriaId: 'Buzos',
    descripcion: 'Cuello redondo clásico de frisa invisible',
    codigo: 'BUZ-CL',
    stock: 20,
    controlStock: true,
    reference: MockDocumentReference('buzo-classic-crew', 'productos/buzo-classic-crew'),
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
    final list = snapshot.docs.map((doc) => VendedoresRecord.fromFirestore(doc)).toList();
    if (list.isEmpty) {
      return mockVendedores;
    }
    return list;
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
    final list = snapshot.docs.map((doc) => CategoriasRecord.fromFirestore(doc)).toList();
    if (list.isEmpty) {
      return mockCategorias;
    }
    return list;
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
    final list = snapshot.docs.map((doc) => ProductosRecord.fromFirestore(doc)).toList();
    if (list.isEmpty) {
      return mockProductos;
    }
    return list;
  });
}
