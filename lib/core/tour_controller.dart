import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';
import 'package:flutter_welcome_kit/widgets/spotlight.dart';
import 'package:flutter_welcome_kit/widgets/tooltip_card.dart';

class TourController {
  final List<TourStep> steps;
  final BuildContext context;
  final bool enableKeyboardNavigation;
  final VoidCallback? onTourComplete;
  final VoidCallback? onTourSkipped;
  final Duration transitionDuration;

  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;
  bool _isActive = false;

  TourController({
    required this.context,
    required this.steps,
    this.enableKeyboardNavigation = true,
    this.onTourComplete,
    this.onTourSkipped,
    this.transitionDuration = const Duration(milliseconds: 300),
  }) {
    if (steps.isEmpty) {
      throw ArgumentError('Tour steps cannot be empty');
    }
  }

  /// Get current step
  TourStep get currentStep => steps[_currentStepIndex];
  
  /// Check if tour is currently active
  bool get isActive => _isActive;
  
  /// Get current step index
  int get currentStepIndex => _currentStepIndex;
  
  /// Get total number of steps
  int get totalSteps => steps.length;

  /// Start the tour from the beginning
  void start() {
    if (_isActive) return;
    
    _currentStepIndex = 0;
    _isActive = true;
    _showStep();
    
    // Announce tour start for accessibility
    _announceForAccessibility('Tour started. Step 1 of ${steps.length}');
  }

  /// Move to next step
  void next() {
    if (!_isActive) return;
    
    // Call onStepExit callback
    currentStep.onStepExit?.call();
    
    if (_currentStepIndex < steps.length - 1) {
      _currentStepIndex++;
      _showStep();
      
      // Announce step change for accessibility
      _announceForAccessibility(
        'Step ${_currentStepIndex + 1} of ${steps.length}. ${currentStep.title}'
      );
    } else {
      end(completed: true);
    }
  }

  /// Move to previous step
  void previous() {
    if (!_isActive || _currentStepIndex <= 0) return;
    
    // Call onStepExit callback
    currentStep.onStepExit?.call();
    
    _currentStepIndex--;
    _showStep();
    
    // Announce step change for accessibility
    _announceForAccessibility(
      'Step ${_currentStepIndex + 1} of ${steps.length}. ${currentStep.title}'
    );
  }

  /// Jump to specific step
  void goToStep(int index) {
    if (!_isActive || index < 0 || index >= steps.length) return;
    
    // Call onStepExit callback for current step
    currentStep.onStepExit?.call();
    
    _currentStepIndex = index;
    _showStep();
    
    // Announce step change for accessibility
    _announceForAccessibility(
      'Step ${_currentStepIndex + 1} of ${steps.length}. ${currentStep.title}'
    );
  }

  /// End the tour
  void end({bool completed = false}) {
    if (!_isActive) return;
    
    // Call onStepExit callback for current step
    currentStep.onStepExit?.call();
    
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isActive = false;
    
    // Call appropriate completion callback
    if (completed) {
      onTourComplete?.call();
      _announceForAccessibility('Tour completed');
    } else {
      onTourSkipped?.call();
      _announceForAccessibility('Tour skipped');
    }
  }

  void _showStep() {
    if (!_isActive) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    final step = steps[_currentStepIndex];

    void mount() {
      if (step.delay != null) {
        Future.delayed(step.delay!, () {
          if (_isActive && steps[_currentStepIndex] == step) {
            _mountStepOverlay(step);
          }
        });
      } else {
        _mountStepOverlay(step);
      }
    }

    if (step.scrollToTarget) {
      final context = step.key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        ).then((_) {
          if (_isActive && steps[_currentStepIndex] == step) {
            mount();
          }
        }).catchError((error) {
          debugPrint('TourController: Failed to scroll to target: $error');
          if (_isActive && steps[_currentStepIndex] == step) {
            mount();
          }
        });
        return;
      }
    }

    mount();
  }

  void _mountStepOverlay(TourStep step) {
    final renderObject = step.key.currentContext?.findRenderObject();
    final overlayState = Overlay.of(context, rootOverlay: true);

    // Ensure overlay is available; if not, try again on next frame
    if (overlayState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isActive && steps[_currentStepIndex] == step) _mountStepOverlay(step);
      });
      return;
    }

    // Validate target render box and layout state
    if (renderObject is! RenderBox || !renderObject.attached || !renderObject.hasSize) {
      // If target isn't laid out yet, try again on next frame; otherwise skip/end
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isActive) return;
        final ro = step.key.currentContext?.findRenderObject();
        if (ro is RenderBox && ro.attached && ro.hasSize) {
          _mountStepOverlay(step);
        } else if (_currentStepIndex < steps.length - 1) {
          _currentStepIndex++;
          _showStep();
        } else {
          end();
        }
      });
      return;
    }

    final target = renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final paddedTarget = target.inflate(step.pointerPadding);

    // Call onStepEnter callback
    step.onStepEnter?.call();

    _overlayEntry = OverlayEntry(
      builder: (context) => _TourOverlay(
        step: step,
        targetRect: paddedTarget,
        cornerRadius: step.pointerRadius,
        onNext: next,
        onPrevious: _currentStepIndex > 0 ? previous : null,
        onSkip: () => end(completed: false),
        enableKeyboardNavigation: enableKeyboardNavigation && step.enableInteraction,
        stepIndex: _currentStepIndex,
        totalSteps: steps.length,
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _announceForAccessibility(String message) {
    // Use SemanticsService to announce messages for screen readers
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    SemanticsService.announce(message, textDirection);
  }
}

/// Internal overlay widget that combines spotlight and tooltip
class _TourOverlay extends StatefulWidget {
  final TourStep step;
  final Rect targetRect;
  final double cornerRadius;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final VoidCallback onSkip;
  final bool enableKeyboardNavigation;
  final int stepIndex;
  final int totalSteps;

  const _TourOverlay({
    required this.step,
    required this.targetRect,
    required this.cornerRadius,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.enableKeyboardNavigation,
    required this.stepIndex,
    required this.totalSteps,
  });

  @override
  State<_TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends State<_TourOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Spotlight overlay
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Spotlight(
            targetRect: widget.targetRect,
            cornerRadius: widget.cornerRadius,
            animationValue: _animation.value,
            overlayColor: widget.step.overlayColor,
            blurRadius: widget.step.overlayBlurRadius,
            shape: widget.step.shape,
          ),
        ),
        // Tooltip card
        TooltipCard(
          step: widget.step,
          targetRect: widget.targetRect,
          onNext: widget.onNext,
          onPrevious: widget.onPrevious,
          onSkip: widget.onSkip,
          enableKeyboardNavigation: widget.enableKeyboardNavigation,
          stepIndex: widget.stepIndex,
          totalSteps: widget.totalSteps,
        ),
      ],
    );
  }
}
