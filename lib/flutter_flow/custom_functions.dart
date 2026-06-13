
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';

int buscarIndiceProducto(
  List<ItemCarritoStruct> listaCarrito,
  DocumentReference productoRef, [
  String talle = '',
  String color = '',
]) {
  // Si la lista está vacía, evitamos recorrerla y devolvemos -1 directamente
  if (listaCarrito.isEmpty) {
    return -1;
  }

  // Recorremos el carrito buscando el producto con el mismo talle y color
  for (int i = 0; i < listaCarrito.length; i++) {
    if (listaCarrito[i].productoRef?.path == productoRef.path &&
        listaCarrito[i].talle == talle &&
        listaCarrito[i].color == color) {
      return i; // Devolvemos el número entero del índice
    }
  }

  return -1; // Si no lo encuentra, devuelve -1 entero
}

String generarMensajeWhatsApp(
  List<dynamic> cartItems,
  String clientName,
  double totalOrder,
) {
  // 1. Cabecera del Mensaje
  String message = "📢 *NUEVO PEDIDO RECIBIDO*\n";
  message += "👤 *Cliente:* $clientName\n";
  message += "---------------------------------\n\n";
  message += "📦 *Detalle del Pedido:*\n";

  // 2. Bucle para agregar cada item del carrito
  for (var item in cartItems) {
    String name = 'Producto';
    int qty = 1;
    double price = 0.0;
    String codigo = '';
    String talle = '';
    String color = '';
    
    if (item is Map) {
      name = item['nombre'] ?? 'Producto';
      qty = item['cantidad'] ?? 1;
      price = (item['subtotal'] ?? ((item['precio'] ?? 0.0) * qty)).toDouble();
      codigo = item['codigo'] ?? '';
      talle = item['talle'] ?? '';
      color = item['color'] ?? '';
    } else {
      // Si es un struct o tipo de datos personalizado
      try {
        name = item.nombre ?? 'Producto';
      } catch (_) {}
      try {
        qty = item.cantidad ?? 1;
      } catch (_) {}
      try {
        price = ((item.precio ?? 0.0) * qty).toDouble();
      } catch (_) {}
      try {
        codigo = item.codigo ?? '';
      } catch (_) {}
      try {
        talle = item.talle ?? '';
      } catch (_) {}
      try {
        color = item.color ?? '';
      } catch (_) {}
    }
    
    String variantMsg = "";
    if (talle.isNotEmpty || color.isNotEmpty) {
      List<String> parts = [];
      if (talle.isNotEmpty) parts.add("Talle: $talle");
      if (color.isNotEmpty) parts.add("Color: $color");
      variantMsg = " (${parts.join(', ')})";
    }
    
    String codMsg = codigo.isNotEmpty ? "[$codigo] " : "";
    message += "• $qty x $codMsg*$name*$variantMsg - \$${price.toStringAsFixed(0)}\n";
  }

  // 3. Cierre y Total
  message += "\n---------------------------------\n";
  message += "💰 *TOTAL A PAGAR: \$${totalOrder.toStringAsFixed(0)}*\n\n";
  message += "💬 _Por favor, confírmeme la recepción del pedido para coordinar el pago y envío. ¡Gracias!_";

  // 4. URL Encoding obligatorio
  return Uri.encodeComponent(message);
}
