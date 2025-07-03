/// Flutter Welcome Kit
///
/// A lightweight, highly-customisable onboarding solution for Flutter
/// applications.  It provides spotlight overlays, contextual tooltips and a
/// simple API for guiding users through your app’s features.
///
/// This file re-exports the public API so package consumers only need to
/// `import 'package:flutter_welcome_kit/flutter_welcome_kit.dart';`.

library flutter_welcome_kit;

// ──────────────────────────── CORE ──────────────────────────────────────────
export 'core/tour_config.dart';
export 'core/tour_step.dart';
export 'core/tour_controller.dart';
export 'core/overlay_painter.dart';

// ────────────────────────── WIDGETS ─────────────────────────────────────────
export 'widgets/spotlight.dart';
export 'widgets/tooltip_card.dart';
export 'widgets/tooltip_overlay_wrapper.dart';
