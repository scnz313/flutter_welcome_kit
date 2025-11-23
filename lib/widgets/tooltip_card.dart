import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_welcome_kit/core/tour_step.dart';

class TooltipCard extends StatefulWidget {
  final TourStep step;
  final Rect targetRect;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final VoidCallback onSkip;
  final bool enableKeyboardNavigation;
  final int stepIndex;
  final int totalSteps;

  const TooltipCard({
    super.key,
    required this.step,
    required this.targetRect,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    this.enableKeyboardNavigation = true,
    required this.stepIndex,
    required this.totalSteps,
  });

  @override
  State<TooltipCard> createState() => _TooltipCardState();
}

class _TooltipCardState extends State<TooltipCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  TooltipSide _actualSide = TooltipSide.bottom;
  Offset _tooltipPosition = Offset.zero;
  Size _tooltipSize = const Size(300, 180);
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _calculateOptimalPosition();
    _startAnimations();
    _startAutoAdvanceTimer();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = _createSlideAnimation();
    
    _rotationAnimation = Tween<double>(
      begin: widget.step.animation == StepAnimation.rotate ? -0.1 : 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Animation<Offset> _createSlideAnimation() {
    Offset begin;
    switch (widget.step.animation) {
      case StepAnimation.fadeSlideUp:
        begin = const Offset(0, 0.1); // fractional for SlideTransition
        break;
      case StepAnimation.fadeSlideDown:
        begin = const Offset(0, -0.1);
        break;
      case StepAnimation.fadeSlideLeft:
        begin = const Offset(0.1, 0);
        break;
      case StepAnimation.fadeSlideRight:
        begin = const Offset(-0.1, 0);
        break;
      default:
        begin = Offset.zero;
    }

    return Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() {
    switch (widget.step.animation) {
      case StepAnimation.bounce:
        _controller.forward().then((_) {
          if (mounted) {
            _pulseController.repeat(reverse: true);
          }
        });
        break;
      case StepAnimation.scale:
      case StepAnimation.rotate:
      case StepAnimation.fadeSlideUp:
      case StepAnimation.fadeSlideDown:
      case StepAnimation.fadeSlideLeft:
      case StepAnimation.fadeSlideRight:
        _controller.forward();
        break;
      case StepAnimation.none:
        _controller.value = 1.0;
        break;
    }
  }

  void _startAutoAdvanceTimer() {
    if (!widget.step.isLast && widget.step.enableInteraction) {
      _autoAdvanceTimer?.cancel(); // Cancel any existing timer
      _autoAdvanceTimer = Timer(widget.step.duration, () {
        if (mounted) {
          widget.onNext();
        }
      });
    }
  }

  void _calculateOptimalPosition() {
    if (!mounted) return;
    
    final screenSize = MediaQuery.of(context).size;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    // Calculate dynamic tooltip size based on content
    _calculateTooltipSize();
    
    // Smart positioning algorithm with caching
    final positions = _calculateAllPossiblePositions(screenSize);
    final bestPosition = _selectBestPosition(positions, screenSize);
    
    _actualSide = bestPosition.side;
    _tooltipPosition = bestPosition.position;
    
    // Adjust for RTL
    if (isRTL) {
      _tooltipPosition = Offset(
        screenSize.width - _tooltipPosition.dx - _tooltipSize.width,
        _tooltipPosition.dy,
      );
    }
  }

  void _calculateTooltipSize() {
    // Calculate size based on text content and padding
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.step.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: '\n'),
          TextSpan(
            text: widget.step.description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(maxWidth: 280);
    
    final contentHeight = textPainter.size.height + 100; // Add padding and buttons space
    final contentWidth = (textPainter.size.width + 80).clamp(280.0, 400.0);
    
    _tooltipSize = Size(contentWidth, contentHeight);
  }

  List<_PositionOption> _calculateAllPossiblePositions(Size screenSize) {
    const margin = 16.0;
    final targetCenter = widget.targetRect.center;
    final tooltipWidth = _tooltipSize.width;
    final tooltipHeight = _tooltipSize.height;
    
    return [
      // Bottom positions
      _PositionOption(
        TooltipSide.bottom,
        Offset(
          (targetCenter.dx - tooltipWidth / 2).clamp(margin, screenSize.width - tooltipWidth - margin),
          widget.targetRect.bottom + 16,
        ),
      ),
      _PositionOption(
        TooltipSide.bottomLeft,
        Offset(
          margin,
          widget.targetRect.bottom + 16,
        ),
      ),
      _PositionOption(
        TooltipSide.bottomRight,
        Offset(
          screenSize.width - tooltipWidth - margin,
          widget.targetRect.bottom + 16,
        ),
      ),
      
      // Top positions
      _PositionOption(
        TooltipSide.top,
        Offset(
          (targetCenter.dx - tooltipWidth / 2).clamp(margin, screenSize.width - tooltipWidth - margin),
          widget.targetRect.top - tooltipHeight - 16,
        ),
      ),
      _PositionOption(
        TooltipSide.topLeft,
        Offset(
          margin,
          widget.targetRect.top - tooltipHeight - 16,
        ),
      ),
      _PositionOption(
        TooltipSide.topRight,
        Offset(
          screenSize.width - tooltipWidth - margin,
          widget.targetRect.top - tooltipHeight - 16,
        ),
      ),
      
      // Side positions
      _PositionOption(
        TooltipSide.left,
        Offset(
          widget.targetRect.left - tooltipWidth - 16,
          (targetCenter.dy - tooltipHeight / 2).clamp(margin, screenSize.height - tooltipHeight - margin),
        ),
      ),
      _PositionOption(
        TooltipSide.right,
        Offset(
          widget.targetRect.right + 16,
          (targetCenter.dy - tooltipHeight / 2).clamp(margin, screenSize.height - tooltipHeight - margin),
        ),
      ),
    ];
  }

  _PositionOption _selectBestPosition(List<_PositionOption> positions, Size screenSize) {
    // Prioritize user preference if specified and valid
    if (widget.step.preferredSide != null) {
      final preferred = positions.firstWhere(
        (p) => p.side == widget.step.preferredSide,
        orElse: () => positions.first,
      );
      if (_isPositionValid(preferred.position, screenSize)) {
        return preferred;
      }
    }

    // Find the best valid position
    final validPositions = positions.where((p) => _isPositionValid(p.position, screenSize)).toList();
    
    if (validPositions.isNotEmpty) {
      // Score positions based on visibility, distance from target, and reading direction
      validPositions.sort((a, b) => _scorePosition(a, screenSize).compareTo(_scorePosition(b, screenSize)));
      return validPositions.last; // Higher score is better
    }

    // Fallback to center if no good position found
    return _PositionOption(
      TooltipSide.bottom,
      Offset(
        (screenSize.width - _tooltipSize.width) / 2,
        (screenSize.height - _tooltipSize.height) / 2,
      ),
    );
  }

  bool _isPositionValid(Offset position, Size screenSize) {
    const margin = 8.0;
    return position.dx >= margin &&
           position.dy >= margin &&
           position.dx + _tooltipSize.width <= screenSize.width - margin &&
           position.dy + _tooltipSize.height <= screenSize.height - margin;
  }

  double _scorePosition(_PositionOption option, Size screenSize) {
    double score = 0;

    // Prefer positions that don't overlap with target
    final tooltipRect = option.position & _tooltipSize;
    if (!tooltipRect.overlaps(widget.targetRect)) {
      score += 100;
    }

    // Prefer positions closer to screen center for better visibility
    final screenCenter = screenSize.center(Offset.zero);
    final tooltipCenter = tooltipRect.center;
    final distanceFromCenter = (tooltipCenter - screenCenter).distance;
    score += (screenSize.width - distanceFromCenter) / screenSize.width * 50;

    // Prefer bottom and right positions (natural reading direction)
    switch (option.side) {
      case TooltipSide.bottom:
      case TooltipSide.bottomLeft:
      case TooltipSide.bottomRight:
        score += 20;
        break;
      case TooltipSide.right:
        score += 15;
        break;
      case TooltipSide.left:
        score += 10;
        break;
      case TooltipSide.top:
      case TooltipSide.topLeft:
      case TooltipSide.topRight:
        score += 5;
        break;
    }

    // Bonus for positions that keep tooltip fully visible without scrolling
    final isFullyVisible = _isPositionValid(option.position, screenSize);
    if (isFullyVisible) {
      score += 30;
    }

    return score;
  }

  Offset _calculateArrowPosition() {
    final targetCenter = widget.targetRect.center;
    const arrowSize = 12.0;
    const arrowOffset = 2.0;

    switch (_actualSide) {
      case TooltipSide.top:
      case TooltipSide.topLeft:
      case TooltipSide.topRight:
        return Offset(
          (targetCenter.dx - _tooltipPosition.dx - arrowSize / 2)
              .clamp(16.0, _tooltipSize.width - 32.0),
          _tooltipSize.height - arrowOffset,
        );
      case TooltipSide.bottom:
      case TooltipSide.bottomLeft:
      case TooltipSide.bottomRight:
        return Offset(
          (targetCenter.dx - _tooltipPosition.dx - arrowSize / 2)
              .clamp(16.0, _tooltipSize.width - 32.0),
          -arrowSize + arrowOffset,
        );
      case TooltipSide.left:
        return Offset(
          _tooltipSize.width - arrowOffset,
          (targetCenter.dy - _tooltipPosition.dy - arrowSize / 2)
              .clamp(16.0, _tooltipSize.height - 32.0),
        );
      case TooltipSide.right:
        return Offset(
          -arrowSize + arrowOffset,
          (targetCenter.dy - _tooltipPosition.dy - arrowSize / 2)
              .clamp(16.0, _tooltipSize.height - 32.0),
        );
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel(); // Cancel timer to prevent memory leaks
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final buttonLabel = widget.step.buttonLabel ?? (widget.step.isLast ? "Finish" : "Next");

    final enableKeys = widget.enableKeyboardNavigation && widget.step.enableInteraction;
    return Focus(
      autofocus: enableKeys,
      onKeyEvent: enableKeys ? _handleKeyEvent : null,
      child: Semantics(
        label: widget.step.accessibilityLabel ?? '${widget.step.title}. ${widget.step.description}',
        hint: 'Step ${widget.stepIndex + 1} of ${widget.totalSteps}',
        child: Stack(
          children: [
            // Invisible barrier for outside tap detection
            GestureDetector(
              onTap: widget.step.enableInteraction ? widget.onSkip : null,
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            
            // Tooltip card
            Positioned(
              left: _tooltipPosition.dx,
              top: _tooltipPosition.dy,
              child: _buildAnimatedCard(theme, isRTL, buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(ThemeData theme, bool isRTL, String buttonLabel) {
    Widget card = _buildCard(theme, isRTL, buttonLabel);

    // Apply animations based on step animation type
    switch (widget.step.animation) {
      case StepAnimation.scale:
        card = ScaleTransition(scale: _scaleAnimation, child: card);
        break;
      case StepAnimation.bounce:
        card = AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Transform.scale(
            scale: _pulseAnimation.value,
            child: card,
          ),
        );
        break;
      case StepAnimation.rotate:
        card = RotationTransition(turns: _rotationAnimation, child: card);
        break;
      case StepAnimation.fadeSlideUp:
      case StepAnimation.fadeSlideDown:
      case StepAnimation.fadeSlideLeft:
      case StepAnimation.fadeSlideRight:
        card = SlideTransition(
          position: _slideAnimation,
          child: card,
        );
        break;
      case StepAnimation.none:
        break;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: card,
    );
  }

  Widget _buildCard(ThemeData theme, bool isRTL, String buttonLabel) {
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = widget.step.backgroundColor;
    final textColor = widget.step.textColor;
    final arrowPosition = _calculateArrowPosition();

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main card
          Container(
            width: _tooltipSize.width,
            height: _tooltipSize.height,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.6 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(textColor),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildDescription(textColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildButtons(theme, buttonLabel, isRTL),
                ],
              ),
            ),
          ),
          
          // Arrow pointer
          Positioned(
            left: arrowPosition.dx,
            top: arrowPosition.dy,
            child: _buildArrow(cardColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Row(
      children: [
        // Step indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: textColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${widget.stepIndex + 1}/${widget.totalSteps}',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        
        // Close button
        IconButton(
          onPressed: widget.onSkip,
          icon: Icon(Icons.close, color: textColor.withOpacity(0.7)),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          tooltip: 'Close tour',
        ),
      ],
    );
  }

  Widget _buildDescription(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.step.title,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.step.description,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(ThemeData theme, String buttonLabel, bool isRTL) {
    final children = <Widget>[
      // Previous button (if available)
      if (widget.onPrevious != null)
        OutlinedButton(
          onPressed: widget.onPrevious,
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.step.textColor.withOpacity(0.7),
            side: BorderSide(color: widget.step.textColor.withOpacity(0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Previous'),
        ),
      
      const Spacer(),
      
      // Next/Finish button
      ElevatedButton(
        onPressed: widget.onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text(buttonLabel),
      ),
    ];

    // Reverse for RTL
    if (isRTL) {
      children.removeWhere((w) => w is Spacer);
      children.insert(1, const Spacer());
    }

    return Row(children: children);
  }

  Widget _buildArrow(Color cardColor) {
    return CustomPaint(
      size: const Size(12, 12),
      painter: _ArrowPainter(
        color: cardColor,
        direction: _getArrowDirection(),
      ),
    );
  }

  ArrowDirection _getArrowDirection() {
    switch (_actualSide) {
      case TooltipSide.top:
      case TooltipSide.topLeft:
      case TooltipSide.topRight:
        return ArrowDirection.down;
      case TooltipSide.bottom:
      case TooltipSide.bottomLeft:
      case TooltipSide.bottomRight:
        return ArrowDirection.up;
      case TooltipSide.left:
        return ArrowDirection.right;
      case TooltipSide.right:
        return ArrowDirection.left;
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.escape:
          widget.onSkip();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.enter:
        case LogicalKeyboardKey.space:
          widget.onNext();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowLeft:
          if (widget.onPrevious != null) {
            widget.onPrevious!();
            return KeyEventResult.handled;
          }
          break;
        case LogicalKeyboardKey.arrowRight:
          widget.onNext();
          return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
}

enum ArrowDirection { up, down, left, right }

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
      ..isAntiAlias = true;

    switch (direction) {
      case ArrowDirection.up:
        path.moveTo(size.width / 2, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        break;
      case ArrowDirection.down:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width / 2, size.height);
        break;
      case ArrowDirection.left:
        path.moveTo(0, size.height / 2);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        break;
      case ArrowDirection.right:
        path.moveTo(size.width, size.height / 2);
        path.lineTo(0, 0);
        path.lineTo(0, size.height);
        break;
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _PositionOption {
  final TooltipSide side;
  final Offset position;

  _PositionOption(this.side, this.position);
}
