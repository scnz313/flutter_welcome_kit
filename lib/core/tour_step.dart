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

  TourStep({
    required this.key,
    required this.title,
    required this.description,
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
  }) : assert(title.isNotEmpty, 'Title cannot be empty'),
       assert(description.isNotEmpty, 'Description cannot be empty'),
       assert(pointerPadding >= 0, 'Pointer padding must be non-negative'),
       assert(pointerRadius >= 0, 'Pointer radius must be non-negative') {
    // Additional runtime validation
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }
    if (duration.inMilliseconds <= 0) {
      throw ArgumentError('Duration must be positive');
    }
  }

  /// Create a copy of this TourStep with some properties changed
  TourStep copyWith({
    GlobalKey? key,
    String? title,
    String? description,
    Color? backgroundColor,
    Color? overlayColor,
    double? overlayBlurRadius,
    Duration? duration,
    String? buttonLabel,
    bool? isLast,
    StepAnimation? animation,
    TooltipSide? preferredSide,
    double? pointerPadding,
    double? pointerRadius,
    bool? enableInteraction,
    Color? textColor,
    String? accessibilityLabel,
    VoidCallback? onStepEnter,
    VoidCallback? onStepExit,
  }) {
    return TourStep(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayBlurRadius: overlayBlurRadius ?? this.overlayBlurRadius,
      duration: duration ?? this.duration,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      isLast: isLast ?? this.isLast,
      animation: animation ?? this.animation,
      preferredSide: preferredSide ?? this.preferredSide,
      pointerPadding: pointerPadding ?? this.pointerPadding,
      pointerRadius: pointerRadius ?? this.pointerRadius,
      enableInteraction: enableInteraction ?? this.enableInteraction,
      textColor: textColor ?? this.textColor,
      accessibilityLabel: accessibilityLabel ?? this.accessibilityLabel,
      onStepEnter: onStepEnter ?? this.onStepEnter,
      onStepExit: onStepExit ?? this.onStepExit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TourStep &&
        other.key == key &&
        other.title == title &&
        other.description == description &&
        other.backgroundColor == backgroundColor &&
        other.overlayColor == overlayColor &&
        other.overlayBlurRadius == overlayBlurRadius &&
        other.duration == duration &&
        other.buttonLabel == buttonLabel &&
        other.isLast == isLast &&
        other.animation == animation &&
        other.preferredSide == preferredSide &&
        other.pointerPadding == pointerPadding &&
        other.pointerRadius == pointerRadius &&
        other.enableInteraction == enableInteraction &&
        other.textColor == textColor &&
        other.accessibilityLabel == accessibilityLabel;
  }

  @override
  int get hashCode {
    return Object.hash(
      key,
      title,
      description,
      backgroundColor,
      overlayColor,
      overlayBlurRadius,
      duration,
      buttonLabel,
      isLast,
      animation,
      preferredSide,
      pointerPadding,
      pointerRadius,
      enableInteraction,
      textColor,
      accessibilityLabel,
    );
  }

  @override
  String toString() {
    return 'TourStep(title: $title, description: $description, animation: $animation, preferredSide: $preferredSide)';
  }
}
