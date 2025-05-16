import 'package:flutter/material.dart';

enum ArrowDirection { up, down, left, right }
enum ArrowPosition { top, bottom, left, right }

class ArrowAlignment {
  final ArrowPosition position;
  final ArrowDirection direction;
  const ArrowAlignment(this.position, this.direction);
}

class TourStep {
  final GlobalKey key;
  final String title;
  final String description;
  final ArrowAlignment? arrowAlignment;
  final Widget? customWidget;
  final Color backgroundColor;
  final Duration duration;
  final String? buttonLabel;
  final bool isLast;

  const TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.arrowAlignment,
    this.customWidget,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(seconds: 4),
    this.buttonLabel,
    this.isLast = false,
  });
}



