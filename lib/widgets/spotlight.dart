import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/overlay_painter.dart';

class Spotlight extends StatelessWidget {
  final Rect targetRect;
  final double padding;
  final Color overlayColor;
  final double cornerRadius;
  final double animationValue;
  final double blurRadius;

  const Spotlight({
    super.key,
    required this.targetRect,
    this.padding = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.cornerRadius = 12.0,
    this.animationValue = 1.0,
    this.blurRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Absorb taps on overlay
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: SpotlightOverlayPainter(
          targetRect: targetRect.inflate(padding),
          overlayColor: overlayColor,
          animationValue: animationValue,
          cornerRadius: cornerRadius,
          blurRadius: blurRadius,
        ),
      ),
    );
  }
}