import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';
import 'package:flutter_welcome_kit/widgets/spotlight.dart';
import 'package:flutter_welcome_kit/widgets/tooltip_card.dart';

class TourController {
  final List<TourStep> steps;
  final BuildContext context;

  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;

  TourController({
    required this.context,
    required this.steps,
  });

  void start() {
    _currentStepIndex = 0;
    _showStep();
  }

  void next() {
    if (_currentStepIndex < steps.length - 1) {
      _currentStepIndex++;
      _showStep();
    } else {
      end();
    }
  }

  void previous() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      _showStep();
    }
  }

  void end() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showStep() {
    _overlayEntry?.remove();

    final step = steps[_currentStepIndex];
    final renderBox = step.key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);

    if (renderBox == null) return;

    final target = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Spotlight(targetRect: target),
          TooltipCard(
            step: step,
            targetRect: target,
            onNext: next,
            onSkip: end,
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }
}