import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';
import 'package:flutter_welcome_kit/core/tour_config.dart';
import 'package:flutter_welcome_kit/widgets/spotlight.dart';
import 'package:flutter_welcome_kit/widgets/tooltip_card.dart';

/// Controls the flow of a Flutter Welcome Kit tour.
///
/// Besides the basic next/previous handling it now supports:
/// • Global [TourConfig] usage
/// • Step / completion listeners
/// • Progress helpers
/// • Random-access navigation with [jumpTo]
/// • Proper resource disposal
class TourController extends ChangeNotifier {
  /// Steps that compose the tour.
  final List<TourStep> steps;

  /// BuildContext captured from the host widget.
  final BuildContext context;

  /// Global / local configuration for the tour.
  final TourConfig config;

  /// Called whenever the current step changes.
  final VoidCallback? onStepChange;

  /// Called once when the tour completes (i.e., the last step ends).
  final VoidCallback? onComplete;

  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;

  /// Notifier that exposes current step index to outside listeners.
  final ValueNotifier<int> currentStepNotifier = ValueNotifier<int>(0);

  TourController({
    required this.context,
    required this.steps,
    TourConfig? config,
    this.onStepChange,
    this.onComplete,
  }) : config = config ?? TourConfig.instance;

  void start() {
    _currentStepIndex = 0;
    _showStep();
    _notifyStepChanged();
  }

  void next() {
    if (_currentStepIndex < steps.length - 1) {
      _currentStepIndex++;
      _showStep();
      _notifyStepChanged();
    } else {
      end();
    }
  }

  void previous() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      _showStep();
      _notifyStepChanged();
    }
  }

  /// Jump directly to an arbitrary step index.
  void jumpTo(int index) {
    if (index < 0 || index >= steps.length) return;
    _currentStepIndex = index;
    _showStep();
    _notifyStepChanged();
  }

  void end() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    onComplete?.call();
    notifyListeners();
  }

  void _showStep() {
    _overlayEntry?.remove();

    final step = steps[_currentStepIndex];
    final renderBox = step.key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);

    if (renderBox == null) return;
    if (overlay == null) return;

    final target = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    final target = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
          Spotlight(
            targetRect: target,
            padding: step.padding,
            overlayColor: step.overlayColor ?? config.overlayColor,
          ),
          Spotlight(targetRect: target),
          TooltipCard(
            step: step,
            targetRect: target,
            onNext: next,
            animationDuration: config.animationDuration,
            animationCurve: config.animationCurve,
            onSkip: end,
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);

  /// Returns the index of the current step.
  int get currentStepIndex => _currentStepIndex;

  /// Returns the total number of steps.
  int get totalSteps => steps.length;

  /// Notify both internal and external listeners of step changes.
  void _notifyStepChanged() {
    currentStepNotifier.value = _currentStepIndex;
    onStepChange?.call();
    notifyListeners();
  }

  @override
  void dispose() {
    end();
    currentStepNotifier.dispose();
    super.dispose();
  }
  }
}