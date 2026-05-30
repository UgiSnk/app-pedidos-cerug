import 'package:flutter/material.dart';

class FlutterFlowCountController extends StatelessWidget {
  final Widget Function(bool) decrementIconBuilder;
  final Widget Function(bool) incrementIconBuilder;
  final Widget Function(int) countBuilder;
  final int count;
  final ValueChanged<int> updateCount;
  final int stepSize;
  final EdgeInsetsGeometry? contentPadding;
  final int minimum = 0;
  final int? maximum;

  const FlutterFlowCountController({
    super.key,
    required this.decrementIconBuilder,
    required this.incrementIconBuilder,
    required this.countBuilder,
    required this.count,
    required this.updateCount,
    this.stepSize = 1,
    this.contentPadding,
    this.maximum,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = count > minimum;
    final canIncrement = maximum == null || count < maximum!;

    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: canDecrement ? () => updateCount(count - stepSize) : null,
            icon: decrementIconBuilder(canDecrement),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          countBuilder(count),
          IconButton(
            onPressed: canIncrement ? () => updateCount(count + stepSize) : null,
            icon: incrementIconBuilder(canIncrement),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
