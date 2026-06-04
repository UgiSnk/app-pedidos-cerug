import '/backend/backend.dart';
import '/components/contador_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'cart_page_model.dart';
export 'cart_page_model.dart';

class CartPageWidget extends StatefulWidget {
  const CartPageWidget({super.key});

  static String routeName = 'CartPage';
  static String routePath = '/cartPage';

  @override
  State<CartPageWidget> createState() => _CartPageWidgetState();
}

class _CartPageWidgetState extends State<CartPageWidget> {
  late CartPageModel _model;
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartPageModel());
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF111111),
              size: 30,
            ),
            onPressed: () async {
              context.go('/');
            },
          ),
          title: Text(
            'Carrito',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.lora(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: const Color(0xFF111111),
                  fontSize: 22,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<List<VendedoresRecord>>(
            stream: queryVendedoresRecord(
              queryBuilder: (vendedoresRecord) => vendedoresRecord.where(
                'vendedor_id',
                isEqualTo: FFAppState().vendedorActual,
              ),
              singleRecord: true,
            ),
            builder: (context, snapshot) {
              final vendedores = snapshot.data ?? [];
              final vendedor = vendedores.isNotEmpty ? vendedores.first : null;

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final itemCarrito = FFAppState().carrito.toList();

                        if (itemCarrito.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'Tu carrito está vacío',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.vollkornSc(),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                    ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: itemCarrito.length,
                          itemBuilder: (context, itemCarritoIndex) {
                            final itemCarritoItem = itemCarrito[itemCarritoIndex];
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          itemCarritoItem.imagen,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 50,
                                            height: 50,
                                            color: FlutterFlowTheme.of(context).alternate,
                                            child: Icon(
                                              Icons.image_not_supported_outlined,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                valueOrDefault<String>(
                                                  itemCarritoItem.nombre.isNotEmpty
                                                      ? itemCarritoItem.nombre
                                                      : 'Producto',
                                                  'Producto',
                                                ),
                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                      font: GoogleFonts.vollkornSc(),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Cant: ${itemCarritoItem.cantidad}  |  ${formatNumber(
                                                  itemCarritoItem.precio,
                                                  formatType: FormatType.decimal,
                                                  decimalType: DecimalType.periodDecimal,
                                                  currency: '\$',
                                                )}',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.vollkornSc(),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ContadorItemWidget(
                                        key: ValueKey(itemCarritoItem.productoRef?.path),
                                        productoActual: itemCarritoItem.productoRef,
                                        precio: itemCarritoItem.precio,
                                        foto: itemCarritoItem.imagen,
                                        nombre: itemCarritoItem.nombre,
                                        codigo: itemCarritoItem.codigo,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (FFAppState().carrito.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, -2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre del Cliente',
                                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                    hintText: 'Ingresa tu nombre...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Por favor ingresa tu nombre';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                            font: GoogleFonts.vollkornSc(),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      formatNumber(
                                        FFAppState().carrito.fold<double>(0.0, (sum, item) => sum + (item.precio * item.cantidad)),
                                        formatType: FormatType.decimal,
                                        decimalType: DecimalType.periodDecimal,
                                        currency: '\$',
                                      ),
                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                            font: GoogleFonts.vollkornSc(),
                                            color: FlutterFlowTheme.of(context).primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            final clientName = _nameController.text.trim();
                                            final subtotal = FFAppState().carrito.fold<double>(0.0, (sum, item) => sum + (item.precio * item.cantidad));

                                            final cartList = FFAppState().carrito.map((item) {
                                              return {
                                                'nombre': item.nombre.isNotEmpty ? item.nombre : 'Producto',
                                                'cantidad': item.cantidad,
                                                'precio': item.precio,
                                                'subtotal': item.precio * item.cantidad,
                                                'codigo': item.codigo,
                                              };
                                            }).toList();

                                            final message = functions.generarMensajeWhatsApp(
                                              cartList,
                                              clientName,
                                              subtotal,
                                            );

                                            final rawPhone = vendedor?.telefono ?? '5491173564074';
                                            final cleanPhone = rawPhone.replaceAll(RegExp(r'\D'), '');
                                            final telefonoDestino = cleanPhone.isNotEmpty ? cleanPhone : '5491173564074';
                                            final waUrl = 'https://wa.me/$telefonoDestino?text=$message';

                                            await launchURL(waUrl);
                                          }
                                        },
                                        text: 'Confirmar por WhatsApp',
                                        options: FFButtonOptions(
                                          height: 44,
                                          color: const Color(0xFF25D366),
                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                font: GoogleFonts.vollkornSc(),
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        var confirmDialogResponse = await showDialog<bool>(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: const Text('¿Vaciar carrito?'),
                                                  content: const Text('¿Estás seguro de que querés vaciar todos los productos?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                                      child: const Text('Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                                      child: const Text('Confirmar'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ) ??
                                            false;
                                        if (confirmDialogResponse) {
                                          FFAppState().carrito = [];
                                          safeSetState(() {});
                                        }
                                      },
                                      text: 'Vaciar Carrito',
                                      options: FFButtonOptions(
                                        height: 44,
                                        color: FlutterFlowTheme.of(context).alternate,
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                              font: GoogleFonts.vollkornSc(),
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
