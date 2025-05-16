import 'package:flutter/material.dart';

class OverlayPainter extends CustomPainter {
  final Rect targetRect;
  final double padding;

  OverlayPainter({
    required this.targetRect,
    this.padding = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Draw full screen overlay
    canvas.drawRect(Offset.zero & size, paint);

    // Create transparent hole
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        targetRect.inflate(padding),
        Radius.circular(12),
      ));

    // Use DestinationOut blend mode to cut the hole
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(holePath, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OverlayPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect || oldDelegate.padding != padding;
  }
}