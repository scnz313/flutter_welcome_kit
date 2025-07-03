import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter_welcome_kit/core/tour_step.dart';

/// Utility class for creating and manipulating spotlight overlay effects.
///
/// This class provides methods to:
/// - Create different spotlight shapes
/// - Support custom shapes and clipping paths
/// - Apply animations to spotlight transitions
/// - Calculate optimal positions for tooltips and spotlights
class OverlayPainter {
  /// Creates a rectangular path with optional border radius
  static Path createRectanglePath(Rect rect, {BorderRadius? borderRadius}) {
    final path = Path();
    
    if (borderRadius == null) {
      path.addRect(rect);
    } else {
      path.addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      );
    }
    
    return path;
  }

  /// Creates a circular path centered on the rect
  static Path createCirclePath(Rect rect) {
    final path = Path();
    final radius = math.min(rect.width, rect.height) / 2;
    path.addOval(
      Rect.fromCircle(
        center: rect.center,
        radius: radius,
      ),
    );
    return path;
  }

  /// Creates an oval path that fits the rect
  static Path createOvalPath(Rect rect) {
    final path = Path();
    path.addOval(rect);
    return path;
  }

  /// Creates a path for a rounded rectangle with different corner radii
  static Path createRoundedRectPath(
    Rect rect, {
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
  }) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );
    return path;
  }

  /// Creates a custom polygon path
  static Path createPolygonPath(Rect rect, int sides) {
    final path = Path();
    final center = rect.center;
    final radius = math.min(rect.width, rect.height) / 2;
    
    path.moveTo(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );
    
    for (int i = 1; i <= sides; i++) {
      final angle = (i * 2 * math.pi / sides);
      path.lineTo(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
    }
    
    path.close();
    return path;
  }

  /// Creates a star-shaped path
  static Path createStarPath(Rect rect, int points, double innerRadius) {
    final path = Path();
    final center = rect.center;
    final outerRadius = math.min(rect.width, rect.height) / 2;
    
    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / points);
      
      final x = center.dx + radius * math.cos(angle - math.pi / 2);
      final y = center.dy + radius * math.sin(angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    return path;
  }

  /// Applies animation transformation to a path
  static Path applyAnimation(
    Path path,
    StepAnimation animation,
    double animationValue,
    Rect bounds,
  ) {
    if (animationValue >= 1.0) return path;
    
    final matrix = Matrix4.identity();
    final center = bounds.center;
    
    switch (animation) {
      case StepAnimation.scale:
        matrix.translate(center.dx, center.dy);
        matrix.scale(animationValue, animationValue);
        matrix.translate(-center.dx, -center.dy);
        break;
        
      case StepAnimation.rotate:
        matrix.translate(center.dx, center.dy);
        matrix.rotateZ(2 * math.pi * (1 - animationValue));
        matrix.translate(-center.dx, -center.dy);
        break;
        
      case StepAnimation.slide:
        matrix.translate(0, bounds.height * (1 - animationValue));
        break;
        
      case StepAnimation.bounce:
        if (animationValue > 0.8) {
          final bounceValue = math.sin((animationValue - 0.8) * 5 * math.pi) * 
                              (1 - animationValue) * 20;
          matrix.translate(0, bounceValue);
        }
        break;
        
      default:
        // No transformation for fade or none
        break;
    }
    
    return path.transform(matrix.storage);
  }

  /// Calculates the optimal position for a tooltip relative to a target rect
  static Rect calculateTooltipPosition(
    Rect targetRect,
    Size tooltipSize,
    Size screenSize, {
    EdgeInsets padding = const EdgeInsets.all(16.0),
    bool preferBelow = true,
  }) {
    // Default position (below target)
    double left = targetRect.center.dx - tooltipSize.width / 2;
    double top = preferBelow ? 
                 targetRect.bottom + padding.top : 
                 targetRect.top - tooltipSize.height - padding.bottom;
    
    // Check if tooltip would go off-screen horizontally
    if (left < padding.left) {
      left = padding.left;
    } else if (left + tooltipSize.width > screenSize.width - padding.right) {
      left = screenSize.width - tooltipSize.width - padding.right;
    }
    
    // Check if tooltip would go off-screen vertically
    if (top < padding.top) {
      // Not enough space above, try below
      top = targetRect.bottom + padding.top;
      
      // If still not enough space, center on screen
      if (top + tooltipSize.height > screenSize.height - padding.bottom) {
        top = (screenSize.height - tooltipSize.height) / 2;
      }
    } else if (top + tooltipSize.height > screenSize.height - padding.bottom) {
      // Not enough space below, try above
      top = targetRect.top - tooltipSize.height - padding.bottom;
      
      // If still not enough space, center on screen
      if (top < padding.top) {
        top = (screenSize.height - tooltipSize.height) / 2;
      }
    }
    
    return Rect.fromLTWH(left, top, tooltipSize.width, tooltipSize.height);
  }

  /// Calculates the optimal arrow position for connecting a tooltip to a target
  static (ArrowDirection, Offset) calculateArrowPosition(
    Rect targetRect,
    Rect tooltipRect,
  ) {
    final targetCenter = targetRect.center;
    final tooltipCenter = tooltipRect.center;
    
    // Determine the primary direction based on relative positions
    final horizontalDistance = (targetCenter.dx - tooltipCenter.dx).abs();
    final verticalDistance = (targetCenter.dy - tooltipCenter.dy).abs();
    
    ArrowDirection direction;
    Offset position;
    
    if (horizontalDistance > verticalDistance) {
      // Primarily horizontal relationship
      if (targetCenter.dx < tooltipCenter.dx) {
        // Target is to the left of tooltip
        direction = ArrowDirection.left;
        position = Offset(
          tooltipRect.left,
          tooltipRect.top + (targetCenter.dy - tooltipRect.top).clamp(
            16.0,
            tooltipRect.height - 16.0,
          ),
        );
      } else {
        // Target is to the right of tooltip
        direction = ArrowDirection.right;
        position = Offset(
          tooltipRect.right,
          tooltipRect.top + (targetCenter.dy - tooltipRect.top).clamp(
            16.0,
            tooltipRect.height - 16.0,
          ),
        );
      }
    } else {
      // Primarily vertical relationship
      if (targetCenter.dy < tooltipCenter.dy) {
        // Target is above tooltip
        direction = ArrowDirection.up;
        position = Offset(
          tooltipRect.left + (targetCenter.dx - tooltipRect.left).clamp(
            16.0,
            tooltipRect.width - 16.0,
          ),
          tooltipRect.top,
        );
      } else {
        // Target is below tooltip
        direction = ArrowDirection.down;
        position = Offset(
          tooltipRect.left + (targetCenter.dx - tooltipRect.left).clamp(
            16.0,
            tooltipRect.width - 16.0,
          ),
          tooltipRect.bottom,
        );
      }
    }
    
    return (direction, position);
  }

  /// Creates a cutout effect in the canvas
  static void createCutout(
    Canvas canvas,
    Size size,
    Path cutoutPath,
    Color overlayColor,
  ) {
    // Save the canvas state
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    
    // Draw the overlay background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = overlayColor,
    );
    
    // Cut out the path using BlendMode.dstOut
    canvas.drawPath(
      cutoutPath,
      Paint()
        ..color = Colors.white
        ..blendMode = BlendMode.dstOut
        ..isAntiAlias = true,
    );
    
    // Restore the canvas
    canvas.restore();
  }
}

/// Enum defining the possible arrow directions for tooltips
enum ArrowDirection {
  up,
  down,
  left,
  right,
}
