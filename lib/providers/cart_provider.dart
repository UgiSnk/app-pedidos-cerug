import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addToCart(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int getProductQuantity(Product product) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }

  String generateWhatsAppMessage(String clientName) {
    String message = "📢 *NUEVO PEDIDO RECIBIDO - CERUG*\n";
    message += "👤 *Cliente:* $clientName\n";
    message += "---------------------------------\n\n";
    message += "📦 *Detalle del Pedido:*\n";

    for (var item in _items) {
      message += "• ${item.quantity} x *${item.product.name}* - \$${item.subtotal.toStringAsFixed(2)} USD\n";
    }

    message += "\n---------------------------------\n";
    message += "💰 *TOTAL A PAGAR: \$${totalAmount.toStringAsFixed(2)} USD*\n\n";
    message += "💬 _Por favor, confírmeme la recepción del pedido para coordinar el pago y envío. ¡Gracias!_";

    return Uri.encodeComponent(message);
  }
}
