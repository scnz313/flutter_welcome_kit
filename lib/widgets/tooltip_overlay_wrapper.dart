import 'dart:async';
import 'package:flutter/material.dart';
import 'tooltip_card.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';

class TooltipOverlayWrapper extends StatefulWidget {
  final TourStep step;
  final Rect targetRect;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final VoidCallback onSkip;
  final int stepIndex;
  final int totalSteps;

  const TooltipOverlayWrapper({
    super.key,
    required this.step,
    required this.targetRect,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.stepIndex,
    required this.totalSteps,
  });

  @override
  State<TooltipOverlayWrapper> createState() => _TooltipOverlayWrapperState();
}

class _TooltipOverlayWrapperState extends State<TooltipOverlayWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.step.isLast) {
      _timer = Timer(widget.step.duration, widget.onNext);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleOutsideTap() {
    if (!widget.step.isLast) {
      widget.onNext();
    } else {
      widget.onSkip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleOutsideTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // dimmed background
            ),
          ),
          TooltipCard(
            step: widget.step,
            targetRect: widget.targetRect,
            onNext: widget.onNext,
            onPrevious: widget.onPrevious,
            onSkip: widget.onSkip,
            stepIndex: widget.stepIndex,
            totalSteps: widget.totalSteps,
          ),
        ],
      ),
    );
  }
}