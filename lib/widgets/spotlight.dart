import 'package:flutter/material.dart';

class Spotlight extends StatelessWidget {
  final Rect targetRect;
  final double padding;
  final Color overlayColor;

  const Spotlight({
    super.key,
    required this.targetRect,
    this.padding = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // absorb taps
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _SpotlightPainter(
          target: targetRect.inflate(padding),
          color: overlayColor,
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect target;
  final Color color;

  _SpotlightPainter({required this.target, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..blendMode = BlendMode.dstOut;

    final overlayPaint = Paint()..color = color;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, overlayPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(target, Radius.circular(12)),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}