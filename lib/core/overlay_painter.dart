import 'package:flutter/material.dart';

class SpotlightOverlayPainter extends CustomPainter {
  final Rect targetRect;
  final Color overlayColor;
  final double animationValue;
  final double cornerRadius;
  final double blurRadius;

  SpotlightOverlayPainter({
    required this.targetRect,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.animationValue = 1.0,
    this.cornerRadius = 12.0,
    this.blurRadius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = overlayColor.withOpacity(overlayColor.opacity * animationValue)
      ..blendMode = BlendMode.dstOut;

    final overlayPaint = Paint()
      ..color = overlayColor.withOpacity(overlayColor.opacity * animationValue);

    // Create blur effect if specified
    if (blurRadius > 0) {
      overlayPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    }

    // Save layer for blend mode
    canvas.saveLayer(Offset.zero & size, Paint());
    
    // Draw overlay
    canvas.drawRect(Offset.zero & size, overlayPaint);
    
    // Create spotlight cutout with animation
    final animatedRect = Rect.lerp(
      targetRect.center & Size.zero,
      targetRect,
      animationValue,
    ) ?? targetRect;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        animatedRect,
        Radius.circular(cornerRadius),
      ),
      paint,
    );
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(SpotlightOverlayPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
           oldDelegate.overlayColor != overlayColor ||
           oldDelegate.animationValue != animationValue ||
           oldDelegate.cornerRadius != cornerRadius ||
           oldDelegate.blurRadius != blurRadius;
  }
}
