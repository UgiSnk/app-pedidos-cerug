import 'package:flutter/material.dart';
import '../backend/schema/structs/index.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  String _vendedorActual = 'vendedor_component';
  String get vendedorActual => _vendedorActual;
  set vendedorActual(String value) {
    _vendedorActual = value;
    notifyListeners();
  }

  List<ItemCarritoStruct> _carrito = [];
  List<ItemCarritoStruct> get carrito => _carrito;
  set carrito(List<ItemCarritoStruct> value) {
    _carrito = value;
    notifyListeners();
  }

  void addToCarrito(ItemCarritoStruct item) {
    _carrito.add(item);
    notifyListeners();
  }

  void removeFromCarrito(ItemCarritoStruct item) {
    _carrito.removeWhere((element) => element.productoRef?.path == item.productoRef?.path);
    notifyListeners();
  }

  void updateCarritoAtIndex(int index, Function(ItemCarritoStruct) updateFn) {
    if (index >= 0 && index < _carrito.length) {
      updateFn(_carrito[index]);
      notifyListeners();
    }
  }
}
