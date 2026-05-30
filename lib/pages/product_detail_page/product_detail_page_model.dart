import '/components/contador_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_detail_page_widget.dart' show ProductDetailPageWidget;
import 'package:flutter/material.dart';

class ProductDetailPageModel extends FlutterFlowModel<ProductDetailPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ContadorItem component.
  late ContadorItemModel contadorItemModel;

  @override
  void initState(BuildContext context) {
    contadorItemModel = createModel(context, () => ContadorItemModel());
  }

  @override
  void dispose() {
    contadorItemModel.dispose();
  }
}
