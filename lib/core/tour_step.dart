import 'package:flutter/material.dart';

class TourStep {
  final GlobalKey key;
  final String title;
  final String description;
  final Color backgroundColor;
  final Duration duration;
  final String? buttonLabel;
  final bool isLast;

  /// Optional icon to display in the tooltip header.
  final IconData? icon;

  /// Optional image (e.g. AssetImage / NetworkImage) to show inside the card.
  final ImageProvider? image;

  /// Preset animation to use when showing this step.
  final StepAnimation animation;

  /// Padding around the target widget’s [Rect] when drawing the spotlight.
  final double padding;

  /// Custom border radius for the tooltip/spotlight cut-out.
  final BorderRadius? borderRadius;

  /// Explicit text colour (overrides theme detection if provided).
  final Color? textColor;

  /// Overlay colour (spotlight dim colour) – falls back to global default.
  final Color? overlayColor;

  /// Accessibility label read by screen-readers.
  final String? semanticLabel;

  /// Accessibility hint read by screen-readers.
  final String? semanticHint;

  /// Show “Step x of y” progress indicator for this step
  /// (can be globally toggled, this flag allows per-step override).
  final bool showProgress;

  const TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(seconds: 4),
    this.buttonLabel,
    this.isLast = false,
    this.icon,
    this.image,
    this.animation = StepAnimation.none,
    this.padding = 8.0,
    this.borderRadius,
    this.textColor,
    this.overlayColor,
    this.semanticLabel,
    this.semanticHint,
    this.showProgress = true,
  });

  /// Convenient method to create a new instance with some fields changed.
  TourStep copyWith({
    GlobalKey? key,
    String? title,
    String? description,
    Color? backgroundColor,
    Duration? duration,
    String? buttonLabel,
    bool? isLast,
    IconData? icon,
    ImageProvider? image,
    StepAnimation? animation,
    double? padding,
    BorderRadius? borderRadius,
    Color? textColor,
    Color? overlayColor,
    String? semanticLabel,
    String? semanticHint,
    bool? showProgress,
  }) {
    return TourStep(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      duration: duration ?? this.duration,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      isLast: isLast ?? this.isLast,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      animation: animation ?? this.animation,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      textColor: textColor ?? this.textColor,
      overlayColor: overlayColor ?? this.overlayColor,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      semanticHint: semanticHint ?? this.semanticHint,
      showProgress: showProgress ?? this.showProgress,
    );
  }
}

/// Common animation presets for a tour step.  
/// These are consumed by UI widgets (e.g. [TooltipCard]) to decide how to animate.
enum StepAnimation {
  none,
  fade,
  slide,
  scale,
  bounce,
  rotate,
}
