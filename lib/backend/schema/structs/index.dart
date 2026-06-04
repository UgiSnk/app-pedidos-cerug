import 'package:cloud_firestore/cloud_firestore.dart';

class ItemCarritoStruct {
  DocumentReference? productoRef;
  int cantidad;
  double precio;
  String imagen;
  String nombre;
  String codigo;

  ItemCarritoStruct({
    this.productoRef,
    this.cantidad = 1,
    this.precio = 0.0,
    this.imagen = '',
    this.nombre = '',
    this.codigo = '',
  });

  void incrementCantidad(int value) {
    cantidad += value;
  }

  Map<String, dynamic> toMap() {
    return {
      'productoRef': productoRef,
      'cantidad': cantidad,
      'precio': precio,
      'imagen': imagen,
      'nombre': nombre,
      'codigo': codigo,
    };
  }

  factory ItemCarritoStruct.fromMap(Map<String, dynamic> data) {
    return ItemCarritoStruct(
      productoRef: data['productoRef'] as DocumentReference?,
      cantidad: data['cantidad'] as int? ?? 1,
      precio: (data['precio'] as num? ?? 0.0).toDouble(),
      imagen: data['imagen'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      codigo: data['codigo'] as String? ?? '',
    );
  }
}
