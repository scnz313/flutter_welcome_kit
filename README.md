# flutter_welcome_kit

A beautiful, customizable onboarding/tour guide kit for Flutter apps. Highlight widgets, display tooltips, and guide your users step by step — perfect for tutorials and product tours.

---

## Features

- Highlight any widget using `GlobalKey`
- Tooltip with title, description, button, and arrow
- Customizable background color per step
- Auto-advance steps after a duration
- Tap outside to skip
- Custom text for action button (e.g., “Next”, “Close”, etc.)
- Optional dark/light mode theming
- Custom alignment and animations
- Optionally show a custom widget in a step

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_welcome_kit: ^1.0.0


---

Getting Started

1. Define your tour steps

List<TourStep> steps = [
  TourStep(
    key: buttonKey,
    title: "Welcome",
    description: "This is your main button.",
    backgroundColor: Colors.white,
    buttonLabel: "Next",
    isLast: false,
  ),
  TourStep(
    key: profileKey,
    title: "Your Profile",
    description: "Check your profile settings here.",
    backgroundColor: Colors.deepPurple,
    buttonLabel: "Got it",
    isLast: true,
  ),
];

2. Start the tour

WelcomeTourController().start(context, steps);


---

TourStep Parameters

Property	Type	Description

key	GlobalKey	Target widget key
title	String	Tooltip title
description	String	Tooltip content
alignment	TourAlignment	Arrow position (top, bottom, left, right, center)
backgroundColor	Color	Tooltip background color (default: white)
buttonLabel	String?	Optional button text (“Next”, “Close”, etc.)
isLast	bool	Marks the last step; button text becomes “Close”
duration	Duration	Duration before auto-next (default: 4s)
customWidget	Widget?	Optional full custom content inside tooltip



---

Customization

Auto-advance: Set duration per step

Button text: Use buttonLabel to override default

Arrow: Built-in pointing arrow, animated with pulse

Dark mode: Tooltip adapts based on app theme

Custom UI: Override customWidget to show any layout



---

License

MIT License


---

Contributions

PRs welcome! Feel free to submit issues, suggestions, or improvements.

---

## Inline Docs Example

Here's how a class like `TourStep` should be documented:

```dart
/// Represents a single step in the onboarding tour.
class TourStep {
  /// The widget key to highlight.
  final GlobalKey key;

  /// The tooltip title text.
  final String title;

  /// The tooltip description text.
  final String description;

  /// Where the tooltip appears relative to the target.
  final TourAlignment alignment;

  /// Optional custom content to display instead of default layout.
  final Widget? customWidget;

  /// Background color of the tooltip.
  final Color backgroundColor;

  /// Duration before auto-advancing (if not last).
  final Duration duration;

  /// Custom label for the action button (e.g., “Next”, “Close”).
  final String? buttonLabel;

  /// If true, shows “Close” instead of “Next”.
  final bool isLast;

  /// Create a new [TourStep].
  TourStep(
    this.backgroundColor,
    this.buttonLabel,
    this.isLast, {
    required this.key,
    required this.title,
    required this.description,
    this.alignment = TourAlignment.bottom,
    this.customWidget,
    this.duration = const Duration(seconds: 4),
  });
}
