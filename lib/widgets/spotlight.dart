import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/semantics.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';
import 'dart:math' as math; // moved from bottom to fix directive order

/// Defines the shape of the spotlight cutout.
enum SpotlightShape {
  /// Rectangular shape with optional border radius
  rectangle,
  
  /// Circular shape (uses the smallest dimension of the rect)
  circle,
  
  /// Oval shape that fits the target rect
  oval,
  
  /// Custom path (requires a custom path builder)
  custom,
}

/// A widget that creates a semi-transparent overlay with a clear "cutout" 
/// around the target widget.
class Spotlight extends StatefulWidget {
  /// The rectangle defining the target area to spotlight.
  final Rect targetRect;
  
  /// Additional padding around the target rect.
  final double padding;
  
  /// Color of the overlay (dimmed background).
  final Color overlayColor;
  
  /// Shape of the spotlight cutout.
  final SpotlightShape shape;
  
  /// Border radius for rectangle shape (ignored for circle/oval).
  final BorderRadius? borderRadius;
  
  /// Whether to animate the spotlight when it appears.
  final bool animate;
  
  /// Animation type to use (if animate is true).
  final StepAnimation animationType;
  
  /// Duration of the animation.
  final Duration animationDuration;
  
  /// Curve to use for the animation.
  final Curve animationCurve;
  
  /// Optional callback when the spotlight area is tapped.
  final VoidCallback? onTargetTap;
  
  /// Optional callback when the overlay (outside target) is tapped.
  final VoidCallback? onOverlayTap;
  
  /// Additional targets to spotlight (for multiple spotlights).
  final List<Rect>? additionalTargets;
  
  /// Shapes for additional targets (must match additionalTargets length).
  final List<SpotlightShape>? additionalShapes;
  
  /// Border radii for additional targets (must match additionalTargets length).
  final List<BorderRadius?>? additionalBorderRadii;
  
  /// Accessibility label for screen readers.
  final String? semanticsLabel;
  
  /// Accessibility hint for screen readers.
  final String? semanticsHint;
  
  /// Whether to exclude the spotlight area from semantics.
  final bool excludeFromSemantics;
  
  /// Optional custom path builder for custom spotlight shapes.
  final Path Function(Rect rect)? customPathBuilder;
  
  /// Creates a Spotlight widget.
  /// 
  /// The [targetRect] parameter is required and defines the area to spotlight.
  /// Other parameters are optional and provide customization.
  const Spotlight({
    super.key,
    required this.targetRect,
    this.padding = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.shape = SpotlightShape.rectangle,
    this.borderRadius,
    this.animate = false,
    this.animationType = StepAnimation.fade,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.onTargetTap,
    this.onOverlayTap,
    this.additionalTargets,
    this.additionalShapes,
    this.additionalBorderRadii,
    this.semanticsLabel,
    this.semanticsHint,
    this.excludeFromSemantics = false,
    this.customPathBuilder,
  });

  @override
  State<Spotlight> createState() => _SpotlightState();
}

