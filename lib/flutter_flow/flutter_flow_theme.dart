import 'package:flutter/material.dart';

class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) => FlutterFlowTheme();

  Color get primary => const Color(0xFFA7860D); // Oro Envejecido (Accent)
  Color get secondary => const Color(0xFF79610B); // Bronce Oscuro
  Color get tertiary => const Color(0xFF2E1600); // Café Quemado / Carbón
  Color get alternate => const Color(0xFFD1D5DB); // Gris Claro para bordes
  Color get primaryBackground => const Color(0xFFF0F5FA); // Gris Azulado / Off-White
  Color get secondaryBackground => Colors.white;
  Color get primaryText => const Color(0xFF1E293B); // Slate / Pizarra
  Color get secondaryText => const Color(0xFF475569); // Slate Claro
  Color get error => Colors.red;
  Color get info => Colors.blue;
  Color get success => Colors.green;

  TextStyle get headlineSmall => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
        fontFamily: 'Lora',
      );

  TextStyle get headlineMedium => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
        fontFamily: 'Lora',
      );

  TextStyle get titleLarge => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
        fontFamily: 'Lora',
      );

  TextStyle get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
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
        color: Color(0xFF1E293B),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        color: Color(0xFF1E293B),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        color: Color(0xFF475569),
        fontFamily: 'Vollkorn SC',
      );

  TextStyle get labelMedium => const TextStyle(
        fontSize: 14,
        color: Color(0xFF475569),
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
