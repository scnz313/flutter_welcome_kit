import 'package:flutter/material.dart';

enum TourAlignment {
  top,
  bottom,
  left,
  right,
  center,
}

class TourStep {
  final GlobalKey key;
  final String title;
  final String description;
  final TourAlignment alignment;
  final Widget? customWidget;
  final Duration duration;

  TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.alignment = TourAlignment.bottom,
    this.customWidget,
    this.duration = const Duration(seconds: 4),
  });
}