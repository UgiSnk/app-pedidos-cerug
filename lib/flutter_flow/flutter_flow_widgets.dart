import 'package:flutter/material.dart';

class FFButtonOptions {
  final double? width;
  final double? height;
  final Color? color;
  final TextStyle? textStyle;
  final double? elevation;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const FFButtonOptions({
    this.width,
    this.height,
    this.color,
    this.textStyle,
    this.elevation,
    this.borderSide,
    this.padding,
    this.borderRadius,
  });
}

class FFButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final FFButtonOptions options;
  final Widget? icon;

  const FFButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    required this.options,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options.width,
      height: options.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: options.color,
          foregroundColor: options.textStyle?.color ?? Colors.white,
          elevation: options.elevation ?? 2.0,
          padding: options.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: options.borderRadius ?? BorderRadius.circular(8),
            side: options.borderSide ?? BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: options.textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
