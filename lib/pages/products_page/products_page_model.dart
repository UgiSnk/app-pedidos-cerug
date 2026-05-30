import '/components/contador_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'products_page_widget.dart' show ProductsPageWidget;
import 'package:flutter/material.dart';

class ProductsPageModel extends FlutterFlowModel<ProductsPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for ContadorItem dynamic component.
  late FlutterFlowDynamicModels<ContadorItemModel> contadorItemModels;

  @override
  void initState(BuildContext context) {
    contadorItemModels = FlutterFlowDynamicModels(() => ContadorItemModel());
  }

  @override
  void dispose() {
    contadorItemModels.dispose();
  }
}
