import 'package:flutter/material.dart';

class FlutterFlowIconButton extends StatelessWidget {
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? buttonSize;
  final Color? fillColor;
  final Widget icon;
  final VoidCallback onPressed;

  const FlutterFlowIconButton({
    super.key,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.buttonSize,
    this.fillColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: fillColor ?? Colors.transparent,
            border: borderColor != null && borderColor != Colors.transparent
                ? Border.all(
                    color: borderColor!,
                    width: borderWidth ?? 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
