import '/backend/schema/structs/index.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'contador_item_model.dart';
export 'contador_item_model.dart';

class ContadorItemWidget extends StatefulWidget {
  const ContadorItemWidget({
    super.key,
    required this.productoActual,
    this.precio,
    this.nombre,
    this.foto,
  });

  final DocumentReference? productoActual;
  final double? precio;
  final String? nombre;
  final String? foto;

  @override
  State<ContadorItemWidget> createState() => _ContadorItemWidgetState();
}

class _ContadorItemWidgetState extends State<ContadorItemWidget> {
  late ContadorItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContadorItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // Synchronize countControllerValue with actual cart quantity in real-time
    if (widget.productoActual != null) {
      final cartIndex = functions.buscarIndiceProducto(
          FFAppState().carrito.toList(), widget.productoActual!);
      _model.countControllerValue = cartIndex != -1
          ? FFAppState().carrito[cartIndex].cantidad
          : 0;
    }

    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle,
      ),
      child: FlutterFlowCountController(
        decrementIconBuilder: (enabled) => Icon(
          Icons.remove_rounded,
          color: enabled
              ? FlutterFlowTheme.of(context).secondaryText
              : FlutterFlowTheme.of(context).alternate,
          size: 24,
        ),
        incrementIconBuilder: (enabled) => Icon(
          Icons.add_rounded,
          color: enabled
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).alternate,
          size: 24,
        ),
        countBuilder: (count) => Text(
          count.toString(),
          style: FlutterFlowTheme.of(context).titleLarge.override(
                font: GoogleFonts.vollkornSc(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).titleLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
              ),
        ),
        count: _model.countControllerValue ??= 0,
        updateCount: (count) async {
          safeSetState(() => _model.countControllerValue = count);
          int index = functions.buscarIndiceProducto(
              FFAppState().carrito.toList(), widget.productoActual!);
          
          final prod = getProductByRef(widget.productoActual!);
          final double precio = widget.precio ?? prod?.precio ?? 0.0;
          final String foto = widget.foto ?? prod?.foto ?? '';

          if (index == -1) {
            if (count > 0) {
              FFAppState().addToCarrito(ItemCarritoStruct(
                productoRef: widget.productoActual,
                cantidad: count,
                precio: precio,
                imagen: foto,
              ));
              safeSetState(() {});
            }
          } else {
            if (count > 0) {
              FFAppState().updateCarritoAtIndex(
                index,
                (e) {
                  e.cantidad = count;
                  e.precio = precio;
                  e.imagen = foto;
                },
              );
              safeSetState(() {});
            } else {
              var itemToRemove = FFAppState().carrito.toList()[index];
              FFAppState().removeFromCarrito(itemToRemove);
              safeSetState(() {});
            }
          }
        },
        stepSize: 1,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
      ),
    );
  }
}
