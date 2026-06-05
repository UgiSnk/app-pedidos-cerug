import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  // State fields for Search Bar.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;

  @override
  void initState(BuildContext context) {
    searchFocusNode = FocusNode();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}
