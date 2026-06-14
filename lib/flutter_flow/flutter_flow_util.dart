// ignore_for_file: constant_identifier_names, avoid_print, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as ul;
export 'app_state.dart';
export 'package:go_router/go_router.dart';

abstract class FlutterFlowModel<T extends StatefulWidget> {
  void initState(BuildContext context);
  void dispose();
  void onUpdate() {}
  void maybeDispose() {
    dispose();
  }
}

T createModel<T extends FlutterFlowModel>(BuildContext context, T Function() builder) {
  final model = builder();
  model.initState(context);
  return model;
}

Widget wrapWithModel<T extends FlutterFlowModel>({
  required T model,
  required VoidCallback updateCallback,
  required Widget child,
}) {
  return child;
}

class FlutterFlowDynamicModels<T extends FlutterFlowModel> {
  final T Function() _builder;
  final Map<String, T> _models = {};

  FlutterFlowDynamicModels(this._builder);

  T getModel(String id, int index) {
    if (!_models.containsKey(id)) {
      _models[id] = _builder();
    }
    return _models[id]!;
  }

  void dispose() {
    for (var model in _models.values) {
      model.dispose();
    }
    _models.clear();
  }
}

enum ParamType {
  String,
  Document,
}

dynamic serializeParam(dynamic param, ParamType type) {
  return param;
}

T valueOrDefault<T>(T? value, T defaultValue) {
  return value ?? defaultValue;
}

enum FormatType {
  decimal,
}

enum DecimalType {
  periodDecimal,
}

String formatNumber(
  num? value, {
  required FormatType formatType,
  required DecimalType decimalType,
  String? currency,
}) {
  if (value == null) return '';
  final currencyStr = currency ?? '';
  
  String formattedNumber;
  try {
    final formatter = NumberFormat.decimalPattern('es_AR');
    formattedNumber = formatter.format(value);
  } catch (e) {
    debugPrint('Error formatting number with es_AR: $e');
    try {
      final formatter = NumberFormat.decimalPattern();
      formattedNumber = formatter.format(value);
    } catch (_) {
      final str = value.toStringAsFixed(0);
      final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      formattedNumber = str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    }
  }
  
  if (currencyStr.isNotEmpty) {
    return '$currencyStr$formattedNumber';
  }
  return formattedNumber;
}

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    await ul.launchUrl(uri, mode: ul.LaunchMode.externalApplication);
  } catch (e) {
    print('Could not launch $url: $e');
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> get withoutNulls => Map.fromEntries(
        entries.where((e) => e.value != null),
      );
}

extension StateExtensions on State {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
