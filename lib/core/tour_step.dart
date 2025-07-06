import 'package:flutter/material.dart';

/// Animation types for tour step tooltips
enum StepAnimation {
  fadeSlideUp,
  fadeSlideDown,
  fadeSlideLeft,
  fadeSlideRight,
  scale,
  bounce,
  rotate,
  none,
}

/// Preferred tooltip positioning
enum TooltipSide {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class TourStep {
  final GlobalKey key;
  final String title;
  final String description;
  final Color backgroundColor;
  final Duration duration;
  final String? buttonLabel;
  final bool isLast;
  final StepAnimation animation;
  final TooltipSide? preferredSide;
  final double pointerPadding;
  final double pointerRadius;
  final bool enableInteraction;
  final Color textColor;
  final String? accessibilityLabel;
  final VoidCallback? onStepEnter;
  final VoidCallback? onStepExit;

  const TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(seconds: 4),
    this.buttonLabel,
    this.isLast = false,
    this.animation = StepAnimation.fadeSlideUp,
    this.preferredSide,
    this.pointerPadding = 8.0,
    this.pointerRadius = 12.0,
    this.enableInteraction = true,
    this.textColor = Colors.black87,
    this.accessibilityLabel,
    this.onStepEnter,
    this.onStepExit,
  });
}