class _SpotlightState extends State<Spotlight> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );
    
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(Spotlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.animate != oldWidget.animate ||
        widget.animationDuration != oldWidget.animationDuration ||
        widget.animationCurve != oldWidget.animationCurve) {
      _animationController.duration = widget.animationDuration;
      _animation = CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      );
      
      if (widget.animate) {
        _animationController.forward(from: 0.0);
      } else {
        _animationController.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget spotlight = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _SpotlightPainter(
            target: widget.targetRect.inflate(widget.padding),
            color: widget.overlayColor,
            shape: widget.shape,
            borderRadius: widget.borderRadius ?? 
                BorderRadius.circular(12), // Default for backward compatibility
            animationValue: _animation.value,
            animationType: widget.animationType,
            additionalTargets: widget.additionalTargets,
            additionalShapes: widget.additionalShapes,
            additionalBorderRadii: widget.additionalBorderRadii,
            customPathBuilder: widget.customPathBuilder,
          ),
        );
      },
    );

    return Stack(
      children: [
        // Overlay tap handler
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onOverlayTap,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        
        // Spotlight with cutout
        Semantics(
          label: widget.semanticsLabel,
          hint: widget.semanticsHint,
          excludeSemantics: widget.excludeFromSemantics,
          child: spotlight,
        ),
        
        // Target tap handler (only if onTargetTap is provided)
        if (widget.onTargetTap != null)
          Positioned(
            left: widget.targetRect.left,
            top: widget.targetRect.top,
            width: widget.targetRect.width,
            height: widget.targetRect.height,
            child: GestureDetector(
              onTap: widget.onTargetTap,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
      ],
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect target;
  final Color color;
  final SpotlightShape shape;
  final BorderRadius borderRadius;
  final double animationValue;
  final StepAnimation animationType;
  final List<Rect>? additionalTargets;
  final List<SpotlightShape>? additionalShapes;
  final List<BorderRadius?>? additionalBorderRadii;
  final Path Function(Rect rect)? customPathBuilder;

  _SpotlightPainter({
    required this.target,
    required this.color,
    required this.shape,
    required this.borderRadius,
    required this.animationValue,
    required this.animationType,
    this.additionalTargets,
    this.additionalShapes,
    this.additionalBorderRadii,
    this.customPathBuilder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a layer for the overlay
    canvas.saveLayer(Offset.zero & size, Paint());
    
    // Draw the overlay background
    final overlayPaint = Paint()..color = color.withOpacity(color.opacity * animationValue);
    canvas.drawRect(Offset.zero & size, overlayPaint);
    
    // Setup the cutout paint
    final cutoutPaint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.dstOut
      ..isAntiAlias = true;
    
    // Apply animation to the target rect if needed
    final animatedTarget = _applyAnimation(target);
    
    // Draw the main target cutout
    _drawCutout(canvas, animatedTarget, cutoutPaint, shape, borderRadius);
    
    // Draw additional targets if provided
    if (additionalTargets != null && additionalTargets!.isNotEmpty) {
      for (int i = 0; i < additionalTargets!.length; i++) {
        final additionalTarget = additionalTargets![i];
        final additionalShape = additionalShapes != null && i < additionalShapes!.length
            ? additionalShapes![i]
            : shape;
        final additionalBorderRadius = additionalBorderRadii != null && i < additionalBorderRadii!.length
            ? additionalBorderRadii![i] ?? borderRadius
            : borderRadius;
        
        final animatedAdditionalTarget = _applyAnimation(additionalTarget);
        _drawCutout(canvas, animatedAdditionalTarget, cutoutPaint, additionalShape, additionalBorderRadius);
      }
    }
    
    // Restore the canvas
    canvas.restore();
  }
  
  /// Applies animation effects to the target rect based on the animation type
  Rect _applyAnimation(Rect rect) {
    if (animationValue == 1.0) return rect; // No animation needed
    
    switch (animationType) {
      case StepAnimation.fade:
        // Fade doesn't affect the rect
        return rect;
      
      case StepAnimation.scale:
        // Scale the rect from center
        final center = rect.center;
        final size = Size(
          rect.width * animationValue,
          rect.height * animationValue,
        );
        return Rect.fromCenter(
          center: center,
          width: size.width,
          height: size.height,
        );
      
      case StepAnimation.slide:
        // Slide from top
        final offset = (1 - animationValue) * rect.height;
        return rect.translate(0, offset);
      
      case StepAnimation.bounce:
        // Bounce effect using a sine wave
        final bounce = (1 - animationValue) * 10 * 
            (animationValue > 0.8 ? 
              ui.lerpDouble(0, 1, (animationValue - 0.8) * 5)! * 
              sin(animationValue * 20) : 0);
        return rect.translate(0, bounce);
      
      case StepAnimation.rotate:
        // Rotation doesn't affect the rect directly
        // (would need a custom path for rotation)
        return rect;
      
      default:
        return rect;
    }
  }
  
  /// Draws a cutout in the overlay based on the specified shape and border radius
  void _drawCutout(Canvas canvas, Rect rect, Paint paint, SpotlightShape spotlightShape, BorderRadius borderRadius) {
    switch (spotlightShape) {
      case SpotlightShape.rectangle:
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: borderRadius.topLeft,
            topRight: borderRadius.topRight,
            bottomLeft: borderRadius.bottomLeft,
            bottomRight: borderRadius.bottomRight,
          ),
          paint,
        );
        break;
        
      case SpotlightShape.circle:
        final radius = math.min(rect.width, rect.height) / 2;
        canvas.drawCircle(rect.center, radius, paint);
        break;
        
      case SpotlightShape.oval:
        final ovalPath = Path()..addOval(rect);
        canvas.drawPath(ovalPath, paint);
        break;
        
      case SpotlightShape.custom:
        if (customPathBuilder != null) {
          final customPath = customPathBuilder!(rect);
          canvas.drawPath(customPath, paint);
        } else {
          // Fallback to rectangle if no custom path builder provided
          canvas.drawRRect(
            RRect.fromRectAndCorners(
              rect,
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
              bottomLeft: borderRadius.bottomLeft,
              bottomRight: borderRadius.bottomRight,
            ),
            paint,
          );
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return target != oldDelegate.target ||
           color != oldDelegate.color ||
           shape != oldDelegate.shape ||
           borderRadius != oldDelegate.borderRadius ||
           animationValue != oldDelegate.animationValue ||
           animationType != oldDelegate.animationType ||
           additionalTargets != oldDelegate.additionalTargets ||
           additionalShapes != oldDelegate.additionalShapes ||
           additionalBorderRadii != oldDelegate.additionalBorderRadii;
  }
}

// Helper extension for math operations
extension on double {
  double sin(double x) => math.sin(x);
}
