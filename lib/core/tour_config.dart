import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';

/// Global configuration for the Flutter Welcome Kit.
/// 
/// This class provides centralized control over default appearance, behavior,
/// and accessibility settings for all tour steps. Individual [TourStep]s can
/// override these settings as needed.
class TourConfig {
  /// Singleton instance for global access
  static final TourConfig instance = TourConfig();

  /// Default background color for tooltips
  final Color backgroundColor;

  /// Default text color for tooltips (null = auto-detect based on background)
  final Color? textColor;

  /// Default color for the spotlight overlay (the dimmed background)
  final Color overlayColor;

  /// Default animation for tour steps
  final StepAnimation defaultAnimation;

  /// Default animation duration for tooltips and transitions
  final Duration animationDuration;

  /// Default animation curve for tooltips and transitions
  final Curve animationCurve;

  /// Whether to show a progress indicator by default (e.g., "Step 2 of 5")
  final bool showProgressIndicator;

  /// Style for the progress indicator text
  final TextStyle? progressIndicatorStyle;

  /// Format for the progress indicator (use {current} and {total} as placeholders)
  final String progressIndicatorFormat;

  /// Default tooltip width (null = responsive/adaptive width)
  final double? tooltipWidth;

  /// Maximum tooltip width (prevents tooltips from becoming too wide)
  final double maxTooltipWidth;

  /// Default tooltip padding
  final EdgeInsets tooltipPadding;

  /// Default spotlight padding around the target widget
  final double spotlightPadding;

  /// Default border radius for the spotlight cutout
  final BorderRadius spotlightBorderRadius;

  /// Default border radius for tooltip cards
  final BorderRadius tooltipBorderRadius;

  /// Whether to enable screen reader announcements
  final bool enableAccessibility;

  /// Default duration for auto-advancing steps (null = no auto-advance)
  final Duration? defaultStepDuration;

  /// Whether to close the tour when tapping outside the tooltip
  final bool closeOnOutsideTap;

  /// Whether to use haptic feedback when navigating between steps
  final bool useHapticFeedback;

  /// Default button theme for next/previous buttons
  final ButtonStyle? buttonStyle;

  /// Default elevation for tooltip cards
  final double tooltipElevation;

  /// Default shadow color for tooltip cards
  final Color? tooltipShadowColor;

  /// Creates a TourConfig with customizable global settings.
  /// 
  /// All parameters have sensible defaults that can be overridden.
  TourConfig({
    this.backgroundColor = Colors.white,
    this.textColor,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.defaultAnimation = StepAnimation.fade,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.showProgressIndicator = true,
    this.progressIndicatorStyle,
    this.progressIndicatorFormat = 'Step {current} of {total}',
    this.tooltipWidth = 300.0,
    this.maxTooltipWidth = 400.0,
    this.tooltipPadding = const EdgeInsets.all(16.0),
    this.spotlightPadding = 8.0,
    this.spotlightBorderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.tooltipBorderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.enableAccessibility = true,
    this.defaultStepDuration,
    this.closeOnOutsideTap = true,
    this.useHapticFeedback = true,
    this.buttonStyle,
    this.tooltipElevation = 8.0,
    this.tooltipShadowColor,
  });

  /// Creates a copy of this configuration with the given fields replaced.
  TourConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? overlayColor,
    StepAnimation? defaultAnimation,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? showProgressIndicator,
    TextStyle? progressIndicatorStyle,
    String? progressIndicatorFormat,
    double? tooltipWidth,
    double? maxTooltipWidth,
    EdgeInsets? tooltipPadding,
    double? spotlightPadding,
    BorderRadius? spotlightBorderRadius,
    BorderRadius? tooltipBorderRadius,
    bool? enableAccessibility,
    Duration? defaultStepDuration,
    bool? closeOnOutsideTap,
    bool? useHapticFeedback,
    ButtonStyle? buttonStyle,
    double? tooltipElevation,
    Color? tooltipShadowColor,
  }) {
    return TourConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      overlayColor: overlayColor ?? this.overlayColor,
      defaultAnimation: defaultAnimation ?? this.defaultAnimation,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      showProgressIndicator: showProgressIndicator ?? this.showProgressIndicator,
      progressIndicatorStyle: progressIndicatorStyle ?? this.progressIndicatorStyle,
      progressIndicatorFormat: progressIndicatorFormat ?? this.progressIndicatorFormat,
      tooltipWidth: tooltipWidth ?? this.tooltipWidth,
      maxTooltipWidth: maxTooltipWidth ?? this.maxTooltipWidth,
      tooltipPadding: tooltipPadding ?? this.tooltipPadding,
      spotlightPadding: spotlightPadding ?? this.spotlightPadding,
      spotlightBorderRadius: spotlightBorderRadius ?? this.spotlightBorderRadius,
      tooltipBorderRadius: tooltipBorderRadius ?? this.tooltipBorderRadius,
      enableAccessibility: enableAccessibility ?? this.enableAccessibility,
      defaultStepDuration: defaultStepDuration ?? this.defaultStepDuration,
      closeOnOutsideTap: closeOnOutsideTap ?? this.closeOnOutsideTap,
      useHapticFeedback: useHapticFeedback ?? this.useHapticFeedback,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      tooltipElevation: tooltipElevation ?? this.tooltipElevation,
      tooltipShadowColor: tooltipShadowColor ?? this.tooltipShadowColor,
    );
  }

  /// Reset the global configuration to default values
  void reset() {
    final defaultConfig = TourConfig();
    
    // Copy all properties from the default config to this instance
    instance = defaultConfig;
  }

  /// Updates the global instance with new settings
  static void updateGlobal(TourConfig config) {
    instance = config;
  }
}
