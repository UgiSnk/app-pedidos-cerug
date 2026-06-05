import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({
    super.key,
    this.vendedorID,
  });

  final String? vendedorID;

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _searchText = '';
  String _selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().vendedorActual = widget.vendedorID!;
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<VendedoresRecord>>(
      stream: queryVendedoresRecord(
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<VendedoresRecord> homePageVendedoresRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (homePageVendedoresRecordList.isEmpty) {
          return Container();
        }
        final targetVendedorId = widget.vendedorID ?? 'vendedor_component';
        debugPrint('HOMEPAGE_DEBUG: targetVendedorId=$targetVendedorId');
        debugPrint('HOMEPAGE_DEBUG: list=${homePageVendedoresRecordList.map((v) => "${v.id}:${v.nombre}").toList()}');
        VendedoresRecord? homePageVendedoresRecord;
        try {
          homePageVendedoresRecord = homePageVendedoresRecordList.firstWhere(
            (v) => v.id == targetVendedorId || v.vendedorId == targetVendedorId,
          );
        } catch (_) {
          debugPrint('HOMEPAGE_DEBUG: Match failed, falling back to first.');
          homePageVendedoresRecord = homePageVendedoresRecordList.first;
        }


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
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Image.asset(
                'assets/images/logo.png',
                height: 68,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Text(
                  'Component',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.lora(),
                        color: const Color(0xFF111111),
                        fontSize: 22,
                      ),
                ),
              ),
              actions: const [],
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 88.0,
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                   Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            homePageVendedoresRecord.miniatura,
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Vendedor: ${valueOrDefault<String>(
                              homePageVendedoresRecord.nombre,
                              'Vendedor',
                            )}',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.vollkornSc(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search Bar & Filter Dropdown
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Color(0xFF718096), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _model.searchController,
                                    focusNode: _model.searchFocusNode,
                                    onChanged: (val) {
                                      setState(() {
                                        _searchText = val;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Buscar producto...',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Helvetica',
                                        color: Color(0xFFA0AEC0),
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Helvetica',
                                      color: Color(0xFF2D3748),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (_searchText.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.clear, color: Color(0xFF718096), size: 16),
                                    onPressed: () {
                                      _model.searchController?.clear();
                                      setState(() {
                                        _searchText = '';
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Dropdown de Categorías
                        StreamBuilder<List<CategoriasRecord>>(
                          stream: queryCategoriasRecord(),
                          builder: (context, catSnapshot) {
                            final List<String> categoriesNames = ['Todas'];
                            if (catSnapshot.hasData) {
                              categoriesNames.addAll(catSnapshot.data!.map((c) => c.nombre));
                            }
                            
                            // Asegurarse de que _selectedCategory sea válido
                            if (!categoriesNames.contains(_selectedCategory)) {
                              _selectedCategory = 'Todas';
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1.0,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  icon: const Icon(Icons.filter_list, color: Color(0xFFDCC39A)),
                                  elevation: 3,
                                  style: GoogleFonts.lora(
                                    color: const Color(0xFF373126),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCategory = newValue!;
                                    });
                                  },
                                  items: categoriesNames.map((name) {
                                    return DropdownMenuItem<String>(
                                      value: name,
                                      child: Text(name),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),

                  // Contenido principal
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _searchText.isEmpty && _selectedCategory == 'Todas'
                          ? StreamBuilder<List<CategoriasRecord>>(
                              stream: queryCategoriasRecord(),
                              builder: (context, snapshot) {
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
                                List<CategoriasRecord> gridViewCategoriasRecordList = snapshot.data!;

                                return GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: gridViewCategoriasRecordList.length,
                                  itemBuilder: (context, gridViewIndex) {
                                    final gridViewCategoriasRecord = gridViewCategoriasRecordList[gridViewIndex];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          ProductsPageWidget.routeName,
                                          queryParameters: {
                                            'vendedorID': serializeParam(
                                              widget.vendedorID,
                                              ParamType.String,
                                            ),
                                            'categoriaRef': serializeParam(
                                              gridViewCategoriasRecord.nombre,
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      child: Card(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Stack(
                                          children: [
                                            // 1. Imagen con filtro Sepia desaturado
                                            Positioned.fill(
                                              child: ColorFiltered(
                                                colorFilter: const ColorFilter.matrix(<double>[
                                                  0.393 * 0.85 + 0.1, 0.769 * 0.85, 0.189 * 0.85, 0, 0,
                                                  0.349 * 0.85, 0.686 * 0.85 + 0.1, 0.168 * 0.85, 0, 0,
                                                  0.272 * 0.85, 0.534 * 0.85, 0.131 * 0.85 + 0.05, 0, 0,
                                                  0, 0, 0, 1, 0,
                                                ]),
                                                child: Image.network(
                                                  gridViewCategoriasRecord.imagen,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    color: FlutterFlowTheme.of(context).alternate,
                                                    child: Icon(
                                                      Icons.image_not_supported_outlined,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 2. Capa de oscurecimiento con tono marrón/dorado cálido
                                            Positioned.fill(
                                              child: Container(
                                                color: const Color(0xFF373126).withOpacity(0.4),
                                              ),
                                            ),
                                            // 3. Doble borde blanco fino interior
                                            Positioned.fill(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white.withOpacity(0.9),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white.withOpacity(0.9),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 4. Texto del título centrado y en Lora negrita
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                child: AutoSizeText(
                                                  gridViewCategoriasRecord.nombre.toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  minFontSize: 10,
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        font: GoogleFonts.lora(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20,
                                                          letterSpacing: 1.5,
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : StreamBuilder<List<ProductosRecord>>(
                              stream: queryProductosRecord(),
                              builder: (context, productsSnapshot) {
                                if (!productsSnapshot.hasData) {
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
                                final allProducts = productsSnapshot.data!;

                                // Filtrar productos en memoria
                                final filteredProducts = allProducts.where((p) {
                                  final matchesSearch = _searchText.isEmpty ||
                                      p.nombre.toLowerCase().contains(_searchText.toLowerCase()) ||
                                      p.codigo.toLowerCase().contains(_searchText.toLowerCase()) ||
                                      p.descripcion.toLowerCase().contains(_searchText.toLowerCase());

                                  final matchesCategory = _selectedCategory == 'Todas' ||
                                      p.categoriaId.toLowerCase() == _selectedCategory.toLowerCase();

                                  return matchesSearch && matchesCategory;
                                }).toList();

                                if (filteredProducts.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: Text(
                                        'No se encontraron productos',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              font: GoogleFonts.vollkornSc(fontSize: 16),
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                            ),
                                      ),
                                    ),
                                  );
                                }

                                // Renderizar cuadrícula de productos
                                return GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          ProductDetailPageWidget.routeName,
                                          extra: product,
                                          queryParameters: {
                                            'vendedorID': serializeParam(
                                              widget.vendedorID,
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      child: Card(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                product.foto,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  color: FlutterFlowTheme.of(context).alternate,
                                                  width: double.infinity,
                                                  child: Icon(
                                                    Icons.image_not_supported_outlined,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.nombre,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.lora(fontWeight: FontWeight.bold),
                                                          fontSize: 13,
                                                        ),
                                                  ),
                                                  if (product.codigo.isNotEmpty)
                                                    Text(
                                                      product.codigo,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            font: GoogleFonts.vollkornSc(),
                                                            fontSize: 11,
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                          ),
                                                    ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '\$${product.precio.toStringAsFixed(0)}',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.vollkornSc(fontWeight: FontWeight.bold),
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          fontSize: 13,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
