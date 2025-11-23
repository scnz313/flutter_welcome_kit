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
  bool _isDisposed = false;

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
    _validateSteps();
  }

  /// Validate all tour steps
  void _validateSteps() {
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      if (step.key.currentContext == null) {
        debugPrint('Warning: Tour step ${i + 1} "${step.title}" has a GlobalKey with no attached widget');
      }
    }
  }

  /// Check if controller is disposed
  bool get isDisposed => _isDisposed;

  /// Dispose the controller and clean up resources
  void dispose() {
    if (_isDisposed) return;
    
    _isDisposed = true;
    end();
  }

  /// Get current step
  TourStep get currentStep {
    if (_isDisposed || _currentStepIndex >= steps.length) {
      throw StateError('TourController is disposed or in invalid state');
    }
    return steps[_currentStepIndex];
  }
  
  /// Check if tour is currently active
  bool get isActive => _isActive;
  
  /// Get current step index
  int get currentStepIndex => _currentStepIndex;
  
  /// Get total number of steps
  int get totalSteps => steps.length;

  /// Start the tour from the beginning
  void start() {
    if (_isDisposed) {
      debugPrint('Warning: Cannot start tour - controller is disposed');
      return;
    }
    
    if (_isActive) {
      debugPrint('Warning: Tour is already active');
      return;
    }
    
    // Validate that all target widgets are still mounted
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      if (step.key.currentContext?.mounted != true) {
        debugPrint('Error: Target widget for step ${i + 1} "${step.title}" is not mounted');
        return;
      }
    }
    
    _currentStepIndex = 0;
    _isActive = true;
    _showStep();
    
    // Announce tour start for accessibility
    _announceForAccessibility('Tour started. Step 1 of ${steps.length}');
  }

  /// Move to next step
  void next() {
    if (_isDisposed || !_isActive) return;
    
    // Call onStepExit callback
    try {
      currentStep.onStepExit?.call();
    } catch (e) {
      debugPrint('Error in onStepExit callback: $e');
    }
    
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
    if (_isDisposed || !_isActive || _currentStepIndex <= 0) return;
    
    // Call onStepExit callback
    try {
      currentStep.onStepExit?.call();
    } catch (e) {
      debugPrint('Error in onStepExit callback: $e');
    }
    
    _currentStepIndex--;
    _showStep();
    
    // Announce step change for accessibility
    _announceForAccessibility(
      'Step ${_currentStepIndex + 1} of ${steps.length}. ${currentStep.title}'
    );
  }

  /// Jump to specific step
  void goToStep(int index) {
    if (_isDisposed || !_isActive || index < 0 || index >= steps.length) return;
    
    // Call onStepExit callback for current step
    try {
      currentStep.onStepExit?.call();
    } catch (e) {
      debugPrint('Error in onStepExit callback: $e');
    }
    
    _currentStepIndex = index;
    _showStep();
    
    // Announce step change for accessibility
    _announceForAccessibility(
      'Step ${_currentStepIndex + 1} of ${steps.length}. ${currentStep.title}'
    );
  }

  /// End the tour
  void end({bool completed = false}) {
    if (_isDisposed || !_isActive) return;
    
    // Call onStepExit callback for current step
    try {
      currentStep.onStepExit?.call();
    } catch (e) {
      debugPrint('Error in onStepExit callback: $e');
    }
    
    // Safely remove overlay
    try {
      _overlayEntry?.remove();
    } catch (e) {
      debugPrint('Error removing overlay: $e');
    } finally {
      _overlayEntry = null;
    }
    
    _isActive = false;
    
    // Call appropriate completion callback
    try {
      if (completed) {
        onTourComplete?.call();
        _announceForAccessibility('Tour completed');
      } else {
        onTourSkipped?.call();
        _announceForAccessibility('Tour skipped');
      }
    } catch (e) {
      debugPrint('Error in completion callback: $e');
    }
  }

  void _showStep() {
    if (_isDisposed || !_isActive) return;

    _overlayEntry?.remove();

    final step = steps[_currentStepIndex];
    final renderObject = step.key.currentContext?.findRenderObject();
    final overlayState = Overlay.of(context, rootOverlay: true);

    // Ensure overlay is available; if not, try again on next frame
    if (overlayState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && _isActive) _showStep();
      });
      return;
    }

    // Validate target render box and layout state
    if (renderObject is! RenderBox || !renderObject.attached || !renderObject.hasSize) {
      // If target isn't laid out yet, try again on next frame; otherwise skip/end
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed || !_isActive) return;
        
        final ro = step.key.currentContext?.findRenderObject();
        if (ro is RenderBox && ro.attached && ro.hasSize) {
          _showStep();
        } else {
          debugPrint('Warning: Target widget for step "${step.title}" is not properly laid out');
          if (_currentStepIndex < steps.length - 1) {
            _currentStepIndex++;
            _showStep();
          } else {
            end();
          }
        }
      });
      return;
    }

    final target = renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final paddedTarget = target.inflate(step.pointerPadding);

    // Call onStepEnter callback
    try {
      step.onStepEnter?.call();
    } catch (e) {
      debugPrint('Error in onStepEnter callback: $e');
    }

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

    try {
      overlayState.insert(_overlayEntry!);
    } catch (e) {
      debugPrint('Error inserting overlay: $e');
      _overlayEntry = null;
    }
  }

  void _announceForAccessibility(String message) {
    try {
      // Use SemanticsService to announce messages for screen readers
      final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
      SemanticsService.announce(message, textDirection);
    } catch (e) {
      debugPrint('Error announcing for accessibility: $e');
    }
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
    
    // Start animation with error handling
    try {
      _controller.forward();
    } catch (e) {
      debugPrint('Error starting overlay animation: $e');
    }
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      debugPrint('Error disposing overlay animation controller: $e');
    }
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