import '/backend/backend.dart';
import '/components/contador_item_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

export 'products_page_model.dart';

class ProductsPageWidget extends StatefulWidget {
  const ProductsPageWidget({
    super.key,
    required this.vendedorID,
    required this.categoriaRef,
  });

  final String? vendedorID;
  final String? categoriaRef;

  static String routeName = 'ProductsPage';
  static String routePath = '/productsPage';

  @override
  State<ProductsPageWidget> createState() => _ProductsPageWidgetState();
}

class _ProductsPageWidgetState extends State<ProductsPageWidget> {
  late ProductsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductsPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

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
          backgroundColor: FlutterFlowTheme.of(context).primary,
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
              widget.categoriaRef,
              'Categoria',
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
              Expanded(
                child: StreamBuilder<List<ProductosRecord>>(
                  stream: queryProductosRecord(
                    queryBuilder: (productosRecord) => productosRecord.where(
                      'categoria_id',
                      isEqualTo: widget.categoriaRef,
                    ),
                  ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<ProductosRecord> listViewProductosRecordList =
                      snapshot.data!;
                  listViewProductosRecordList = listViewProductosRecordList
                      .where((p) => p.categoriaId == widget.categoriaRef)
                      .toList();

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewProductosRecordList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewProductosRecord =
                          listViewProductosRecordList[listViewIndex];
                      return Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    ProductDetailPageWidget.routeName,
                                    extra: <String, dynamic>{
                                      'productoDoc': listViewProductosRecord,
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          listViewProductosRecord.foto,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 80,
                                            height: 80,
                                            color: FlutterFlowTheme.of(context).alternate,
                                            child: Icon(
                                              Icons.image_not_supported_outlined,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listViewProductosRecord.nombre,
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.vollkornSc(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    fontSize: 16,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              formatNumber(
                                                listViewProductosRecord.precio,
                                                formatType: FormatType.decimal,
                                                decimalType: DecimalType.periodDecimal,
                                                currency: '\$',
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.vollkornSc(),
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    key: ValueKey(listViewProductosRecord.reference.id),
                                    child: wrapWithModel(
                                      model: _model.contadorItemModels.getModel(
                                        listViewProductosRecord.reference.id,
                                        listViewIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: ContadorItemWidget(
                                        key: Key('Keyfm9_${listViewProductosRecord.reference.id}'),
                                        productoActual: listViewProductosRecord.reference,
                                        precio: listViewProductosRecord.precio,
                                        foto: listViewProductosRecord.foto,
                                        nombre: listViewProductosRecord.nombre,
                                        codigo: listViewProductosRecord.codigo,
                                      ),
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      final cartIndex = functions.buscarIndiceProducto(
                                        FFAppState().carrito.toList(),
                                        listViewProductosRecord.reference,
                                      );
                                      return FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 8,
                                        buttonSize: 40,
                                        fillColor: Colors.transparent,
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: cartIndex != -1
                                              ? FlutterFlowTheme.of(context).error
                                              : FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          if (cartIndex != -1) {
                                            final itemToRemove = FFAppState().carrito.toList()[cartIndex];
                                            FFAppState().removeFromCarrito(itemToRemove);
                                            safeSetState(() {});
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: (i) async {
            if (i == 0) {
              await launchURL('https://www.instagram.com/component_yz');
            } else if (i == 1) {
              context.go('/');
            } else if (i == 2) {
              context.go('/?page=CartPage');
            }
          },
          backgroundColor: Colors.white,
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
