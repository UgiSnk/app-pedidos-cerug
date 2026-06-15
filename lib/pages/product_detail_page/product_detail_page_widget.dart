import '/backend/backend.dart';
import '/components/contador_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_detail_page_model.dart';
export 'product_detail_page_model.dart';

class ProductDetailPageWidget extends StatefulWidget {
  const ProductDetailPageWidget({
    super.key,
    required this.productoDoc,
  });

  final ProductosRecord? productoDoc;

  static String routeName = 'ProductDetailPage';
  static String routePath = '/productDetailPage';

  @override
  State<ProductDetailPageWidget> createState() =>
      _ProductDetailPageWidgetState();
}

class _ProductDetailPageWidgetState extends State<ProductDetailPageWidget> {
  late ProductDetailPageModel _model;
  String selectedTalle = 'M';
  String selectedColor = 'Negro';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            valueOrDefault<String>(
              widget.productoDoc?.nombre,
              'detalle',
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.lora(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.productoDoc!.foto,
                    width: MediaQuery.sizeOf(context).width,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 300,
                      color: FlutterFlowTheme.of(context).alternate,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                valueOrDefault<String>(
                  widget.productoDoc?.nombre,
                  'Nombre',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.vollkornSc(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                formatNumber(
                  widget.productoDoc!.precio,
                  formatType: FormatType.decimal,
                  decimalType: DecimalType.periodDecimal,
                  currency: '\$',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.vollkornSc(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              Text(
                valueOrDefault<String>(
                  widget.productoDoc?.descripcion,
                  'Descripcion',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.vollkornSc(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
              const SizedBox(height: 16),
              if (widget.productoDoc!.controlStock)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.productoDoc!.stock <= 0
                        ? '❌ AGOTADO'
                        : '📦 Stock disponible: ${widget.productoDoc!.stock}',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.vollkornSc(
                            fontWeight: FontWeight.bold,
                            color: widget.productoDoc!.stock <= 0
                                ? Colors.red
                                : FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                  ),
                ),
              const SizedBox(height: 16),
              if (widget.productoDoc!.stock > 0 || !widget.productoDoc!.controlStock)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Talle',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.vollkornSc(fontWeight: FontWeight.bold),
                                  ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: selectedTalle,
                              dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: <String>['S', 'M', 'L', 'XL', 'XXL']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                safeSetState(() {
                                  selectedTalle = newValue ?? 'M';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Color',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.vollkornSc(fontWeight: FontWeight.bold),
                                  ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: selectedColor,
                              dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: <String>['Negro', 'Blanco', 'Gris', 'Azul']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                safeSetState(() {
                                  selectedColor = newValue ?? 'Negro';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              if (widget.productoDoc!.stock > 0 || !widget.productoDoc!.controlStock)
                wrapWithModel(
                  model: _model.contadorItemModel,
                  updateCallback: () => safeSetState(() {}),
                  child: ContadorItemWidget(
                    productoActual: widget.productoDoc!.reference,
                    precio: widget.productoDoc!.precio,
                    foto: widget.productoDoc!.foto,
                    nombre: widget.productoDoc!.nombre,
                    codigo: widget.productoDoc!.codigo,
                    talle: selectedTalle,
                    color: selectedColor,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'PRODUCTO AGOTADO',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.vollkornSc(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: (i) async {
            if (i == 0) {
              await launchURL('https://www.instagram.com/cerug');
            } else if (i == 1) {
              context.go('/');
            } else if (i == 2) {
              context.go('/?page=CartPage');
            }
          },
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              activeIcon: Icon(Icons.camera_alt_rounded),
              label: 'Instagram',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Categorías',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart_rounded),
              label: 'Carrito',
            ),
          ],
        ),
      ),
    );
  }
}
