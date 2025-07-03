import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_welcome_kit/core/tour_step.dart';
import 'package:flutter_welcome_kit/core/tour_config.dart';

enum ArrowDirection { up, down, left, right }

class TooltipCard extends StatefulWidget {
  final TourStep step;
  final Rect targetRect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final Color backgroundColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final int currentStep;
  final int totalSteps;

  const TooltipCard({
    super.key,
    required this.step,
    required this.targetRect,
    required this.onNext,
    required this.onSkip,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
    this.currentStep = 0,
    this.totalSteps = 0,
  });

  @override
  State<TooltipCard> createState() => _TooltipCardState();
}

class _TooltipCardState extends State<TooltipCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    // Optional slide animation
    if (widget.step.animation == StepAnimation.slide) {
      _slideAnimation = Tween<Offset>(
        begin: const Offset(0, .05),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    }

    _controller.forward();
    Future.delayed(widget.step.duration, () {
      if (mounted && !widget.step.isLast) {
        widget.onNext();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _calculatePosition(Size screenSize) {
    // Add validation for screen size
    if (screenSize.width <= 0 || screenSize.height <= 0) {
      return const Offset(0, 0);
    }

    const double verticalOffset = 16;
    const double horizontalPadding = 20;
    double dx = horizontalPadding;
    double dy = widget.targetRect.bottom + verticalOffset + 12;

    // Improve positioning logic
    final config = TourConfig.instance;
    final cardHeight = 200.0;
    final cardWidth = config.tooltipWidth?.clamp(220.0, screenSize.width - 40) ??
        280.0;
    
    if (dy + cardHeight > screenSize.height) {
      dy = widget.targetRect.top - cardHeight - verticalOffset;
      // Fallback if no space above or below
      if (dy < 0) {
        dy = (screenSize.height - cardHeight) / 2;
      }
    }

    if (widget.targetRect.left < screenSize.width / 2) {
      dx = horizontalPadding;
    } else {
      dx = screenSize.width - cardWidth - horizontalPadding;
    }

    return Offset(
      dx.clamp(0, screenSize.width - cardWidth),
      dy.clamp(0, screenSize.height - cardHeight),
    );
  }

  (ArrowDirection, Offset) _calculateArrowPlacement(
    Size screenSize,
    Offset position,
  ) {
    final targetCenter = widget.targetRect.center;
    final cardRect = Rect.fromLTWH(position.dx, position.dy, 280, 160);

    // Calculate the relative position of target to card
    final isTargetAbove = targetCenter.dy < cardRect.top;
    final isTargetBelow = targetCenter.dy > cardRect.bottom;
    final isTargetLeft = targetCenter.dx < cardRect.left;
    final isTargetRight = targetCenter.dx > cardRect.right;

    // Determine arrow direction
    ArrowDirection direction;
    if (isTargetAbove && !isTargetLeft && !isTargetRight) {
      direction = ArrowDirection.up;
    } else if (isTargetBelow && !isTargetLeft && !isTargetRight) {
      direction = ArrowDirection.down;
    } else if (isTargetLeft) {
      direction = ArrowDirection.left;
    } else {
      direction = ArrowDirection.right;
    }

    // Update arrow position calculations
    Offset arrowOffset;
    switch (direction) {
      case ArrowDirection.up:
        arrowOffset = Offset(
          (targetCenter.dx - position.dx).clamp(20.0, 260.0),
          -8, // Move arrow slightly above card
        );
        break;
      case ArrowDirection.down:
        arrowOffset = Offset(
          (targetCenter.dx - position.dx).clamp(20.0, 260.0),
          158, // Position just below card bottom
        );
        break;
      case ArrowDirection.left:
        arrowOffset = Offset(
          -8, // Move arrow slightly left of card
          (targetCenter.dy - position.dy).clamp(20.0, 140.0),
        );
        break;
      case ArrowDirection.right:
        arrowOffset = Offset(
          278, // Position just right of card
          (targetCenter.dy - position.dy).clamp(20.0, 140.0),
        );
        break;
    }

    return (direction, arrowOffset);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final config = TourConfig.instance;
    final position = _calculatePosition(screenSize);
    final (arrowDir, arrowOffset) = _calculateArrowPlacement(
      screenSize,
      position,
    );
    final targetCenterX = widget.targetRect.center.dx;
    final buttonLabel =
        widget.step.buttonLabel ?? (widget.step.isLast ? "Close" : "Next");
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        widget.step.backgroundColor != Colors.white // override
            ? widget.step.backgroundColor
            : config.backgroundColor;
    final textColor = isDark ? Colors.white : Colors.black87;

    final progressText = config.showProgressIndicator &&
            widget.step.showProgress &&
            widget.totalSteps > 0
        ? config.progressIndicatorFormat
            .replaceAll('{current}', (widget.currentStep + 1).toString())
            .replaceAll('{total}', widget.totalSteps.toString())
        : null;

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            widget.onSkip();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) {
            widget.onNext();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        children: [
          // Swipe handling
          Positioned.fill(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    widget.onNext(); // swipe left → next
                  } else {
                    widget.onSkip(); // swipe right → skip/prev
                  }
                }
              },
            ),
          ),
          GestureDetector(
            onTap: widget.onSkip,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: position.dy,
            left: position.dx,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: (_slideAnimation != null)
                  ? SlideTransition(
                      position: _slideAnimation!,
                      child: _buildCard(
                          cardColor, textColor, arrowDir, arrowOffset, progressText),
                    )
                  : ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildCard(
                          cardColor, textColor, arrowDir, arrowOffset, progressText),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Color cardColor, Color textColor, ArrowDirection arrowDir,
      Offset arrowOffset, String? progressText) {
    return Semantics(
      label: widget.step.semanticLabel ?? widget.step.title,
      hint: widget.step.semanticHint ?? widget.step.description,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card first
          Material(
            color: Colors.transparent,
            child: Container(
              width:
                  TourConfig.instance.tooltipWidth ?? 280, // responsive config
              padding: TourConfig.instance.tooltipPadding,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    TourConfig.instance.tooltipBorderRadius, // use config
                boxShadow: [
                  BoxShadow(
                    color: TourConfig.instance.tooltipShadowColor ??
                        Colors.black26,
                    blurRadius: TourConfig.instance.tooltipElevation,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (progressText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        progressText,
                        style: config.progressIndicatorStyle ??
                            Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: textColor.withOpacity(.6)),
                      ),
                    ),
                  Row(
                    children: [
                      if (widget.step.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(widget.step.icon, color: textColor),
                        ),
                      Expanded(
                        child: Text(
                          widget.step.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: textColor),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onSkip,
                        icon: const Icon(Icons.close),
                        splashRadius: 20,
                        tooltip: 'Close',
                        color: textColor,
                      ),
                    ],
                  ),
                  if (widget.step.image != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: widget.step.image!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    widget.step.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onNext,
                        style: TourConfig.instance.buttonStyle ??
                            ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              foregroundColor:
                                  isDark ? Colors.black : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                        child: Text(widget.step.buttonLabel ??
                            (widget.step.isLast ? "Close" : "Next")),
                      ),
                    ],
                  ),
                ],
                child: Stack(
                ],
                  ],
            ),
          ),
          // Arrow always on top
          Positioned(
            left: arrowOffset.dx,
            top: arrowOffset.dy,
            child: _buildArrow(arrowDir),
          ),
        ],
      ),
    );
      ),
    );
  }

  Widget _buildArrow(ArrowDirection direction) {
    const arrowSize = 10.0; // Slightly larger arrow
    final size = switch (direction) {
      ArrowDirection.up || ArrowDirection.down => const Size(16, arrowSize),
      _ => const Size(arrowSize, 16),
    };

    return Container(
      // Add a small padding to prevent arrow from being clipped
      padding: const EdgeInsets.all(1),
      child: CustomPaint(
        size: size,
        painter: _ArrowPainter(
          color: widget.step.backgroundColor,
          direction: direction,
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final ArrowDirection direction;

  _ArrowPainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..isAntiAlias = true; // Smoother edges

    switch (direction) {
      case ArrowDirection.up:
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case ArrowDirection.down:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case ArrowDirection.left:
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case ArrowDirection.right:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
