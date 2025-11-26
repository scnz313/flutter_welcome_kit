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
  final Color overlayColor;
  final double overlayBlurRadius;
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
  final Duration? delay;
  final Widget? content;
  final BoxShape shape;
  final bool showArrow;
  final double? width;
  final double? height;
  final bool scrollToTarget;

  const TourStep({
    required this.key,
    this.title = '', // Made optional if content is provided
    this.description = '', // Made optional if content is provided
    this.backgroundColor = Colors.white,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.overlayBlurRadius = 0.0,
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
    this.delay,
    this.content,
    this.shape = BoxShape.rectangle,
    this.showArrow = true,
    this.width,
    this.height,
    this.scrollToTarget = true,
  }) : assert(content != null || (title != '' || description != ''), 
       'Either content must be provided or title/description must be non-empty');
}
