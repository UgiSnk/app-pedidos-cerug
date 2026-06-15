import 'package:flutter/material.dart';

class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) => FlutterFlowTheme();

  Color get primary => const Color(0xFFDCC39A); // Oro Claro (Logo)
  Color get secondary => const Color(0xFF79610B); // Bronce Oscuro
  Color get tertiary => const Color(0xFF1A1F2C); // Dark Grey / Slate
  Color get alternate => const Color(0xFF1E293B); // Slate para bordes
  Color get primaryBackground => const Color(0xFF090D16); // Fondo Oscuro (Azul Oscuro/Negro)
  Color get secondaryBackground => const Color(0xFF111726); // Fondo de tarjetas
  Color get primaryText => const Color(0xFFF1F5F9); // Texto Principal (Blanco)
  Color get secondaryText => const Color(0xFF94A3B8); // Texto Secundario (Gris/Slate)
  Color get error => const Color(0xFFEF4444);
  Color get info => const Color(0xFF3B82F6);
  Color get success => const Color(0xFF10B981); // Emerald green!

  TextStyle get headlineSmall => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F5F9),
        fontFamily: 'Lora',
      );

  TextStyle get headlineMedium => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F5F9),
        fontFamily: 'Lora',
      );

  TextStyle get titleLarge => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F5F9),
        fontFamily: 'Lora',
      );

  TextStyle get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF1F5F9),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get titleSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        color: Color(0xFFF1F5F9),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        color: Color(0xFFF1F5F9),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        color: Color(0xFF94A3B8),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get labelMedium => const TextStyle(
        fontSize: 14,
        color: Color(0xFF94A3B8),
        fontFamily: 'Vollkorn SC',
      );
}

extension TextStyleExtensions on TextStyle {
  TextStyle override({
    TextStyle? font,
    Color? color,
    double? fontSize,
    double? letterSpacing,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return copyWith(
      color: color,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    ).merge(font);
  }
}
