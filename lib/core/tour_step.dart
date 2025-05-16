import 'package:flutter/material.dart';

class TourStep {
  final GlobalKey key;
  final String title;
  final String description;
  final Color backgroundColor;
  final Duration duration;
  final String? buttonLabel;
  final bool isLast;

  const TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(seconds: 4),
    this.buttonLabel,
    this.isLast = false,
  });
}
