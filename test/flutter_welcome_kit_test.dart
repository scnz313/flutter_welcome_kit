import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_welcome_kit/flutter_welcome_kit.dart';

void main() {
  group('TourStep', () {
    test('should create TourStep with required parameters', () {
      final key = GlobalKey();
      final step = TourStep(
        key: key,
        title: 'Test Title',
        description: 'Test Description',
      );

      expect(step.key, equals(key));
      expect(step.title, equals('Test Title'));
      expect(step.description, equals('Test Description'));
      expect(step.backgroundColor, equals(Colors.white));
      expect(step.animation, equals(StepAnimation.fadeSlideUp));
      expect(step.isLast, equals(false));
    });

    test('should create TourStep with custom parameters', () {
      final key = GlobalKey();
      final step = TourStep(
        key: key,
        title: 'Custom Title',
        description: 'Custom Description',
        backgroundColor: Colors.blue,
        overlayColor: Colors.black.withOpacity(0.6),
        overlayBlurRadius: 2.0,
        animation: StepAnimation.bounce,
        preferredSide: TooltipSide.top,
        isLast: true,
        textColor: Colors.white,
        pointerPadding: 12.0,
        pointerRadius: 16.0,
      );

      expect(step.backgroundColor, equals(Colors.blue));
      expect(step.animation, equals(StepAnimation.bounce));
      expect(step.preferredSide, equals(TooltipSide.top));
      expect(step.isLast, equals(true));
      expect(step.textColor, equals(Colors.white));
      expect(step.pointerPadding, equals(12.0));
      expect(step.pointerRadius, equals(16.0));
      expect(step.overlayColor.opacity, closeTo(0.6, 0.01));
      expect(step.overlayBlurRadius, equals(2.0));
    });

    test('should copy TourStep with new values', () {
      final originalStep = TourStep(
        key: GlobalKey(),
        title: 'Original Title',
        description: 'Original Description',
        backgroundColor: Colors.red,
      );

      final copiedStep = originalStep.copyWith(
        title: 'New Title',
        backgroundColor: Colors.blue,
      );

      expect(copiedStep.title, equals('New Title'));
      expect(copiedStep.description, equals('Original Description'));
      expect(copiedStep.backgroundColor, equals(Colors.blue));
    });

    test('should implement equality', () {
      final key = GlobalKey();
      final step1 = TourStep(
        key: key,
        title: 'Test Title',
        description: 'Test Description',
      );
      final step2 = TourStep(
        key: key,
        title: 'Test Title',
        description: 'Test Description',
      );

      expect(step1, equals(step2));
      expect(step1.hashCode, equals(step2.hashCode));
    });

    test('should have meaningful toString', () {
      final step = TourStep(
        key: GlobalKey(),
        title: 'Test Title',
        description: 'Test Description',
        animation: StepAnimation.bounce,
        preferredSide: TooltipSide.top,
      );

      expect(step.toString(), contains('Test Title'));
      expect(step.toString(), contains('bounce'));
      expect(step.toString(), contains('top'));
    });
  });

  group('StepAnimation', () {
    test('should have all animation types', () {
      expect(StepAnimation.values.length, equals(8));
      expect(StepAnimation.values, contains(StepAnimation.fadeSlideUp));
      expect(StepAnimation.values, contains(StepAnimation.fadeSlideDown));
      expect(StepAnimation.values, contains(StepAnimation.fadeSlideLeft));
      expect(StepAnimation.values, contains(StepAnimation.fadeSlideRight));
      expect(StepAnimation.values, contains(StepAnimation.scale));
      expect(StepAnimation.values, contains(StepAnimation.bounce));
      expect(StepAnimation.values, contains(StepAnimation.rotate));
      expect(StepAnimation.values, contains(StepAnimation.none));
    });
  });

  group('TooltipSide', () {
    test('should have all positioning options', () {
      expect(TooltipSide.values.length, equals(8));
      expect(TooltipSide.values, contains(TooltipSide.top));
      expect(TooltipSide.values, contains(TooltipSide.bottom));
      expect(TooltipSide.values, contains(TooltipSide.left));
      expect(TooltipSide.values, contains(TooltipSide.right));
      expect(TooltipSide.values, contains(TooltipSide.topLeft));
      expect(TooltipSide.values, contains(TooltipSide.topRight));
      expect(TooltipSide.values, contains(TooltipSide.bottomLeft));
      expect(TooltipSide.values, contains(TooltipSide.bottomRight));
    });
  });

  group('TourController', () {
    testWidgets('should be created with valid steps', (tester) async {
      final key = GlobalKey();
      final steps = [
        TourStep(
          key: key,
          title: 'Test',
          description: 'Test Description',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final controller = TourController(
                context: context,
                steps: steps,
              );
              
              expect(controller.totalSteps, equals(1));
              expect(controller.isActive, equals(false));
              expect(controller.isDisposed, equals(false));
              expect(controller.currentStepIndex, equals(0));
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should throw error for empty steps', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                () => TourController(
                  context: context,
                  steps: [],
                ),
                throwsA(isA<ArgumentError>()),
              );
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should handle disposal properly', (tester) async {
      final key = GlobalKey();
      final steps = [
        TourStep(
          key: key,
          title: 'Test',
          description: 'Test Description',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final controller = TourController(
                context: context,
                steps: steps,
              );
              
              expect(controller.isDisposed, equals(false));
              
              controller.dispose();
              expect(controller.isDisposed, equals(true));
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );
    });

    testWidgets('should handle callbacks with errors gracefully', (tester) async {
      final key = GlobalKey();
      final steps = [
        TourStep(
          key: key,
          title: 'Test',
          description: 'Test Description',
          onStepEnter: () => throw Exception('Test error'),
          onStepExit: () => throw Exception('Test error'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final controller = TourController(
                context: context,
                steps: steps,
                onTourComplete: () => throw Exception('Test error'),
                onTourSkipped: () => throw Exception('Test error'),
              );
              
              // Should not throw when calling methods with error callbacks
              expect(() => controller.start(), returnsNormally);
              expect(() => controller.end(), returnsNormally);
              
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );
    });
  });

  group('SpotlightOverlayPainter', () {
    test('should handle zero animation value', () {
      final painter = SpotlightOverlayPainter(
        targetRect: const Rect.fromLTWH(100, 100, 50, 50),
        animationValue: 0.0,
      );

      // Should not throw when creating painter with zero animation
      expect(painter.animationValue, equals(0.0));
    });

    test('should calculate correct properties', () {
      final painter = SpotlightOverlayPainter(
        targetRect: const Rect.fromLTWH(100, 100, 50, 50),
        animationValue: 0.5,
      );

      expect(painter.targetRect, equals(const Rect.fromLTWH(100, 100, 50, 50)));
      expect(painter.animationValue, equals(0.5));
    });
  });
}