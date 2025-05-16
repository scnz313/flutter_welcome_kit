import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';

enum ArrowDirection { up, down, left, right }

class TooltipCard extends StatefulWidget {
  final TourStep step;
  final Rect targetRect;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final Color backgroundColor;

  const TooltipCard({
    super.key,
    required this.step,
    required this.targetRect,
    required this.onNext,
    required this.onSkip,
    this.backgroundColor = Colors.white,
  });

  @override
  State<TooltipCard> createState() => _TooltipCardState();
}

class _TooltipCardState extends State<TooltipCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

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
    const double verticalOffset = 16;
    const double horizontalPadding = 20;
    double dx = horizontalPadding;
    double dy = widget.targetRect.bottom + verticalOffset + 12;

    if (dy + 200 > screenSize.height) {
      dy = widget.targetRect.top - 180;
    }
    if (widget.targetRect.left < screenSize.width / 2) {
      dx = horizontalPadding;
    } else {
      dx = screenSize.width - 320;
    }

    return Offset(
      dx.clamp(0, screenSize.width - 300),
      dy.clamp(0, screenSize.height - 250),
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
    final position = _calculatePosition(screenSize);
    final (arrowDir, arrowOffset) = _calculateArrowPlacement(
      screenSize,
      position,
    );
    final targetCenterX = widget.targetRect.center.dx;
    final buttonLabel =
        widget.step.buttonLabel ?? (widget.step.isLast ? "Close" : "Next");
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = widget.step.backgroundColor != Colors.white
        ? widget.step.backgroundColor
        : (isDark ? Colors.grey[850]! : Colors.white);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Stack(
      children: [
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
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Stack(
                clipBehavior:
                    Clip.none, // Important: Allow arrow to render outside card
                children: [
                  // Card first
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            arrowDir == ArrowDirection.up &&
                                        arrowOffset.dx < 32 ||
                                    arrowDir == ArrowDirection.left
                                ? 0
                                : 16,
                          ),
                          topRight: Radius.circular(
                            arrowDir == ArrowDirection.up &&
                                        arrowOffset.dx > 248 ||
                                    arrowDir == ArrowDirection.right
                                ? 0
                                : 16,
                          ),
                          bottomLeft: Radius.circular(
                            arrowDir == ArrowDirection.down &&
                                        arrowOffset.dx < 32 ||
                                    arrowDir == ArrowDirection.left
                                ? 0
                                : 16,
                          ),
                          bottomRight: Radius.circular(
                            arrowDir == ArrowDirection.down &&
                                        arrowOffset.dx > 248 ||
                                    arrowDir == ArrowDirection.right
                                ? 0
                                : 16,
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.step.title,
                                  style: Theme.of(context).textTheme.titleMedium
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
                          const SizedBox(height: 8),
                          Text(
                            widget.step.description,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: textColor),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: widget.onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  foregroundColor: isDark
                                      ? Colors.black
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(buttonLabel),
                              ),
                            ],
                          ),
                        ],
                      ),
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
            ),
          ),
        ),
      ],
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
